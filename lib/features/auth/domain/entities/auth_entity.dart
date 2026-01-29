class AuthEntity {
  final String id;
  final String username;
  final String email;
  final String? fullName; // ✅ Add this
  final String? bio; // ✅ Add this
  final String? token; // JWT token
  final String?
  profilePicture; // ✅ Changed from profileImageUrl to match backend

  AuthEntity({
    required this.id,
    required this.username,
    required this.email,
    this.fullName, // ✅ Add this
    this.bio, // ✅ Add this
    this.token,
    this.profilePicture, // ✅ Changed name
  });

  /// Factory to create AuthEntity from a Map (e.g., backend JSON)
  factory AuthEntity.fromMap(Map<String, dynamic> map, {String? token}) {
    return AuthEntity(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'], // ✅ Add this
      bio: map['bio'], // ✅ Add this
      token: token,
      profilePicture: map['profilePicture'], // ✅ Match backend field name
    );
  }

  /// Convert AuthEntity to a Map (optional, useful for local storage)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'fullName': fullName, // ✅ Add this
      'bio': bio, // ✅ Add this
      'token': token,
      'profilePicture': profilePicture, // ✅ Changed name
    };
  }

  /// Optional: copyWith to update AuthEntity
  AuthEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName, // ✅ Add this
    String? bio, // ✅ Add this
    String? token,
    String? profilePicture, // ✅ Changed name
  }) {
    return AuthEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName, // ✅ Add this
      bio: bio ?? this.bio, // ✅ Add this
      token: token ?? this.token,
      profilePicture: profilePicture ?? this.profilePicture, // ✅ Changed name
    );
  }
}
