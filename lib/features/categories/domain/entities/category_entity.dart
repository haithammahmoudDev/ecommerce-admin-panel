import '../../../../utils/formatters/formatter.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String image;
  final bool isFeatured; // 1. تم تحويلها إلى final لتصبح القيمة ثابتة
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String parentId;

  // 2. تم إضافة كلمة const هنا قبل اسم دالة البناء
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

  // 3. الآن ستعمل هذه النسخة الثابتة بدون أي مشاكل أو أخطاء
  static const CategoryEntity empty = CategoryEntity(
    id: '',
    name: '',
    image: '',
    isFeatured: false,
    parentId: '',
  );

  String get formattedDate => createdAt != null ? TFormatter.formatDate(createdAt!) : '';



}
