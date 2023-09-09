import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tripazo/database/database_helper.dart';

class SignupValidate {
  static String? usernameError;
  static String? passwordError;
  static String? confirmPasserror;
  static String? mailError;

  static validateInputs(
    TextEditingController usernameController,
    TextEditingController passwordController,
    TextEditingController confirmPassController,
    TextEditingController mailController,
  ) async {
    usernameError = null;
    passwordError = null;
    confirmPasserror = null;
    mailError = null;

    usernameError = validateUsername(usernameController.text);
    passwordError = validatePassword(passwordController.text);
    confirmPasserror = validateConfirmPassword(
        passwordController.text, confirmPassController.text);
    mailError = await validateMail(mailController.text);
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username is empty';
    } else if (username.trim().isEmpty) {
      return 'Empty Spaces not allowed';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is empty';
    } else if (password.trim().isEmpty) {
      return 'Empty Spaces not allowed';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm Password is empty';
    } else if (confirmPassword.trim().isEmpty) {
      return 'Empty Spaces not allowed';
    } else if (confirmPassword != password) {
      return 'Password does not match';
    }
    return null;
  }

  static Future<String?> validateMail(String mail) async {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    if (mail.isEmpty) {
      return 'Email is Empty';
    } else if (mail.trim().isEmpty) {
      return 'Empty Spaces not allowed';
    } else if (!emailRegex.hasMatch(mail)) {
      return 'Invalid email';
    } else {
      bool exists = await isEmailExists(mail);
      if (exists) {
        return 'Email already exists';
      }
    }
    return null;
  }

  static Future<bool> isEmailExists(String mail) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db.query(
      DatabaseHelper.usersTable,
      where: '${DatabaseHelper.columnEmail} = ?',
      whereArgs: [mail],
    );
    return result.isNotEmpty;
  }
}
