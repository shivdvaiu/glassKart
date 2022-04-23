import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppThemes {
  static final lightTextColor = Color(0xff3A3A3A);
  static final greyThree = Color(0xff828282);
  static final colorRed = Color(0xffEB5757);

  static final lightBlue = Color(0xff223263);
  static final lightColor =  Color(0xffeaefff);
static final borderColor = Color(0xffeaefff);
static final primaryColor = Color(0xff125B50);
static final secondaryContainer = Color(0xff4E944F);
static final primaryGradient =  LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff125B50),
                      
    Color(0xff4E944F),
    Color(0xff125B50), ],
                    );




                    static final pointColor = Color(0xffffebd3);

                    static final darkGrey =  Color(0xff646464);
  AppThemes._privateConstructor();

  static final lightThemeData = ThemeData.light();
  static final darkThemeData = ThemeData.dark();

  static final primaryMaterialTheme = lightThemeData.copyWith(
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryContainer: secondaryContainer ,
        secondary: Color(0xff4f4f4f),
        secondaryContainer: Color(0xff9098b1),
        background: Colors.white,
        brightness: Brightness.light,
        error: Color(0xff99ff00),
        onBackground: Color(0xfffff6fd),
        onError: Color(0xffe1d7df),
        onSecondary: Color(0xff125B50),
        onPrimary: Color(0xff069A8E),
        onSurface: Color(0xffbb6bd9),
        surface: Color(0xff575a5f),
      ),
      textTheme: lightThemeData.textTheme.copyWith(
        bodyText1: TextStyle(
            color: Color(0xff9098b1),
            fontFamily: AppAssets.fontFamily,
            fontWeight: FontWeight.w400,
            fontSize: 10.sp),
        bodyText2: TextStyle(
            color: Colors.white,
            fontFamily: AppAssets.fontFamily,
            fontWeight: FontWeight.w400),
        labelMedium: TextStyle(
          fontFamily: AppAssets.fontFamily,
          color: Color(0xff2d2b2e),
        ),
        headline1: TextStyle(
            color: Color(0xff4f4f4f),
            fontWeight: FontWeight.w700,
            fontFamily: AppAssets.fontFamily),
        headline2: TextStyle(
            fontSize: 15.sp,
            fontFamily: AppAssets.fontFamily,
            fontWeight: FontWeight.w700,
            color: primaryColor),
        headline4: TextStyle(
          color: Color(0xff2d2b2e),
          fontFamily: AppAssets.fontFamily,
          fontWeight: FontWeight.w600,
        ),
        headline5: TextStyle(
          color: Color(0xff9098b1),
          fontSize: 12.sp,
          fontFamily: AppAssets.fontFamily,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.50,
        ),
        button: TextStyle(fontSize: 16.0, letterSpacing: 1),
        subtitle2: TextStyle(
          fontFamily: AppAssets.fontFamily,
          color: Color(0xff9098b1),
          fontSize: 9.sp,
        ),
        headline3: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: AppAssets.fontFamily),
      ));

  final darkMaterialTheme = darkThemeData.copyWith(
    colorScheme: ColorScheme(
      primary: Colors.white,
      primaryContainer: Colors.white,
      secondary: Color.fromRGBO(0, 149, 246, 1),
      secondaryVariant: Colors.white,
      background: Colors.white,
      brightness: Brightness.light,
      error: Colors.red,
      onBackground: Colors.white,
      onError: Colors.red,
      onSecondary: Colors.white,
      onPrimary: Colors.black,
      onSurface: Colors.white,
      surface: Color.fromRGBO(0, 149, 246, 1),
    ),
    textTheme: darkThemeData.textTheme.apply(
      fontFamily: 'Open Sans',
    ),
  );

  final primaryCupertinoTheme = CupertinoThemeData(
    primaryColor: CupertinoDynamicColor.withBrightness(
      color: Colors.purple,
      darkColor: Colors.cyan,
    ),
  );
}
