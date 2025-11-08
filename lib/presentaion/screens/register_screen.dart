import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';

import 'package:quran_tracker/data/student.dart';
import 'package:quran_tracker/data/tutor.dart';
import 'package:quran_tracker/data/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _role = 'حافظ'; // الدور الافتراضي
  final Uuid uuid = const Uuid(); // لإنشاء ID فريد

  // حفظ الجلسة
  //الفكرة: بعد تسجيل الدخول، التطبيق يعرف من هو المستخدم وكم الدور، حتى لو أغلق التطبيق.
  Future<void> _saveSession(String id, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    await prefs.setString('userRole', role);
  }

  // دالة التسجيل
  void _register() async {
    if (_formKey.currentState!.validate()) {
      //هذا المعرف يُستخدم لتعريف المحفظ داخل قاعدة البيانات.
      //uuid.v4() يعطي معرف فريد عشوائي لكل مستخدم، لتجنب التكرار في قاعدة البيانات.
      final id = uuid.v4();

      try {
        //💡 الفكرة: هنا نربط بين ما كتبه المستخدم في الحقول وبين قاعدة البيانات.
        // تسجيل "محفظ"
        if (_role == 'محفظ') {
          // إنشاء كائن Tutor
          final tutor = Tutor(
            id: id,
            name: _nameController.text,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          //تخزين الكائن في قاعدة البيانات
          await AppDatabase.instance.insertTutor(tutor);
        }

      

        // تسجيل "مشرف"
        else if (_role == 'مشرف') {
          final admin = Admin(
            id: id,
            name: _nameController.text,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          await AppDatabase.instance.insertAdmin(admin);
        }

        // حفظ الجلسة
        await _saveSession(id, _role);

        // رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح!')),
        );

        // الانتقال لصفحة تسجيل الدخول
        Navigator.pushReplacementNamed(context, Routes.login);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التسجيل: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF9),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF9FAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ابدأ رحلتك مع تطبيق حافظ 💚',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // الاسم الكامل
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF43A047)),
                            labelText: 'الاسم الكامل',
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // البريد الإلكتروني
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF43A047)),
                            labelText: 'البريد الإلكتروني',
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'البريد الإلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // كلمة المرور
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
                            if (value.length < 4) {
                              return 'كلمة المرور قصيرة جدًا';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // اختيار نوع الحساب
                        DropdownButtonFormField<String>(
                          value: _role,
                          items: const [
                            DropdownMenuItem(value: 'حافظ', child: Text('حافظ')),
                            DropdownMenuItem(value: 'محفظ', child: Text('محفظ')),
                            DropdownMenuItem(value: 'مشرف', child: Text('مشرف')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _role = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'اختر نوع الحساب',
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // زر التسجيل
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
                            onPressed: _register,
                            child: const Text(
                              'تسجيل',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

