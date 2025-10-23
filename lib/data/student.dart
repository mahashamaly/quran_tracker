class Student {
  final String id;
  final String name;
  final int age;
  final String phoneNumber;
  final String tutorId;
  final String email;
  final String password;
  String currentSurah;
  int memorizedParts;
  String evaluation;
  String notes;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.phoneNumber,
    required this.tutorId,
    required this.email,
    required this.password,
    this.currentSurah = '',
    this.memorizedParts = 0,
    this.evaluation = '',
    this.notes = '',
  });

  Student.empty()
      : id = '',
        name = '',
        age = 0,
        phoneNumber = '',
        tutorId = '',
        email = '',
        password = '',
        currentSurah = '',
        memorizedParts = 0,
        evaluation = '',
        notes = '';

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      tutorId: map['tutorId'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      currentSurah: map['currentSurah'] ?? '',
      memorizedParts: map['memorizedParts'] ?? 0,
      evaluation: map['evaluation'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'phoneNumber': phoneNumber,
      'tutorId': tutorId,
      'email': email,
      'password': password,
      'currentSurah': currentSurah,
      'memorizedParts': memorizedParts,
      'evaluation': evaluation,
      'notes': notes,
    };
  }
}
