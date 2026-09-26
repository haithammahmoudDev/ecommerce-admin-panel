import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/popups/dialog.dart';
import '../../../domain/entities/product_attribute_entity.dart';
import '../../../domain/entities/product_variation_entity.dart';

part 'prduct_cariations_state.dart';

class ProductVariationsCubit extends Cubit<ProductVariationsState> {
  ProductVariationsCubit() : super(ProductVariationsState());

  // Lists to store controllers for each variation attribute
  final List<Map<ProductVariationEntity, TextEditingController>> stockControllersList = [];
  final List<Map<ProductVariationEntity, TextEditingController>> priceControllersList = [];
  final List<Map<ProductVariationEntity, TextEditingController>> salePriceControllersList = [];
  final List<Map<ProductVariationEntity, TextEditingController>> descriptionControllersList = [];

  /// Initialize controllers for each variation
  void initializeVariationControllers(List<ProductVariationEntity> variations) {
    _clearControllersOnly();

    for (var variation in variations) {
      final stockText = variation.stock > 0 ? variation.stock.toString() : '';
      final priceText = variation.price > 0 ? variation.price.toString() : '';

      // عند التعديل: حساب قيمة الخصم (الفرق بين السعر الأساسي وسعر الخصم) لعرضها في خانة الخصم
      double discountValue = 0.0;
      if (variation.salePrice != null && variation.salePrice! > 0 && variation.salePrice! < variation.price) {
        discountValue = variation.price - variation.salePrice!;
      }
      final salePriceText = discountValue > 0 ? discountValue.toString() : '';
      final descText = variation.description ?? '';

      stockControllersList.add({variation: TextEditingController(text: stockText)});
      priceControllersList.add({variation: TextEditingController(text: priceText)});
      salePriceControllersList.add({variation: TextEditingController(text: salePriceText)});
      descriptionControllersList.add({variation: TextEditingController(text: descText)});
    }

    emit(state.copyWith(productVariations: variations));
  }

  /// Extracts values from TextControllers and updates state list
  List<ProductVariationEntity> getUpdatedVariationsWithInputs() {
    final currentVariations = state.productVariations;
    final List<ProductVariationEntity> updatedList = [];

    for (int i = 0; i < currentVariations.length; i++) {
      final variation = currentVariations[i];

      final stockText = i < stockControllersList.length
          ? stockControllersList[i].values.first.text.trim()
          : '0';
      final priceText = i < priceControllersList.length
          ? priceControllersList[i].values.first.text.trim()
          : '0';
      final salePriceText = i < salePriceControllersList.length
          ? salePriceControllersList[i].values.first.text.trim()
          : '0';
      final descriptionText = i < descriptionControllersList.length
          ? descriptionControllersList[i].values.first.text.trim()
          : '';

      final double parsedPrice = double.tryParse(priceText) ?? 0.0;
      final double discountInput = double.tryParse(salePriceText) ?? 0.0;

      // طرح قيمة الخصم المدخلة من السعر الأساسي لحساب السعر الفعلي بعد الخصم (salePrice)
      double parsedSalePrice = 0.0;
      if (discountInput > 0 && discountInput < parsedPrice) {
        parsedSalePrice = parsedPrice - discountInput;
      }

      updatedList.add(
        variation.copyWith(
          stock: int.tryParse(stockText) ?? 0,
          price: parsedPrice,
          salePrice: parsedSalePrice,
          description: descriptionText,
        ),
      );
    }

    emit(state.copyWith(productVariations: updatedList));
    return updatedList;
  }

  /// حساب نسبة الخصم مباشرة لعرضها أو استخدامها
  String calculateDiscountPercentage(double price, double? salePrice) {
    if (salePrice == null || salePrice <= 0 || price <= 0 || salePrice >= price) return '';
    final percentage = ((price - salePrice) / price) * 100;
    return '${percentage.toStringAsFixed(0)}% OFF';
  }

  /// Function to remove variations with a confirmation dialog
  void removeVariations(BuildContext context) {
    TDialogs.defaultDialog(
      context: context,
      title: 'Remove Variations',
      onConfirm: () {
        resetAllValues();
        Navigator.of(context).pop();
      },
    );
  }

  void setVariationImage(int index, String imageUrl) {
    if (index < 0 || index >= state.productVariations.length) return;
    final updatedVariations = List<ProductVariationEntity>.from(state.productVariations);
    updatedVariations[index] = updatedVariations[index].copyWith(image: imageUrl);
    emit(state.copyWith(productVariations: updatedVariations));
  }

  /// Function to generate variations with a confirmation dialog
  void generateVariationsConfirmation(
      BuildContext context,
      List<ProductAttributeEntity> productAttributes,
      ) {
    TDialogs.defaultDialog(
      context: context,
      confirmText: 'Generate',
      title: 'Generate Variations',
      content:
      'Once the variations are created, you cannot add more attributes. In order to add more variations, you have to delete any of the attributes.',
      onConfirm: () {
        Navigator.of(context).pop();
        generateVariationsFromAttributes(productAttributes);
      },
    );
  }

  /// Function to generate variations from attributes
  void generateVariationsFromAttributes(
      List<ProductAttributeEntity> productAttributes,
      ) {
    _clearControllersOnly();
    final List<ProductVariationEntity> variations = [];

    if (productAttributes.isNotEmpty) {
      final List<List<String>> attributeCombinations = getCombinations(
        productAttributes
            .map((attr) => attr.values ?? <String>[])
            .toList(),
      );

      for (final combination in attributeCombinations) {
        final Map<String, String> attributeValues = Map.fromIterables(
          productAttributes.map((attr) => attr.name ?? ''),
          combination,
        );

        final ProductVariationEntity variation = ProductVariationEntity(
          id: UniqueKey().toString(),
          attributeValues: attributeValues,
        );

        variations.add(variation);

        stockControllersList.add({variation: TextEditingController()});
        priceControllersList.add({variation: TextEditingController()});
        salePriceControllersList.add({variation: TextEditingController()});
        descriptionControllersList.add({variation: TextEditingController()});
      }
    }

    emit(state.copyWith(productVariations: variations));
  }

  /// Get all combinations of attribute values
  List<List<String>> getCombinations(List<List<String>> lists) {
    final List<List<String>> result = [];
    combine(lists, 0, <String>[], result);
    return result;
  }

  void setProductVariations(List<ProductVariationEntity> variations) {
    emit(state.copyWith(productVariations: variations));
  }

  /// Helper function to recursively combine attribute values
  void combine(
      List<List<String>> lists,
      int index,
      List<String> current,
      List<List<String>> result,
      ) {
    if (index == lists.length) {
      result.add(List<String>.from(current));
      return;
    }

    for (final item in lists[index]) {
      final List<String> updated = List<String>.from(current)..add(item);
      combine(lists, index + 1, updated, result);
    }
  }

  /// Internal cleanup helper to release memory safely
  void _clearControllersOnly() {
    for (var controllerMap in stockControllersList) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
    for (var controllerMap in priceControllersList) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
    for (var controllerMap in salePriceControllersList) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
    for (var controllerMap in descriptionControllersList) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }

    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();
  }

  /// Function to reset all values and controllers
  void resetAllValues() {
    _clearControllersOnly();
    emit(state.copyWith(productVariations: []));
  }

  @override
  Future<void> close() {
    _clearControllersOnly();
    return super.close();
  }
}