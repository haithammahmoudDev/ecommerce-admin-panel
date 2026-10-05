import '../../../../utils/formatters/formatter.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String image;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String parentId;

   const CategoryEntity({
    required this.name,
    required this.image,
    this.isFeatured = false,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.parentId = '',
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? parentId,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      parentId: parentId ?? this.parentId,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

   static const CategoryEntity empty = CategoryEntity(
    id: '',
    name: '',
    image: '',
    isFeatured: false,
    parentId: '',
  );

  String get formattedDate => createdAt != null ? TFormatter.formatDate(createdAt!) : '';



}
