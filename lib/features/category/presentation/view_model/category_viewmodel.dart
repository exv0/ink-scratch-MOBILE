import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/hive/hive_service.dart';
import '../../domain/entities/category_entity.dart';
import '../state/category_state.dart';

final categoryViewModelProvider =
    StateNotifierProvider<CategoryViewModel, CategoryState>((ref) {
      return CategoryViewModel();
    });

class CategoryViewModel extends StateNotifier<CategoryState> {
  CategoryViewModel() : super(CategoryState.initial()) {
    loadCategories();
  }

  final HiveService _hiveService = HiveService();

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true);
    try {
      final categories = _hiveService.getAllCategories();
      state = state.copyWith(isLoading: false, categories: categories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createCategory(String name, String? description) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final category = CategoryEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      await _hiveService.addCategory(category);
      final updatedCategories = [...state.categories, category];
      state = state.copyWith(isLoading: false, categories: updatedCategories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateCategory(
    String id,
    String name,
    String? description,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final existingCategory = _hiveService.getCategoryById(id);
      if (existingCategory != null) {
        final updatedCategory = existingCategory.copyWith(
          name: name,
          description: description,
        );
        await _hiveService.updateCategory(updatedCategory);
        final updatedCategories = state.categories
            .map((c) => c.id == id ? updatedCategory : c)
            .toList();
        state = state.copyWith(isLoading: false, categories: updatedCategories);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _hiveService.deleteCategory(id);
      final updatedCategories = state.categories
          .where((c) => c.id != id)
          .toList();
      state = state.copyWith(isLoading: false, categories: updatedCategories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  CategoryEntity? getCategoryById(String id) {
    return _hiveService.getCategoryById(id);
  }
}
