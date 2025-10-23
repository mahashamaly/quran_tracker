
/*

import 'package:flutter/material.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String userName = '';
  String currentSurah = '';
  int memorizedParts = 0;
  int totalParts = 30;
  String evaluation = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // تحميل بيانات الطالب من SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'طالب';
      currentSurah = prefs.getString('currentSurah') ?? 'سورة البقرة';
      memorizedParts = prefs.getInt('memorizedParts') ?? 0;
      totalParts = prefs.getInt('totalParts') ?? 30;
      evaluation = prefs.getString('evaluation') ?? 'لا يوجد تقييم بعد';
      notes = prefs.getString('notes') ?? 'لا توجد ملاحظات';
    });
  }

  // بطاقة عرض بيانات
  Widget buildCard(String title, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  // تسجيل الخروج
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF43A047),
        title: Text('مرحبا $userName 💚',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // بطاقة السورة الحالية
            buildCard(
              'السورة الحالية',
              Text(
                currentSurah,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            // بطاقة عدد الأجزاء
            buildCard(
              'أجزاء محفوظة',
              Column(
                children: [
                  Text('$memorizedParts / $totalParts',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: totalParts > 0 ? memorizedParts / totalParts : 0,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF43A047),
                    minHeight: 12,
                  ),
                ],
              ),
            ),
            // بطاقة التقييم
            buildCard(
              'تقييمك',
              Text(evaluation,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange)),
            ),
            // بطاقة الملاحظات
            buildCard(
              'ملاحظات المحفظ',
              Text(notes,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.grey, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}

*/