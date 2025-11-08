class Tutor {
  String id;
  String name;
  String email;
  String password;
  String? qualifications;
  String? evaluation; 
  String? notes;      

  Tutor({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.qualifications,
    this.evaluation,
    this.notes,
  });

  //سهولة إنشاء كائن فارغ جاهز للاستخدام
  //من  خلاله بجنب قيمnull
  //''عملت هيك علشان هاى القيم ممنوع تكون نل
  factory Tutor.empty() => Tutor(
        id: '',
        name: '',
        email: '',
        password: '',
        qualifications: null,
        evaluation: null,
        notes: null,
      );

  // تحويل الكائن إلى خريطة لتخزينه في SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'qualifications': qualifications,
      'evaluation': evaluation ?? '',
      'notes': notes ?? '',
    };
  }

  // إنشاء كائن Tutor من خريطة البيانات
  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      qualifications: map['qualifications'],
      evaluation: map['evaluation'],
      notes: map['notes'],
    );
  }
}
