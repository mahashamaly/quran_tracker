import 'package:flutter/material.dart';
import 'package:quran_tracker/data/sqlite-db.dart';
import 'package:quran_tracker/data/tutor.dart';

class TutorsProvider extends ChangeNotifier {
  List<Tutor> _tutors = [];

  List<Tutor> get tutors => _tutors;

  // تحميل كل المحفظين من قاعدة البيانات
  Future<void> loadTutors() async {
    _tutors = await AppDatabase.instance.getTutors();
    notifyListeners();
  }

  // إضافة محفظ جديد
  Future<void> addTutor(Tutor tutor) async {
    await AppDatabase.instance.insertTutor(tutor);
    await loadTutors();
  }

  // تحديث بيانات محفظ
  Future<void> updateTutor(Tutor tutor) async {
    await AppDatabase.instance.updateTutor(tutor);
    await loadTutors();
  }

  // حذف محفظ
  Future<void> deleteTutor(String id) async {
    await AppDatabase.instance.deleteTutor(id);
    await loadTutors();
  }
}
