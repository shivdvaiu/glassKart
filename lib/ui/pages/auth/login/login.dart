import 'dart:io';

import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/data/enums/auth_enums/auth_enums.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/resources/app_strings/app_strings.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:eye_glass_store/ui/view_models/auth/auth_view_model.dart';
import 'package:eye_glass_store/ui/view_models/auth/verify_email/verify_email.dart';
import 'package:eye_glass_store/ui/widgets/custom_text_field.dart/text_field.dart';
import 'package:eye_glass_store/ui/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:eye_glass_store/ui/widgets/secondory_elevated_btn/secondry_elevated_btn.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart' ;
import 'package:eye_glass_store/utils/utilities/dialogs/circular_dialog.dart';
import 'package:eye_glass_store/utils/utilities/routes/routes.dart';
import 'package:eye_glass_store/utils/utilities/snack_bar/snack_bar.dart';
import 'package:eye_glass_store/utils/validations/is_valid_email.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool passwordVisiblity = true;
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  AppAssets.logoTwo,
                  height: 19.h,
                ),
              ),
              _sizedBox(),
              Text(
                AppStrings.title,
                textAlign: TextAlign.center,
                style: textTheme.headline2!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 13.sp : 8.sp),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Sign in to continue",
                textAlign: TextAlign.center,
                style: textTheme.bodyText1!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 10.sp : 4.sp),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                validator: (value) {
                  return validateEmail(value);
                },
                prefixIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppAssets.message,
                      height: 20,
                    )
                  ],
                ),
                controller: emailController,
                hintText: 'Email',
              ),
              _sizedBox(),
              CustomTextField(
                onTapFormField: () {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                isObsecure: passwordVisiblity,
                suffixIcon: passwordVisiblity
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onSuffixTap: () {
                  passwordVisiblity = !passwordVisiblity;
                  setState(() {});
                },
                prefixIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppAssets.password,
                      height: 20,
                    )
                  ],
                ),
                controller: passwordController,
                hintText: 'Password',
              ),
              SizedBox(
                height: 6,
              ),
              _sizedBox(),
              PrimaryElevatedBtn(
                  buttonText: "Sign In",
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                   
                      // showSnackBar(context, "Enter Required Fields");
                    }

                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      return;
                    }

                    showCircularProgressBar(context: context);
                    var loginProvider = context.read<AuthViewModel>();
                    loginProvider
                        .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim())
                        .then((signInState) {
                      Navigator.pop(context);

                      switch (signInState) {
                        case SignInState.USER_NOT_FOUND:
                          showSnackBar(context, AppStrings.noEmailFound);
                          break;

                        case SignInState.UNKNOWN_ERROR:
                          showSnackBar(context, AppStrings.unknownError);
                          break;
                        case SignInState.WRONG_PASSWORD:
                          showSnackBar(context, AppStrings.wrongPassword);
                          break;
                        case SignInState.INVALID_EMAIL:
                          showSnackBar(context, AppStrings.invalidEmail);
                          break;
                        case SignInState.SIGN_IN_SUCCESS:
                          SharedPreferences prefs =
                              locator.get<SharedPreferences>();

                          prefs.setBool("isUserLoggedIn", true);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      VerifyEmail(isLoginScreen: true)));
                          break;
                        default:
                      }
                    });
                  }),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      color: colorScheme.secondaryContainer.withOpacity(0.3),
                      height: 0.5,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("OR",
                      style: textTheme.headline1!.copyWith(
                          fontSize: Responsive.isMobile(context) ? 10.sp : 4.sp,
                          color: colorScheme.secondaryContainer)),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      color: colorScheme.secondaryContainer.withOpacity(0.3),
                      height: 0.5,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SecondaryElevatedBtn(
                buttonText: 'Login with Google',
                onPressed: () {},
                leadingIcon: AppAssets.google,
              ),
              SecondaryElevatedBtn(
                buttonText: 'Login with facebook',
                onPressed: () {},
                leadingIcon: AppAssets.facebook,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      "Don’t have an account? ",
                      style: textTheme.labelMedium!.copyWith(
                          fontSize:
                              Responsive.isMobile(context) ? 10.sp : 4.sp),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.signUpScreen);
                    },
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: textTheme.headline2!.copyWith(
                          fontSize:
                              Responsive.isMobile(context) ? 10.sp : 4.sp),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 10,
    );
  }
}
