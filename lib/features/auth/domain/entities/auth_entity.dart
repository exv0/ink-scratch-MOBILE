class AuthEntity {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? gender;
  final String? bio;
  final String? token;
  final String? profilePicture;
  final String? role;

  AuthEntity({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.gender,
    this.bio,
    this.token,
    this.profilePicture,
    this.role,
  });

  factory AuthEntity.fromMap(Map<String, dynamic> map, {String? token}) {
    return AuthEntity(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      gender: map['gender'],
      bio: map['bio'],
      token: token,
      profilePicture: map['profilePicture'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'bio': bio,
      'token': token,
      'profilePicture': profilePicture,
      'role': role,
    };
  }

  AuthEntity copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? gender,
    String? bio,
    String? token,
    String? profilePicture,
    String? role,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      token: token ?? this.token,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
    );
  }
}
