import 'dart:io';

import 'package:eye_glass_store/data/enums/auth_enums/auth_enums.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/resources/app_strings/app_strings.dart';
import 'package:eye_glass_store/ui/resources/responsive/responsive.dart';
import 'package:eye_glass_store/ui/view_models/auth/auth_view_model.dart';
import 'package:eye_glass_store/ui/view_models/auth/verify_email/verify_email.dart';
import 'package:eye_glass_store/ui/widgets/custom_text_field.dart/text_field.dart';
import 'package:eye_glass_store/ui/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:eye_glass_store/utils/utilities/dialogs/circular_dialog.dart';
import 'package:eye_glass_store/utils/utilities/routes/routes.dart';
import 'package:eye_glass_store/utils/utilities/snack_bar/snack_bar.dart';
import 'package:eye_glass_store/utils/validations/is_valid_email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  bool passwordVisiblity = true;
  bool confirmVisiblity = true;
  bool isSecure = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                "Lets Gets Started",
                textAlign: TextAlign.center,
                style: textTheme.headline2!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 13.sp : 6.sp),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Create an new account",
                textAlign: TextAlign.center,
                style: textTheme.bodyText1!.copyWith(
                    fontSize: Responsive.isMobile(context) ? 10.sp : 6.sp),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
                prefixIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppAssets.userIcon,
                      height: 20,
                    )
                  ],
                ),
                controller: fullNameController,
                hintText: 'Full Name',
              ),
              _sizedBox(),
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
                hintText: 'Your Email',
              ),
              _sizedBox(),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address.';
                  }
                  return null;
                },
                prefixIcon: Icon(
                  Icons.home,
                  size: 20,
                ),
                controller: addressEditingController,
                hintText: 'Your Address',
              ),
              _sizedBox(),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
                onSuffixTap: () {
                  passwordVisiblity = !passwordVisiblity;
                  setState(() {});
                },
                isObsecure: passwordVisiblity,
                suffixIcon: passwordVisiblity
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
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
              _sizedBox(),
              _sizedBox(),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a confirm password.';
                  }
                  return null;
                },
                onSuffixTap: () {
                  confirmVisiblity = !confirmVisiblity;
                  setState(() {});
                },
                isObsecure: confirmVisiblity,
                suffixIcon: confirmVisiblity
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                prefixIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppAssets.message,
                      height: 20,
                    )
                  ],
                ),
                controller: confirmController,
                hintText: 'Confirm Password',
              ),
              ListTile(
                title: Text(
                  "Security",
                  style: textTheme.bodyText2!.copyWith(
                      fontSize: Responsive.isMobile(context) ? 10.sp : 3.sp,
                      letterSpacing: 0.50,
                      color: colorScheme.secondaryContainer),
                ),
                trailing: Platform.isAndroid
                    ? Switch(
                        onChanged: (value) {
                          isSecure = !isSecure;
                          setState(() {});
                        },
                        value: isSecure,
                        activeColor: colorScheme.primary,
                        activeTrackColor: colorScheme.primary,
                        inactiveThumbColor: colorScheme.primary,
                        inactiveTrackColor:
                            colorScheme.primary.withOpacity(0.5),
                      )
                    : CupertinoSwitch(
                        onChanged: (value) {},
                        value: isSecure,
                      ),
              ),
              PrimaryElevatedBtn(
                  buttonText: "Sign Up",
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      // showSnackBar(context, "Enter Required Fields");
                    }

                    if (fullNameController.text.isEmpty) {
                      return;
                    }

                    if (passwordController.text != confirmController.text) {
                      return;
                    }

                    if (passwordController.text.length < 6) {
                      showSnackBar(
                          context, "Enter Password Greater then 6 Digits");
                      return;
                    }
                    showCircularProgressBar(context: context);
                    createUser(
                        context: context,
                        signUpProvider: context.read<AuthViewModel>());
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
              _sizedBox(),
              Column(
                children: [
                  Text("Sign up with",
                      style: textTheme.headline1!.copyWith(
                          fontSize: Responsive.isMobile(context) ? 10.sp : 5.sp,
                          color: colorScheme.secondaryContainer)),
                  _sizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _roundedButton(AppAssets.google),
                      SizedBox(
                        width: 20,
                      ),
                      _roundedButton(AppAssets.facebook)
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      "Already have an account? ",
                      style: textTheme.labelMedium!.copyWith(
                          fontSize:
                              Responsive.isMobile(context) ? 10.sp : 4.sp),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: textTheme.headline2!.copyWith(
                          fontSize:
                              Responsive.isMobile(context) ? 10.sp : 4.sp),
                    ),
                  )
                ],
              ),
              _sizedBox(),
              _sizedBox(),
            ]),
          ),
        ),
      ),
    );
  }

  Container _roundedButton(String path) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xffeaefff),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          path,
          height: 30,
        ),
      ),
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 4,
    );
  }

  createUser(
      {required BuildContext context, required AuthViewModel signUpProvider}) {
    signUpProvider
        .signUpUserUsingFirebase(
      email: emailController.text,
      password: passwordController.text,
      username: fullNameController.text,
      isSecure: isSecure,
      context: context,
      address: addressEditingController.text,
    )
        .then((signUpState) {
      Navigator.pop(context);

      switch (signUpState) {
        case SignUpState.ALREADY_HAVE_ACCOUNT:
          showSnackBar(context, AppStrings.alreadyHaveAccountError);
          break;
        case SignUpState.WEAK_PASSWORD:
          showSnackBar(context, AppStrings.weakPassword);
          break;

        case SignUpState.UNKNOWN_ERROR:
          showSnackBar(context, AppStrings.unknownError);
          break;

        case SignUpState.SIGN_UP_SUCCESS:
          // showSnackBar(context, AppStrings.signUpSucceed);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => VerifyEmail(
                        isLoginScreen: false,
                        email: emailController.text,
                        address: addressEditingController.text,
                        isSecure: isSecure,
                        name: fullNameController.text,
                      )));

          break;
        case SignUpState.PASSWORD_NOT_SAME:
          showSnackBar(context, AppStrings.passwordNotMatch);
          break;

        case SignUpState.VALIDATED_FALSE:
          showSnackBar(context, AppStrings.fillRequiredInformation);
          break;
        case SignUpState.VALIDATED_TRUE:
          break;
      }
    });
  }
}
