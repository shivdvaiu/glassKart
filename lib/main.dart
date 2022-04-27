import 'dart:io';

import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/eye_glass_store.dart';
import 'package:eye_glass_store/ui/pages/auth/login/login.dart';
import 'package:eye_glass_store/ui/pages/home_screen/home_screen.dart';
import 'package:eye_glass_store/ui/resources/app_themes/app_theme.dart';
import 'package:eye_glass_store/ui/view_models/auth/auth_view_model.dart';
import 'package:eye_glass_store/ui/view_models/home_view_model/home_view_model.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart';
import 'package:eye_glass_store/utils/utilities/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC-uoriX5I0IRXdorInczrwDQVkwQaXLUI",
            appId: "1:902530716588:ios:0b7028ce0e6df22125e009",
            messagingSenderId: "902530716588",
            projectId: "products-app-e9c6b"));
  } else {
    await Firebase.initializeApp();
  }
  bool isUserLoggedIn;
  if (kIsWeb == false) {
    SharedPreferences  prefs= locator.get<SharedPreferences>();
    isUserLoggedIn = prefs.getBool(AppConstants.isUserLoggedIn) ?? false;
  }

  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      return MultiProvider(
          providers: _getProviders(),
          child: MaterialApp(
              routes: Routes.routes,
              debugShowCheckedModeBanner: false,
              theme: AppThemes.primaryMaterialTheme,
              home: EyeGlassStore(
                body: HomeScreen(),
              )));
    },
  ));
}

List<SingleChildWidget> _getProviders() {
  return [
    ChangeNotifierProvider(
      create: (ctx) => AuthViewModel(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => HomeViewModel(),
    ),
  ];
}
