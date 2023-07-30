import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/navigation/navigation.dart';
import 'package:tripazo/screens/welcome_screen/welcome_screen.dart';
import 'package:tripazo/styles/color_styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  Map<String, dynamic> loggedInUserData = {};

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
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
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    isLoggedIn
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationItems(loggedInUserData),
            ),
          )
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Add your logo widget here
            SvgPicture.asset(
              'assets/logo/tripazo-logo-white.svg',
              height: 200,
            ),
            SizedBox(height: 40),        
          ],
        ),
      ),
    );
  }
}
