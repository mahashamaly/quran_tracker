import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';
import 'package:quran_tracker/presentaion/screens/addStudent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorHomePage extends StatefulWidget {
  const TutorHomePage({super.key});

  @override
  State<TutorHomePage> createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  int _currentIndex = 0;
  String tutorId = '';
  String tutorName = '';
  String tutorEmail = '';
  //قائمة الطلاب الذين يتبعون هذا المحفظ
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadTutorAndStudents();
  }

  Future<void> _loadTutorAndStudents() async {
    final prefs = await SharedPreferences.getInstance();
    tutorId = prefs.getString('tutorId') ?? prefs.getString('userId') ?? '';
    tutorName = prefs.getString('tutorName') ?? '';
    tutorEmail = prefs.getString('tutorEmail') ?? '';
    //التحقق إذا كان معرف المحفظ موجودًا
    if (tutorId.isNotEmpty) {
      final data = await AppDatabase.instance.getStudentsByTutorId(tutorId);
      setState(() {
        students = data;
      });
    }
  }
//لإعادة تحميل قائمة الطلاب بعد أي عملية تعديل أو حذف.
  void _loadStudents() async {
    final data = await AppDatabase.instance.getStudentsByTutorId(tutorId);
    setState(() {
      students = data;
    });
  }

  void _deleteStudent(String id) async {
    await AppDatabase.instance.deleteStudent(id);
    _loadStudents();
  }

  void _editStudent(Student student) async {
    final surahController = TextEditingController(text: student.currentSurah);
    final partsController = TextEditingController(text: student.memorizedParts.toString());
    final evaluationController = TextEditingController(text: student.evaluation);
    final notesController = TextEditingController(text: student.notes);

    final updatedStudent = await showDialog<Student>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات الطالب'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('الاسم: ${student.name}'),
              TextField(
                controller: surahController,
                decoration: const InputDecoration(labelText: 'السورة الحالية'),
              ),
              TextField(
                controller: partsController,
                decoration: const InputDecoration(labelText: 'الأجزاء المنجزة'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: evaluationController,
                decoration: const InputDecoration(labelText: 'التقييم'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'الملاحظات'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = Student(
                id: student.id,
                name: student.name,
                age: student.age,
                phoneNumber: student.phoneNumber,
                tutorId: student.tutorId,
                email: student.email,
                password: student.password,
                currentSurah: surahController.text,
                memorizedParts: int.tryParse(partsController.text) ?? 0,
                evaluation: evaluationController.text,
                notes: notesController.text,
              );
              Navigator.pop(context, updated);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (updatedStudent != null) {
      await AppDatabase.instance.updateStudent(updatedStudent);
      _loadStudents();
    }
  }

  void _logout() async {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      // صفحة الطلاب
      students.isEmpty
          ? Center(
              child: Text('مرحبا بك $tutorName\nلا يوجد طلاب بعد'),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final s = students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(s.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('العمر: ${s.age}'),
                        Text('رقم الجوال: ${s.phoneNumber}'),
                        Text('السورة الحالية: ${s.currentSurah.isEmpty ? "-" : s.currentSurah}'),
                        Text('الأجزاء المنجزة: ${s.memorizedParts}'),
                        Text('التقييم: ${s.evaluation.isEmpty ? "-" : s.evaluation}'),
                        Text('الملاحظات: ${s.notes.isEmpty ? "-" : s.notes}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editStudent(s),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStudent(s.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // إضافة طالب
      AddStudentPage(
        tutorId: tutorId,
        onSaved: _loadStudents,
      ),

      // صفحة البروفايل
      Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'مرحبا بك $tutorName',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا بك محفظ $tutorName'),
        backgroundColor: Colors.green.shade700,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade700,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الطلاب'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'إضافة طالب'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'بروفايل'),
        ],
      ),
    );
  }
}
