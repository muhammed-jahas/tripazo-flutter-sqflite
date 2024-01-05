class SigninValidate {
  static String? usernameError;
  static String? passwordError;

  static void validateInputs(String username, String password) {
    if (username.trim().isEmpty) {
      usernameError = 'Invalid Credentials';
    } else {
      usernameError = null;
    }

    if (password.isEmpty) {
      passwordError = 'Invalid Credentials';
    } else {
      passwordError = null;
    }
  }
}


