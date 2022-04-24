import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/data/models/user_model/user_model.dart';
import 'package:eye_glass_store/ui/pages/auth/login/login.dart';
import 'package:eye_glass_store/ui/pages/home_screen/home_screen.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/view_models/auth/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VerifyEmail extends StatefulWidget {
  bool? isLoginScreen;
  String? email, name, address;

  bool? isSecure;
  VerifyEmail(
      {this.isLoginScreen, this.email, this.address, this.isSecure, this.name});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      context
          .read<AuthViewModel>()
          .sendVerifiedEmail(FirebaseAuth.instance.currentUser!);

      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }
  

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {});

    if (isEmailVerified) {
      final FirebaseFirestore _cloudFirestore =
          locator.get<FirebaseFirestore>();
      UserModel userModel = UserModel(
        email: widget.email!.trim(),
        username: widget.name!.trim(),
        isSecure: widget.isSecure!,
        address: widget.address!,
      );

      _cloudFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userModel.toJson());
      timer.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return isEmailVerified
        ? widget.isLoginScreen!
            ?HomeScreen()
            : LoginScreen()
        : Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.home,color:Colors.transparent),
              centerTitle: true,
              title: Text(
                "Verify Email",
                style: textTheme.bodyText1!.copyWith(fontSize: 10.sp,color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Image.asset(
                    AppAssets.logoTwo,
                    height: 19.h,
                  ),
                ),
                Center(
                  child: Text(
                      "A verification email has been sent to your email",
                      style: textTheme.bodyText1!.copyWith(fontSize: 11.sp)),
                ),
                SizedBox(
                  height: 10,
                ),
              ]),
            ),
          );
  }
}

class AppConstants {}
