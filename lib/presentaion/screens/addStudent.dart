import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';

class AddStudentPage extends StatefulWidget {
  //لربط الطالب بالمحفظ
  final String tutorId;
  //تُستدعى بعد حفظ الطالب بنجاح لتحديث قائمة الطلاب في الصفحة الرئيسية.
  final VoidCallback onSaved;

  const AddStudentPage({super.key, required this.tutorId, required this.onSaved});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        //id يُنشأ تلقائيًا بناءً على الوقت الحالي (ليكون فريدًا).
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        phoneNumber: _phoneController.text,
        tutorId: widget.tutorId,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await AppDatabase.instance.insertStudent(student);
      widget.onSaved(); // تحديث قائمة الطلاب في التبويب الأول

      // تنظيف الحقول بعد الحفظ
      _nameController.clear();
      _ageController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة الطالب بنجاح ✅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة طالب"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "اسم الطالب"),
                validator: (value) => value!.isEmpty ? "الاسم مطلوب" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "العمر"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "العمر مطلوب" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "رقم الجوال"),
                validator: (value) => value!.isEmpty ? "رقم الجوال مطلوب" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
                validator: (value) => value!.isEmpty ? "الإيميل مطلوب" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "كلمة المرور"),
                validator: (value) => value!.isEmpty ? "كلمة المرور مطلوبة" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  child: const Text("حفظ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

