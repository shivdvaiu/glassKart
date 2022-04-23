enum ViewState { Ideal, Busy }
enum AuthState { SignIn, SignUp }

/// In Sign Up Screen
enum SignUpState {
  ALREADY_HAVE_ACCOUNT,
  WEAK_PASSWORD,
  UNKNOWN_ERROR,
  SIGN_UP_SUCCESS,
  PASSWORD_NOT_SAME,
  VALIDATED_FALSE,
  VALIDATED_TRUE,
  
}

/// In Sign In Screen
enum SignInState {
  WRONG_PASSWORD,
  USER_NOT_FOUND,
  UNKNOWN_ERROR,
  SIGN_IN_SUCCESS,
  INVALID_EMAIL
}

