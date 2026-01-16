class AuthEntity {
  final String id;
  final String username;
  final String email;
  final String? token; // JWT token

  AuthEntity({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  /// Factory to create AuthEntity from a Map (e.g., backend JSON)
  factory AuthEntity.fromMap(Map<String, dynamic> map, {String? token}) {
    return AuthEntity(
      id: map['_id'] ?? '', // adjust if your backend uses 'id' instead of '_id'
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      token: token,
    );
  }

  /// Convert AuthEntity to a Map (optional, useful for local storage)
  Map<String, dynamic> toMap() {
    return {'_id': id, 'username': username, 'email': email, 'token': token};
  }

  /// Optional: copyWith to update AuthEntity
  AuthEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? token,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
