import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../../common/widgets/loaders/circular_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

 class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(context) ? TColors.darkContainer :
          TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250),
              TAnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  static void popUpCircular(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: TCircularLoader(),
          ),
        ),
      ),
    );
  }

  static stopLoading(BuildContext context) {
    context.pop();
  }
}
