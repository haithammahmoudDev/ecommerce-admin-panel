import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/repos/category_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../media/data/models/image_model.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/category_model.dart';
import '../../../domain/entities/category_entity.dart';
import '../category/category_cubit.dart';
import '../create_category/create_category_state.dart';

part 'edit_category_state.dart';

class EditCategoryCubit extends Cubit<EditCategoryState> {
  final CategoryRepo _categoryRepo;
  EditCategoryCubit({required this._categoryRepo}) : super(EditCategoryState());

  /// FIX: init() كان بيتجاهل parentId بتاع الفئة الأصلية تماماً، فأي حفظ
  /// (حتى لو المستخدم غيّر الصورة بس) كان بيمسح الـ parentId ويحوّل أي
  /// Subcategory لفئة رئيسية بالغلط.
  ///
  /// هنا بنجيب الفئة الأم (Parent) مباشرة من Firestore باستخدام
  /// category.parentId، بدل الاعتماد على أي Cubit تاني يكون لسه مش محمّل.
  Future<void> init(CategoryEntity category) async {
    emit(state.copyWith(
      imageUrl: category.image,
      isFeatured: category.isFeatured,
    ));

    if (category.parentId == null || category.parentId!.isEmpty) {
      // الفئة دي أصلاً فئة رئيسية (Top-Level)، مفيش Parent نجيبه
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(category.parentId)
          .get();

      final data = doc.data();
      if (data == null) return; // الـ Parent اتمسح أو مش موجود، سيبها null

      final parentEntity = CategoryEntity(
        id: doc.id,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        parentId: data['parentId'],
        isFeatured: data['isFeatured'] ?? false,
      );

      emit(state.copyWith(selectedParent: parentEntity));
    } catch (_) {
      // فشل جلب الـ Parent (مشكلة شبكة مثلاً) — نسيب selectedParent فاضية
      // بدل ما نوقف الشاشة بالكامل؛ لو المستخدم حفظ من غير ما يختاره يدوي
      // هيترفض الحفظ أو يتحفظ بدون Parent حسب منطق editCategory أدناه.
    }
  }

  void selectParentCategory(CategoryEntity category) {
    emit(state.copyWith(selectedParent: category));
  }

  void toggleFeatured(bool? value) {
    emit(state.copyWith(isFeatured: value ?? false));
  }

  Future<void> editCategory({
    required TextEditingController nameController,
    required BuildContext context,
    required String id,
  }) async {
    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final CategoryModel newRecord = CategoryModel(
      name: nameController.text.trim(),
      image: state.imageUrl,
      id: id,
      createdAt: DateTime.now(),
      isFeatured: state.isFeatured ?? false,
      parentId: state.selectedParent?.id ?? '',
    );

    final result = await _categoryRepo.editCategory(category: newRecord);

    result.fold(
          (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(title: 'Oh Snap', message: error.message, context: context);
      },
          (_) {
        final categoryController = context.read<CategoryCubit>();

        // 1. تحديث العنصر محلياً في الـ Cubit
        categoryController.updateItemInLists(newRecord.toEntity());

        // 2. إيقاف دائرة التحميل وإظهار الرسالة
        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Record updated successfully.', context: context);
        context.pop();
      },
    );
  }

  /// Pick Thumbnail Image from Media
  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    final selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageModel selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}