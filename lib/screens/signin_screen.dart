import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/navigation.dart';
import 'package:tripline/validations/signin_validations.dart';
import 'package:tripline/widgets/other_widgets.dart';
import 'package:tripline/widgets/input_fields.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  bool _showUsernameError = false;
  bool _showPasswordError = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(updateUsernameError);
    _passwordController.addListener(updatePasswordError);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFEEEEEE),
        body: SingleChildScrollView(
          child: Container(
            // color: Color(0xFFEEEEEE),
            child: Column(
              children: [
                SizedBox(height: 20),
                // Sign Up Header
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: AssetImage('assets/images/loginbg.jpg'),
                        fit: BoxFit.cover),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 220,
                          left: 20,
                        ),
                        child: Text(
                          'Plan Your\nJourneys',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Sign Up Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Sign in to start planning your trips.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 28),
                      CustomInputField(
                        hintText: 'Enter Your username',
                        inputIcon: Icons.person_4_outlined,
                        InputControl: _usernameController,
                        errorText: _showUsernameError
                            ? SigninValidate.usernameError
                            : null,
                      ),
                      SizedBox(height: 15),
                      CustomInputField(
                        hintText: 'Enter your password',
                        InputControl: _passwordController,
                        inputIcon: Icons.remove_red_eye_outlined,
                        errorText: _showPasswordError
                            ? SigninValidate.passwordError
                            : null,
                        obscureText: true,
                      ),
                      SizedBox(height: 15),
                      CustomPrimaryButton(
                        buttonText: 'Sign in',
                        onPressed: () async {
                          // Clear previous errors
                          setState(() {
                            _showUsernameError = false;
                            _showPasswordError = false;
                          });

                          final username = _usernameController.text.trim();
                          final password = _passwordController.text.trim();

                          SigninValidate.validateInputs(username, password);

                          if (SigninValidate.usernameError != null ||
                              SigninValidate.passwordError != null) {
                            setState(() {
                              _showUsernameError =
                                  SigninValidate.usernameError != null;
                              _showPasswordError =
                                  SigninValidate.passwordError != null;
                            });
                            return;
                          }

                          bool isUsernameExists = await DatabaseHelper.instance
                              .isUsernameExists(username);

                          if (!isUsernameExists) {
                            setState(() {
                              _showUsernameError = true;
                              SigninValidate.usernameError =
                                  'Invalid Credentials';
                            });
                            return;
                          }

                          bool isValid = await DatabaseHelper.instance
                              .validateUserCredentials(username, password);

                          if (!isValid) {
                            setState(() {
                              _showPasswordError = true;
                              SigninValidate.passwordError = 'Invalid Credentials';
                            });
                            return;
                          }

                          Map<String, dynamic> userData = await DatabaseHelper
                              .instance
                              .getUserDataByUsername(username);

                          await DatabaseHelper.instance
                              .setLoggedInUser(userData);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationItems(
                                userData
                              ),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      CustomSpanText(
                        mainText: 'Don’t have an account ?',
                        spanText: 'Sign up here',
                        routeName: 'Signup',
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  width: double.infinity,
                  color: Color(0xFFEEEEEE),
                  child: SvgPicture.asset(
                    'assets/logo/tripline-logo-2.svg',
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUsernameError() {
    setState(() {
      _showUsernameError = false; // Hide the error message
    });
  }

  void updatePasswordError() {
    setState(() {
      _showPasswordError = false;
    });
  }
}
