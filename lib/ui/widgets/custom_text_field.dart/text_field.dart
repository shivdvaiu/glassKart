import 'dart:developer';

import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final String hintText;
  final double height;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType textInputType;
  final int horizontalContentPadding;
  final Function(String)? onChanged;
  final Function()? onSuffixTap;
  final Function()? onTapFormField;
  final FormFieldValidator<String>? validator;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.onTapFormField,
      this.isObsecure = false,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.onSuffixTap,
      this.onChanged,
      this.validator,
      this.height = 50,
      this.horizontalContentPadding = 2,
      this.textInputType = TextInputType.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Color(0xffeaefff), width: 1.5),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
      onTap: onTapFormField,
        validator: validator,
        cursorColor: colorScheme.background,
        onChanged: onChanged,
        style: textTheme.bodyText2!.copyWith(
            fontSize: Responsive.isMobile(context) ? 9.sp : 3.sp,
            letterSpacing: 0.50,
            color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          
          focusedErrorBorder:OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Colors.red, width: 1.5),
      ) ,
          contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalContentPadding.toDouble(), vertical: 0),
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: onSuffixTap, icon: suffixIcon!)
              : null,
          prefixIcon: prefixIcon,
          hintStyle: textTheme.bodyText2!.copyWith(
              fontSize: Responsive.isMobile(context) ? 9.sp : 3.sp,
              letterSpacing: 0.50,
              color: colorScheme.secondaryContainer),
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: false,
        ),
        keyboardType: textInputType,
        obscureText: isObsecure,
      ),
    );
  }
}
