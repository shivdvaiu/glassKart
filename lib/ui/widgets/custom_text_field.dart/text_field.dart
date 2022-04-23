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
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.isObsecure = false,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.height = 50,
      this.horizontalContentPadding = 2,
 
      this.textInputType = TextInputType.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final inputBorder = OutlineInputBorder(
      borderSide:
          Divider.createBorderSide(context, color: Color(0xffeaefff), width: 1.5),
    );

    return Container(
      height: 60,
      width: Responsive.isMobile(context)?null:MediaQuery.of(context).size.width/2,
      child: TextField(
        cursorColor: colorScheme.background,
        onChanged: onChanged,
        style: textTheme.bodyText2!.copyWith(
       fontSize: Responsive.isMobile(context) ? 9.sp : 3.sp,
                letterSpacing: 0.50,
                color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          
          contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalContentPadding.toDouble(), vertical:0),
          suffixIcon: suffixIcon,
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
