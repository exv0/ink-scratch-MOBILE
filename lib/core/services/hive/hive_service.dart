import 'package:hive/hive.dart';

import 'package:ink_scratch/features/auth/data/models/auth_hive_model.dart';
import 'package:ink_scratch/features/auth/domain/entities/auth_entity.dart';
import 'package:ink_scratch/features/category/data/models/category_hive_model.dart';
import 'package:ink_scratch/features/category/domain/entities/category_entity.dart';
import 'package:ink_scratch/core/constants/hive_table_constant.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<AuthHiveModel> _authBox;
  late Box _settingsBox;
  late Box<CategoryHiveModel> _categoryBox;

  Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());

    // Open boxes
    _authBox = await Hive.openBox<AuthHiveModel>('authBox');
    _settingsBox = await Hive.openBox('appSettingsBox');
    _categoryBox = await Hive.openBox<CategoryHiveModel>('categoryBox');
  }

  // ==================== AUTH METHODS ====================

  /// Save authenticated user to Hive
  Future<void> saveUser(AuthEntity user) async {
    final hiveModel = AuthHiveModel.fromEntity(user);
    await _authBox.put('current_user', hiveModel);
  }

  /// Get current authenticated user (returns AuthEntity or null)
  AuthEntity? getCurrentUser() {
    final hiveModel = _authBox.get('current_user');
    return hiveModel?.toEntity();
  }

  /// Logout - delete current user
  Future<void> logout() async {
    await _authBox.delete('current_user');
  }

  // ==================== ONBOARDING ====================

  Future<bool> isOnboardingSeen() async {
    return _settingsBox.get(
          HiveTableConstant.onboardingSeenKey,
          defaultValue: false,
        )
        as bool;
  }

  Future<void> setOnboardingSeen() async {
    await _settingsBox.put(HiveTableConstant.onboardingSeenKey, true);
  }

  // ==================== CATEGORY METHODS ====================

  Future<void> addCategory(CategoryEntity category) async {
    final hiveModel = CategoryHiveModel.fromEntity(category);
    await _categoryBox.put(category.id, hiveModel);
  }

  Future<void> updateCategory(CategoryEntity category) async {
    final hiveModel = CategoryHiveModel.fromEntity(category);
    await _categoryBox.put(category.id, hiveModel);
  }

  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  CategoryEntity? getCategoryById(String id) {
    final hiveModel = _categoryBox.get(id);
    return hiveModel?.toEntity();
  }

  List<CategoryEntity> getAllCategories() {
    return _categoryBox.values.map((e) => e.toEntity()).toList();
  }
}
