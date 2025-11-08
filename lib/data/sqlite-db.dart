import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'student.dart';
import 'tutor.dart';
import 'admin.dart';

// AppDatabase: إدارة قاعدة البيانات للتطبيق
class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  // الحصول على قاعدة البيانات (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quran_tracker.db');
    return _database!;
  }

  /// تهيئة قاعدة البيانات
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// إنشاء الجداول عند أول تشغيل
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        name TEXT,
        age INTEGER,
        phoneNumber TEXT,
        tutorId TEXT,
        email TEXT,
        password TEXT,
        currentSurah TEXT,
        memorizedParts INTEGER,
        evaluation TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tutors(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT,
        qualifications TEXT,
           evaluation TEXT,
    notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE admins(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tutorRatings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tutorId TEXT,
        studentId TEXT,
        rating REAL,
        comment TEXT,
        date TEXT
      )
    ''');
  }

  // ==================== إدخال البيانات ====================

  Future<void> insertStudent(Student student) async {
    final db = await instance.database;
    await db.insert('students', student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTutor(Tutor tutor) async {
    final db = await instance.database;
    await db.insert('tutors', tutor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAdmin(Admin admin) async {
    final db = await instance.database;
    await db.insert('admins', admin.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ==================== جلب البيانات ====================

  Future<List<Student>> getStudents() async {
    final db = await instance.database;
    final result = await db.query('students');
    return result.map((json) => Student.fromMap(json)).toList();
  }

  Future<List<Tutor>> getTutors() async {
    final db = await instance.database;
    final result = await db.query('tutors');
    return result.map((json) => Tutor.fromMap(json)).toList();
  }

  Future<List<Admin>> getAdmins() async {
    final db = await instance.database;
    final result = await db.query('admins');
    return result.map((json) => Admin.fromMap(json)).toList();
  }

  // ✅ جلب المحفظ حسب الـ ID
  Future<Tutor?> getTutorById(String tutorId) async {
    final db = await instance.database;
    final result = await db.query('tutors', where: 'id = ?', whereArgs: [tutorId]);
    if (result.isNotEmpty) {
      return Tutor.fromMap(result.first);
    }
    return null;
  }

  // ✅ جلب الطلاب حسب tutorId
  Future<List<Student>> getStudentsByTutorId(String tutorId) async {
    final db = await instance.database;
    final result = await db.query('students', where: 'tutorId = ?', whereArgs: [tutorId]);
    return result.map((json) => Student.fromMap(json)).toList();
  }

  // ==================== تسجيل الدخول ====================

  Future<Student?> loginStudent(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'students',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return Student.fromMap(result.first);
    return null;
  }

  Future<Tutor?> loginTutor(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'tutors',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return Tutor.fromMap(result.first);
    return null;
  }

  Future<Admin?> loginAdmin(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'admins',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return Admin.fromMap(result.first);
    return null;
  }

  // ==================== تحديث بيانات ====================

  Future<void> updateTutor(Tutor tutor) async {
    final db = await instance.database;
    await db.update('tutors', tutor.toMap(), where: 'id = ?', whereArgs: [tutor.id]);
  }

  Future<void> updateStudent(Student student) async {
    final db = await instance.database;
    await db.update('students', student.toMap(), where: 'id = ?', whereArgs: [student.id]);
  }

  // ==================== حذف بيانات ====================

  Future<void> deleteTutor(String tutorId) async {
    final db = await instance.database;
    await db.delete('tutors', where: 'id = ?', whereArgs: [tutorId]);
    await db.delete('tutorRatings', where: 'tutorId = ?', whereArgs: [tutorId]);
  }

  Future<void> deleteStudent(String studentId) async {
    final db = await instance.database;
    await db.delete('students', where: 'id = ?', whereArgs: [studentId]);
  }

  // ==================== التقييم ====================

  Future<void> insertRating(
      String tutorId, String studentId, double rating, String comment, String date) async {
    final db = await instance.database;
    await db.insert('tutorRatings', {
      'tutorId': tutorId,
      'studentId': studentId,
      'rating': rating,
      'comment': comment,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getRatingsForTutor(String tutorId) async {
    final db = await instance.database;
    final results = await db.query('tutorRatings', where: 'tutorId = ?', whereArgs: [tutorId]);

    return results.map((r) {
      return {
        'id': r['id'],
        'tutorId': r['tutorId'],
        'studentId': r['studentId'],
        'rating': (r['rating'] is int) ? (r['rating'] as int).toDouble() : r['rating'],
        'comment': r['comment'],
        'date': r['date'],
      };
    }).toList();
  }

  // ==================== حذف قاعدة البيانات ====================

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran_tracker.db');
    await deleteDatabase(path);
  }


/************ */
// في AppDatabase class

Future<Student?> getStudentById(String id) async {
  final db = await database; // افترض أنك عندك getter باسم database
  final maps = await db.query(
    'students',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    return Student.fromMap(maps.first); // افترض أن عندك fromMap لتحويل البيانات لكائن Student
  } else {
    return null;
  }
}

}
