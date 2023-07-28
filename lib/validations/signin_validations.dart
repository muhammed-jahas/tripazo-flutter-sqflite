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


//Old Files
// class SigninValidate {
//   static String? usernameError;
//   static String? passwordError;

//   static void validateInputs(String username, String password) {
//     if (username.trim().isEmpty) {
//       usernameError = 'Username cannot be empty';
//     } else {
//       usernameError = null;
//     }

//     if (password.isEmpty) {
//       passwordError = 'Password cannot be empty';
//     } else {
//       passwordError = null;
//     }
//   }
// }
