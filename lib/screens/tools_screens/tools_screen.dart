import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripline/screens/drawer_screen/drawer_screen.dart';
import 'package:tripline/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:tripline/screens/tools_screens/tool_child_fuel_screen.dart';
import 'package:tripline/screens/tools_screens/tool_child_guidelines_screen.dart';
import 'package:tripline/styles/text_styles.dart';

class ToolsParentScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  ToolsParentScreen({required this.loggedInUserData});

  @override
  State<ToolsParentScreen> createState() => _ToolsParentScreenState();
}

class _ToolsParentScreenState extends State<ToolsParentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // ignore: unused_field
  bool _switchValue = true;

  // ignore: unused_element
  void _showSignOutBox(BuildContext context) {
    openSignOutBox(context);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> loggedInUserData = widget.loggedInUserData;
    final String? profileImagePath = loggedInUserData['userprofile'];

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFEEEEEE),
        drawer: AppDrawer(loggedInUserData: loggedInUserData),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tools',
                    style: CustomTextStyles.title2,
                  ),
                  GestureDetector(
                    onTap: _openDrawer,
                    child: Container(
                      child: CircleAvatar(
                        backgroundImage: profileImagePath != null
                            ? FileImage(File(profileImagePath))
                            : null,
                        radius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildItemWidget(
                      'assets/fuel-icon.svg',
                      'Fuel\nCalculator',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ToolsChildFuel(
                                title:
                                    'Fuel Calculator'), // Pass the title to the child screen
                          ),
                        );
                      },
                    ),
                    _buildItemWidget(
                      'assets/doc-icon.svg',
                      'Travel\nGuidelines',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TravelGuidelines(), // Pass the title to the child screen
                          ),
                        );
                      },
                    ),
                    // _buildItemWidget(
                    //   'assets/tripline-icon.svg',
                    //   'How to use\nTripline App?',
                    //   () {},
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(
      String svgAsset, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 40, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 40,
              height: 40,
            ),
            SizedBox(height: 14),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
