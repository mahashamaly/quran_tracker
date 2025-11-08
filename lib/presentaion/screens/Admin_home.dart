
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/tutor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorsProvider extends ChangeNotifier {
  List<Tutor> tutors = [];

  Future<void> loadTutors() async {
    tutors = await AppDatabase.instance.getTutors();
    notifyListeners();
  }

  Future<void> addTutor(Tutor tutor) async {
    await AppDatabase.instance.insertTutor(tutor);
    await loadTutors();
  }

  Future<void> updateTutor(Tutor tutor) async {
    await AppDatabase.instance.updateTutor(tutor);
    await loadTutors();
  }

  Future<void> deleteTutor(String id) async {
    await AppDatabase.instance.deleteTutor(id);
    await loadTutors();
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  String adminName = 'المشرف';
  String adminEmail = 'admin@example.com';

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    Provider.of<TutorsProvider>(context, listen: false).loadTutors();
  }
//loadAdminData: جلب بيانات الادمن من SharedPreferences لعرضها في الصفحة.
  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? 'المشرف';
      adminEmail = prefs.getString('adminEmail') ?? 'admin@example.com';
    });
  }

  void _logout() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TutorsProvider>(context);

    final tabs = [
      // قائمة المحفظين
      provider.tutors.isEmpty
          ? const Center(child: Text('لا يوجد محفظين بعد'))
          : ListView.builder(
              itemCount: provider.tutors.length,
              itemBuilder: (context, index) {
                final t = provider.tutors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(t.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('البريد الإلكتروني: ${t.email}'),
                        Text('المؤهلات: ${t.qualifications ?? "-"}'),
                        Text('التقييم: ${t.evaluation ?? "-"}'),
                        Text('الملاحظات: ${t.notes ?? "-"}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showTutorDialog(tutor: t),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.deleteTutor(t.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // إضافة محفظ
      Center(
        child: ElevatedButton(
          onPressed: () => _showTutorDialog(),
          child: const Text('إضافة محفظ جديد'),
        ),
      ),

      // بروفايل المشرف
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
                'مرحبا بك $adminName',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('البريد الإلكتروني: $adminEmail'),
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
        title: Text('مرحبا بك $adminName'),
        backgroundColor: Colors.green.shade700,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade700,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'المحفظين'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'إضافة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'بروفايل'),
        ],
      ),
    );
  }
//_showTutorDialog: نافذة لإضافة أو تعديل بيانات المحفظ، تشمل: الاسم، البريد، المؤهلات، كلمة المرور، التقييم، الملاحظات.
  void _showTutorDialog({Tutor? tutor}) {
    final nameController = TextEditingController(text: tutor?.name ?? '');
    final emailController = TextEditingController(text: tutor?.email ?? '');
    final qualificationsController = TextEditingController(text: tutor?.qualifications ?? '');
    final passwordController = TextEditingController(text: tutor?.password ?? '');
    final evaluationController = TextEditingController(text: tutor?.evaluation ?? '');
    final notesController = TextEditingController(text: tutor?.notes ?? '');
    final provider = Provider.of<TutorsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tutor == null ? 'إضافة محفظ' : 'تعديل بيانات المحفظ'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
              ),
              TextField(
                controller: qualificationsController,
                decoration: const InputDecoration(labelText: 'المؤهلات'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
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
              final t = Tutor(
                id: tutor?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                email: emailController.text,
                qualifications: qualificationsController.text,
                password: passwordController.text,
                evaluation: evaluationController.text,
                notes: notesController.text,
              );
              if (tutor == null) {
                provider.addTutor(t);
              } else {
                provider.updateTutor(t);
              }
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}



