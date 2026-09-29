import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_attribute_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/popups/dialog.dart';
part 'product_attributes_state.dart';



class ProductAttributesCubit extends Cubit<ProductAttributesState> {
  ProductAttributesCubit() : super(const ProductAttributesState());

  final GlobalKey<FormState> attributesFormKey = GlobalKey<FormState>();
  final TextEditingController attributeName = TextEditingController();
  final TextEditingController attributes = TextEditingController();
  void initAttributes(List<ProductAttributeEntity> attributes) {
    emit(state.copyWith(productAttributes: attributes));
  }
  void addNewAttribute() {
    if (attributesFormKey.currentState != null &&
        !attributesFormKey.currentState!.validate()) {
      return;
    }

    // Prepare values from text field input
    final name = attributeName.text.trim();
    final valuesList = attributes.text
        .trim()
        .split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Create new attribute entity
    final newAttribute = ProductAttributeEntity(
      name: name,
      values: valuesList,
    );

    // Add Attribute to the List
    final updatedList =
    List<ProductAttributeEntity>.from(state.productAttributes)
      ..add(newAttribute);

    emit(state.copyWith(productAttributes: updatedList));

    // Clear text fields after adding
    attributeName.clear();
    attributes.clear();
  }

  /// Remove attribute with a confirmation dialog
  void removeAttribute(int index, BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        context.pop();

        final updatedList =
        List<ProductAttributeEntity>.from(state.productAttributes)
          ..removeAt(index);

        emit(state.copyWith(productAttributes: updatedList));
      },
    );
  }

  /// Reset product attributes
  void resetProductAttributes(List<ProductAttributeEntity> list) {
    emit(state.copyWith(productAttributes: list));
  }

  @override
  Future<void> close() {
    attributeName.dispose();
    attributes.dispose();
    return super.close();
  }
}