import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  String? appVersion;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppInfo();
  }
  getAppInfo()async {
    PackageInfo packageInfo = await  PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    print(appVersion);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF974C),
                        fontFamily: 'outfit',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'assets/logo/tripline-logo.svg',
                      height: 180,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF974C),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            onPressed: () {
                              _handleSignInButton(context);
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _handleSignUpButton(context);
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Version ${appVersion.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFFB3B3B3),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignInButton(BuildContext context) async {
    await _requestPermissions(context, 'Signin');
  }

  Future<void> _handleSignUpButton(BuildContext context) async {
    await _requestPermissions(context, 'Signup');
  }

  Future<void> _requestPermissions(
      BuildContext context, String targetPage) async {
    // Request camera permission
    if (!await Permission.camera.request().isGranted) {
      return;
    }

    // Request storage permission
    if (!await Permission.storage.request().isGranted) {
      return;
    }

    // Request contacts permission
    if (!await Permission.contacts.request().isGranted) {
      return;
    }

    // All permissions are granted, redirect to target page (Signin or Signup)
    Navigator.pushNamed(context, targetPage);
  }
}
