import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/student.dart';

class AddStudentPage extends StatefulWidget {
  final String tutorId;
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

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,

        phoneNumber: _phoneController.text,
        tutorId: widget.tutorId,
        email: '',
        password: '',
      );

      await AppDatabase.instance.insertStudent(student);
      widget.onSaved(); // تحديث قائمة الطلاب في التبويب الأول
      _nameController.clear();
      _ageController.clear();
      _phoneController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة الطالب بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
