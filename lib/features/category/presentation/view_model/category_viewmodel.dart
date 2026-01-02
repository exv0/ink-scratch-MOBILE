import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/hive/hive_service.dart';
import '../../data/models/category_hive_model.dart';
import '../../domain/entities/category_entity.dart';
import '../state/category_state.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(() {
      return CategoryViewModel();
    });

class CategoryViewModel extends Notifier<CategoryState> {
  final HiveService _hiveService = HiveService();

  @override
  CategoryState build() {
    // Don't auto-load here, just return initial state
    return CategoryState.initial();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true);

    try {
      final categoryModels = _hiveService.getAllCategories();

      final categories = categoryModels
          .map(
            (model) => CategoryEntity(
              id: model.id,
              name: model.name,
              color: model.color,
              createdAt: model.createdAt,
            ),
          )
          .toList();

      state = state.copyWith(isLoading: false, categories: categories);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load categories',
      );
    }
  }

  Future<void> addCategory(String name, int color) async {
    state = state.copyWith(isLoading: true);

    try {
      final newModel = CategoryHiveModel.create(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        color: color,
      );

      await _hiveService.saveCategory(newModel);

      await loadCategories();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to add category');
    }
  }

  Future<void> updateCategory(String id, String name, int color) async {
    state = state.copyWith(isLoading: true);

    try {
      final existing = _hiveService.getAllCategories().firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Category not found'),
      );

      final updatedModel = CategoryHiveModel(
        id: id,
        name: name.trim(),
        color: color,
        createdAt: existing.createdAt,
      );

      await _hiveService.updateCategory(updatedModel);

      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update category',
      );
    }
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      await _hiveService.deleteCategory(id);

      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete category',
      );
    }
  }
}
