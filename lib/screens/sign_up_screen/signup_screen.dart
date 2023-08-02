import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/main.dart';
import 'package:tripazo/imagehelpers/image_helper.dart';
import 'package:tripazo/messages/custom_toast.dart';
import 'package:tripazo/validations/signup_validations.dart';
import 'package:tripazo/widgets/other_widgets.dart';
import 'package:tripazo/widgets/input_fields.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoggedIn = false;
  Map<String, dynamic> loggedInUserData = {};

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(updateUsernameError);
    _passwordController.addListener(updatePasswordError);
    _confirmPasswordController.addListener(updateConfirmPasswordError);
    _emailController.addListener(updateMailError);
  }

  Future<void> checkLoggedInStatus() async {
    bool loggedIn = await DatabaseHelper.instance.checkLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });

    if (isLoggedIn) {
      Map<String, dynamic> userData =
          await DatabaseHelper.instance.getLoggedInUserData();
      setState(() {
        loggedInUserData = userData;
      });
    }

    Timer(Duration(milliseconds: 10), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        'Navigation',
        (route) => false,
        arguments: NavigationArguments(loggedInUserData, 0),
      );
    });
  }

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _profileImagePath = '';

  bool _showUsernameError = false;
  bool _showPasswordError = false;
  bool _showConfirmPassError = false;
  bool _showMailError = false;

  final formkey = GlobalKey<FormState>();

  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFEEEEEE),
            child: Column(
              children: [
                //Sign Up Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 180,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Let's\nGo Together.",
                        style: TextStyle(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          OpenProfileSelection(context);
                        },
                        child: CircleAvatar(
                          backgroundImage: _profileImagePath.isNotEmpty
                              ? FileImage(File(_profileImagePath))
                              : null, // Set it to null since we don't want a background image
                          child: _profileImagePath.isNotEmpty
                              ? null // No need to display a child widget when there's a background image
                              : Icon(Icons.person_add_alt_outlined),
                          radius: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                //Sign Up Section
                Form(
                  key: formkey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign up to start planning your trips.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        CustomInputField(
                          hintText: 'Enter Your username',
                          inputIcon: Icons.person_4_outlined,
                          InputControl: _usernameController,
                          errorText: _showUsernameError
                              ? SignupValidate.usernameError
                              : null,
                        ),
                        SizedBox(height: 15),
                        CustomInputField(
                          hintText: 'Enter your password',
                          InputControl: _passwordController,
                          inputIcon: Icons.remove_red_eye_outlined,
                          errorText: _showPasswordError
                              ? SignupValidate.passwordError
                              : null,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomInputField(
                          hintText: 'Confirm your password',
                          InputControl: _confirmPasswordController,
                          inputIcon: Icons.remove_red_eye_outlined,
                          errorText: _showConfirmPassError
                              ? SignupValidate.confirmPasserror
                              : null,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomInputField(
                          hintText: 'Enter your email',
                          InputControl: _emailController,
                          inputIcon: Icons.mail_outlined,
                          errorText:
                              _showMailError ? SignupValidate.mailError : null,
                          keyboardtype: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomSecondaryButton(
                            buttonText: 'Choose a profile picture',
                            onPressed: () {
                              OpenProfileSelection(context);
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        CustomPrimaryButton(
                            buttonText: 'Sign up',
                            onPressed: () async {
                              await SignupValidate.validateInputs(
                                _usernameController,
                                _passwordController,
                                _confirmPasswordController,
                                _emailController,
                              );

                              setState(() {
                                _showUsernameError =
                                    SignupValidate.usernameError != null;
                                _showPasswordError =
                                    SignupValidate.passwordError != null;
                                _showConfirmPassError =
                                    SignupValidate.confirmPasserror != null;
                                _showMailError =
                                    SignupValidate.mailError != null;
                              });
                              if (_profileImagePath.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please choose a profile photo'),
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      // Customize the shape of the snackbar
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                );
                              }

                              final username = _usernameController.text;
                              final isUsernameExists = await DatabaseHelper
                                  .instance
                                  .isUsernameExists(username);

                              if (isUsernameExists) {
                                setState(() {
                                  SignupValidate.usernameError =
                                      'Username Already Exists';
                                  _showUsernameError = true;
                                });
                                return;
                              }
                              if (!_showUsernameError &&
                                  !_showPasswordError &&
                                  !_showConfirmPassError &&
                                  !_showMailError &&
                                  _profileImagePath.isNotEmpty) {
                                Map<String, dynamic> row = {
                                  DatabaseHelper.columnUser:
                                      _usernameController.text,
                                  DatabaseHelper.columnPass:
                                      _passwordController.text,
                                  DatabaseHelper.columnCPass:
                                      _confirmPasswordController.text,
                                  DatabaseHelper.columnEmail:
                                      _emailController.text,
                                  DatabaseHelper.columnProfile:
                                      _profileImagePath,
                                  DatabaseHelper.columnLoggedIn: 1,
                                };

                                await DatabaseHelper.instance.insertRecord(row);
                                await checkLoggedInStatus();
                                showCustomToast(
                                    context,
                                    'Account Created Successfully',
                                    Icons.check_circle_rounded,
                                    Colors.green);

                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           HomeScreen(loggedInUserData: row)),
                                //   (route) => false,
                                // );
                              }
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        // CustomPrimaryButton(
                        //     buttonText: 'Delete',
                        //     onPressed: () async {
                        //       await DatabaseHelper.instance.deleteRecord(1);
                        //       print('record deleted');
                        //       setState(() {});
                        //     }),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // CustomPrimaryButton(
                        //     buttonText: 'Read',
                        //     onPressed: () async {
                        //       final List<Map<String, dynamic>> results =
                        //           await DatabaseHelper.instance.queryDatabase();
                        //       if (results.isEmpty) {
                        //         print('not found');
                        //       } else {
                        //         print(results);
                        //       }

                        //       setState(() {});
                        //     }),
                        //  SizedBox(
                        //     height: 15,
                        //   ),
                        CustomSpanText(
                            mainText: 'Already have an account ?',
                            spanText: 'Sign in here',
                            routeName: 'Signin'),
                        SizedBox(
                          height: 45,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  width: double.infinity,
                  color: Color(0xFFEEEEEE),
                  child: SvgPicture.asset(
                    'assets/logo/tripazo-logo-2.svg',
                    height: 30,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void OpenProfileSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  String? imagePath = await ImageHelper.openCamera();
                  if (imagePath != null) {
                    setState(() {
                      _profileImagePath = imagePath;
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  String? imagePath = await ImageHelper.openGallery();
                  if (imagePath != null) {
                    setState(() {
                      _profileImagePath = imagePath;
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.image_outlined),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateUsernameError() {
    setState(() {
      SignupValidate.usernameError = null; // Clear the previous error
      _showUsernameError = false; // Hide the error message
    });
  }

  void updatePasswordError() {
    setState(() {
      SignupValidate.passwordError = null;
      _showPasswordError = false;
    });
  }

  void updateConfirmPasswordError() {
    setState(() {
      SignupValidate.confirmPasserror = null;
      _showConfirmPassError = false;
    });
  }

  void updateMailError() {
    setState(() {
      SignupValidate.mailError = null;
      _showMailError = false;
    });
  }
}
