class Admin {
  String id;
  String name;
  String email;
  String password;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory Admin.empty() => Admin(id: '', name: '', email: '', password: '');

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
