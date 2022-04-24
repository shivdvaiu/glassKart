import 'package:eye_glass_store/ui/pages/auth/login/login.dart';
import 'package:eye_glass_store/ui/pages/auth/sign_up/sign_up.dart';
import 'package:eye_glass_store/ui/pages/home_screen/home_screen.dart';
import 'package:eye_glass_store/ui/view_models/auth/verify_email/verify_email.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._privateConstructor();

  static const String loginScreen = "/loginScreen";

  static const String signUpScreen = "/singUpScreen";
  static const String homeScreen = "/homeScreen";
  static const String categoryScreen = "/categoryScreen";
  static const String filterScreen = "/filterScreen";
  static const String editProfile = "/editProfile";
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    loginScreen: (_) => LoginScreen(),
    signUpScreen: (_) => SignUpScreen(),
    homeScreen: (_) => HomeScreen(),
  
  };
}
