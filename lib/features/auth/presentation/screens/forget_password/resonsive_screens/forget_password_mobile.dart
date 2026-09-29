import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/header_and_form.dart';

class ForgetPasswordScreenMobile extends StatelessWidget {
  ForgetPasswordScreenMobile({super.key});
  final TextEditingController email = TextEditingController(); //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: HeaderAndForm(formKey: _formKey, email: email,),
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
