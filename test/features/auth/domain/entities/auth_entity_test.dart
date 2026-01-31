// test/features/auth/domain/entities/auth_entity_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ink_scratch/features/auth/domain/entities/auth_entity.dart';

void main() {
  // ── shared fixture ──────────────────────────────────────────────────────
  const Map<String, dynamic> fullMap = {
    '_id': 'abc123',
    'username': 'inkuser',
    'email': 'ink@example.com',
    'fullName': 'Ink User',
    'phoneNumber': '9876543210',
    'gender': 'male',
    'bio': 'A manga enthusiast',
    'profilePicture': 'uploads/pic.jpg',
    'role': 'reader',
  };

  AuthEntity sampleEntity() => AuthEntity(
    id: 'abc123',
    username: 'inkuser',
    email: 'ink@example.com',
    fullName: 'Ink User',
    phoneNumber: '9876543210',
    gender: 'male',
    bio: 'A manga enthusiast',
    token: 'tok_xyz',
    profilePicture: 'uploads/pic.jpg',
    role: 'reader',
  );

  // ── fromMap ─────────────────────────────────────────────────────────────
  group('AuthEntity.fromMap', () {
    test('populates all fields from a complete map', () {
      final entity = AuthEntity.fromMap(fullMap, token: 'tok_xyz');

      expect(entity.id, 'abc123');
      expect(entity.username, 'inkuser');
      expect(entity.email, 'ink@example.com');
      expect(entity.fullName, 'Ink User');
      expect(entity.phoneNumber, '9876543210');
      expect(entity.gender, 'male');
      expect(entity.bio, 'A manga enthusiast');
      expect(entity.token, 'tok_xyz');
      expect(entity.profilePicture, 'uploads/pic.jpg');
      expect(entity.role, 'reader');
    });

    test('defaults id and username/email to empty string when missing', () {
      final entity = AuthEntity.fromMap({});

      expect(entity.id, '');
      expect(entity.username, '');
      expect(entity.email, '');
    });

    test('optional fields are null when absent from map', () {
      final entity = AuthEntity.fromMap({
        '_id': 'x',
        'username': 'u',
        'email': 'e@e.com',
      });

      expect(entity.fullName, isNull);
      expect(entity.phoneNumber, isNull);
      expect(entity.gender, isNull);
      expect(entity.bio, isNull);
      expect(entity.profilePicture, isNull);
      expect(entity.role, isNull);
    });

    test('token defaults to null when not passed', () {
      final entity = AuthEntity.fromMap(fullMap);

      expect(entity.token, isNull);
    });
  });

  // ── toMap ───────────────────────────────────────────────────────────────
  group('AuthEntity.toMap', () {
    test('round-trips through fromMap → toMap preserving all values', () {
      final entity = AuthEntity.fromMap(fullMap, token: 'tok_xyz');
      final map = entity.toMap();

      expect(map['_id'], 'abc123');
      expect(map['username'], 'inkuser');
      expect(map['email'], 'ink@example.com');
      expect(map['fullName'], 'Ink User');
      expect(map['phoneNumber'], '9876543210');
      expect(map['gender'], 'male');
      expect(map['bio'], 'A manga enthusiast');
      expect(map['token'], 'tok_xyz');
      expect(map['profilePicture'], 'uploads/pic.jpg');
      expect(map['role'], 'reader');
    });

    test('includes null values for unset optional fields', () {
      final entity = AuthEntity(id: 'id1', username: 'u', email: 'e@e.com');
      final map = entity.toMap();

      expect(map['fullName'], isNull);
      expect(map['token'], isNull);
      expect(map['bio'], isNull);
    });
  });

  // ── copyWith ────────────────────────────────────────────────────────────
  group('AuthEntity.copyWith', () {
    test('returns a new instance with only the specified field changed', () {
      final original = sampleEntity();
      final updated = original.copyWith(username: 'newuser');

      expect(updated.username, 'newuser');
      // everything else untouched
      expect(updated.id, original.id);
      expect(updated.email, original.email);
      expect(updated.fullName, original.fullName);
      expect(updated.token, original.token);
    });

    test('does not mutate the original entity', () {
      final original = sampleEntity();
      original.copyWith(bio: 'changed bio');

      expect(original.bio, 'A manga enthusiast');
    });

    test('can update multiple fields at once', () {
      final original = sampleEntity();
      final updated = original.copyWith(
        bio: 'New bio',
        profilePicture: 'uploads/new.png',
        role: 'admin',
      );

      expect(updated.bio, 'New bio');
      expect(updated.profilePicture, 'uploads/new.png');
      expect(updated.role, 'admin');
      expect(updated.username, original.username); // unchanged
    });

    test('calling copyWith with no arguments returns equivalent entity', () {
      final original = sampleEntity();
      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.username, original.username);
      expect(copy.email, original.email);
      expect(copy.fullName, original.fullName);
      expect(copy.bio, original.bio);
      expect(copy.token, original.token);
    });
  });
}
