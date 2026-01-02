import 'package:hive/hive.dart';
import '../../domain/entities/category_entity.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 2)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String createdAt;

  CategoryHiveModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
