class AuthEntity {
  final String id;
  final String username;
  final String email;
  final String? token; // if you plan to add real API later

  AuthEntity({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email, 'token': token};
  }

  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      token: map['token'],
    );
  }
}
