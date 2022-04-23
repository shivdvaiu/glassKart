import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eye_glass_store/data/app_locator/app_locator.dart';
import 'package:eye_glass_store/data/enums/auth_enums/auth_enums.dart';
import 'package:eye_glass_store/data/models/user_model/user_model.dart';
import 'package:eye_glass_store/ui/resources/app_strings/app_strings.dart';
import 'package:eye_glass_store/utils/constants/app_constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = locator.get<FirebaseAuth>();
  final FirebaseFirestore _cloudFirestore = locator.get<FirebaseFirestore>();

  Future<SignUpState> signUpUserUsingFirebase({
    required String email,
    required String password,
    required String username,
  }) async {
    if (isValidated(
          email,
          password,
        ) ==
        SignUpState.VALIDATED_TRUE) {
      try {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        UserModel userModel = UserModel(
          email: email.trim(),
          username: username.trim(),
          
        );

        _cloudFirestore
            .collection(AppConstants.users)
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());

        return SignUpState.SIGN_UP_SUCCESS;
      } on FirebaseAuthException catch (e) {
        if (e.code == AppStrings.weakPassword) {
          return SignUpState.WEAK_PASSWORD;
        } else if (e.code == AppStrings.alreadyHaveAccount) {
          return SignUpState.ALREADY_HAVE_ACCOUNT;
        }
      } catch (e) {
        return SignUpState.UNKNOWN_ERROR;
      }
    }

    return isValidated(email, password);
  }

  SignUpState isValidated(email, password) {
    if (email.isEmpty || password.isEmpty) {
      return SignUpState.VALIDATED_FALSE;
    }

    return SignUpState.VALIDATED_TRUE;
  }

  Future<SignInState> signInWithEmailAndPassword(
      {required String email, required password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return SignInState.USER_NOT_FOUND;
      } else if (e.code == AppStrings.wrongPassword) {
        return SignInState.WRONG_PASSWORD;
      } else if (e.code == AppStrings.invalidEmail) {
        return SignInState.INVALID_EMAIL;
      } else {
        return SignInState.UNKNOWN_ERROR;
      }
    }

    return SignInState.SIGN_IN_SUCCESS;
  }

  Future<dynamic> logOut() async {
    FirebaseAuth firebaseAuth = locator.get<FirebaseAuth>();

    await firebaseAuth.signOut();

    return;
  }
}
