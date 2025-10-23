import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';
import 'package:quran_tracker/data/tutor.dart';
import 'package:quran_tracker/data/admin.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      final db = AppDatabase.instance;

      final students = await db.getStudents();
      final tutors = await db.getTutors();
      final admins = await db.getAdmins();

      final student = students.firstWhere(
        (s) =>
            (s.email.toLowerCase() == email || s.name.toLowerCase() == email) &&
            s.password == password,
        orElse: () => Student.empty(),
      );

      final tutor = tutors.firstWhere(
        (t) =>
            (t.email.toLowerCase() == email || t.name.toLowerCase() == email) &&
            t.password == password,
        orElse: () => Tutor.empty(),
      );

      final admin = admins.firstWhere(
        (a) =>
            a.email.toLowerCase() == email &&
            a.password == password,
        orElse: () => Admin.empty(),
      );

      final prefs = await SharedPreferences.getInstance();

      if (student.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ حافظ ✅')),
        );

        await prefs.setString('userId', student.id);
        await prefs.setString('userRole', 'حافظ');
        await prefs.setString('userName', student.name);

        Navigator.pushReplacementNamed(context, Routes.studentHome);

      } else if (tutor.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ محفظ ✅')),
        );

        await prefs.setString('userId', tutor.id);
        await prefs.setString('userRole', 'محفظ');
        await prefs.setString('tutorName', tutor.name);

        Navigator.pushReplacementNamed(context, Routes.teacherHomePage);

      } else if (admin.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ مشرف ✅')),
        );

        await prefs.setString('userId', admin.id);
        await prefs.setString('userRole', 'مشرف');
        await prefs.setString('adminName', admin.name); // حفظ الاسم
        await prefs.setString('adminEmail', admin.email);

        Navigator.pushReplacementNamed(context, Routes.adminHome);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بيانات الدخول غير صحيحة ❌')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مرحبا بك مجددًا 💚',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email, color: Color(0xFF43A047)),
                          labelText: 'البريد الإلكتروني أو اسم المستخدم',
                          filled: true,
                          fillColor: const Color(0xFFF1F8E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني أو الاسم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF43A047)),
                          labelText: 'كلمة المرور',
                          filled: true,
                          fillColor: const Color(0xFFF1F8E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF43A047),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _login,
                          child: const Text(
                            'دخول',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('لا تملك حساب؟ ', style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Routes.registerPage);
                            },
                            child: const Text(
                              'سجل الآن',
                              style: TextStyle(
                                color: Color(0xFF43A047),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';
import 'package:quran_tracker/data/tutor.dart';
import 'package:quran_tracker/data/admin.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🟢 دالة تسجيل الدخول
  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      final db = AppDatabase.instance;

      // 🔹 جلب جميع المستخدمين
      final students = await db.getStudents();
      final tutors = await db.getTutors();
     final admins = await db.getAdmins();

      //🔸 التحقق هل المستخدم "حافظ"
      final student = students.firstWhere(
        (s) =>
            (s.email.toLowerCase() == email || s.name.toLowerCase() == email) &&
            s.password == password,
        orElse: () => Student.empty(),
      );

     // 🔸 التحقق هل المستخدم "محفظ"
      final tutor = tutors.firstWhere(
        (t) =>
            (t.email.toLowerCase() == email || t.name.toLowerCase() == email) &&
            t.password == password,
        orElse: () => Tutor.empty(),
      );

      //🔸 التحقق هل المستخدم "مشرف"
      final admin = admins.firstWhere(
        (a) =>
            a.email.toLowerCase() == email &&
            a.password == password,
        orElse: () => Admin.empty(),
      );

      final prefs = await SharedPreferences.getInstance();

      //🔹 التحقق من الدور المناسب
      if (student.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ حافظ ✅')),
        );

        await prefs.setString('userId', student.id);
        await prefs.setString('userRole', 'حافظ');
        await prefs.setString('userName', student.name); // حفظ الاسم

        Navigator.pushReplacementNamed(context, Routes.studentHome);

      } else if (tutor.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ محفظ ✅')),
        );

        await prefs.setString('userId', tutor.id);
        await prefs.setString('userRole', 'محفظ');
        await prefs.setString('tutorName', tutor.name); // حفظ اسم المحفظ

        Navigator.pushReplacementNamed(context, Routes.teacherHomePage);

      } else if (admin.id.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول كـ مشرف ✅')),
        );

        await prefs.setString('userId', admin.id);
        await prefs.setString('userRole', 'مشرف');
        await prefs.setString('userName', admin.name);

        Navigator.pushReplacementNamed(context, Routes.adminHome);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بيانات الدخول غير صحيحة ❌')),
        );
      }
    }
  }

  // 🟢 واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مرحبا بك مجددًا 💚',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email, color: Color(0xFF43A047)),
                          labelText: 'البريد الإلكتروني أو اسم المستخدم',
                          filled: true,
                          fillColor: const Color(0xFFF1F8E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني أو الاسم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF43A047)),
                          labelText: 'كلمة المرور',
                          filled: true,
                          fillColor: const Color(0xFFF1F8E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF43A047),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _login,
                          child: const Text(
                            'دخول',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('لا تملك حساب؟ ', style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Routes.registerPage);
                            },
                            child: const Text(
                              'سجل الآن',
                              style: TextStyle(
                                color: Color(0xFF43A047),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/