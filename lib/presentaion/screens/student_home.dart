import 'dart:convert';
import 'dart:math'; // نحتاجها لاختيار عبارة عشوائية
import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  Student? currentStudent; // بيانات الطالب
  bool isLoading = true; // حالة تحميل بيانات الطالب

  // متغيرات API للعبارة التحفيزية
  String dailyInfo = '';
  bool isLoadingInfo = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();   // تحميل بيانات الطالب عند بداية الصفحة
    _fetchDailyInfo();    // جلب عبارة تحفيزية عند بداية الصفحة
  }

  // --------------------------
  // تحميل بيانات الطالب من SharedPreferences و SQLite
  // --------------------------
  Future<void> _loadStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('userId');

    if (studentId != null) {
      final student = await AppDatabase.instance.getStudentById(studentId);
      setState(() {
        currentStudent = student;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // لا توجد بيانات طالب
      });
    }
  }

  // --------------------------
  // جلب عبارة تحفيزية من GitHub
  // --------------------------
  Future<void> _fetchDailyInfo() async {
    setState(() => isLoadingInfo = true); // عرض مؤشر التحميل

    try {
      // رابط مباشر للملف JSON على GitHub
      final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/mahashamaly/quran-motivation-data/main/quran_motivation.json',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);      // تحويل JSON إلى Map
        final quotes = data['quotes'] as List;       // استخراج قائمة العبارات

        // اختيار عبارة عشوائية في كل مرة
        final random = Random();
        final randomIndex = random.nextInt(quotes.length);

        setState(() {
          dailyInfo = quotes[randomIndex];
          isLoadingInfo = false; // انتهى التحميل
        });
      } else {
        setState(() {
          dailyInfo = 'فشل تحميل العبارات (${response.statusCode})';
          isLoadingInfo = false;
        });
      }
    } catch (e) {
      setState(() {
        dailyInfo = 'حدث خطأ أثناء تحميل التحفيز: $e';
        isLoadingInfo = false;
      });
    }
  }

  // --------------------------
  // واجهة المستخدم
  // --------------------------
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صفحة الحافظ'),
          centerTitle: true,
          backgroundColor: const Color(0xFF43A047),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator()) // تحميل بيانات الطالب
            : currentStudent == null
                ? const Center(child: Text('لم يتم العثور على بيانات الطالب'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // مرحبا بالطالب
                        Text(
                          'مرحبا، ${currentStudent!.name}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --------------------------
                        // بطاقة العبارة التحفيزية
                        // --------------------------
                        isLoadingInfo
                            ? const Center(child: CircularProgressIndicator())
                            : Card(
                                color: Colors.green[50],
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.menu_book, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          dailyInfo,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        // بطاقة بيانات الطالب
                  
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE8F5E9), Color(0xFFF9FAF9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStudent!.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('العمر: ${currentStudent!.age}'),
                                    Text('رقم الجوال: ${currentStudent!.phoneNumber}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.email, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(currentStudent!.email),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('السورة الحالية: ${currentStudent!.currentSurah}'),
                                    Text('الأجزاء المحفوظة: ${currentStudent!.memorizedParts}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 18, color: Colors.amber),
                                    const SizedBox(width: 6),
                                    Text('التقييم: ${currentStudent!.evaluation}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.note, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(currentStudent!.notes)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // --------------------------
                        // زر تسجيل الخروج
                        // --------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Routes.login);
                            },
                            child: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

