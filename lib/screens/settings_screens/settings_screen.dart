import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripazo/bottom_sheets/clear_app_data_bottomsheet.dart';
import 'package:tripazo/bottom_sheets/edit_profile_details_bottomsheet.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/main.dart';
import 'package:tripazo/screens/drawer_screen/drawer_screen.dart';
import 'package:tripazo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:tripazo/styles/color_styles.dart';
import 'package:tripazo/styles/text_styles.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  Map<String, dynamic> loggedInUserData;
  SettingsScreen({required this.loggedInUserData});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> fetchProfileDetails() async {
    final userId = widget.loggedInUserData['userId'];
    if (userId != null) {
      final userDetails = await DatabaseHelper.instance.getUserDetails(userId);
      if (userDetails.isNotEmpty) {
        setState(() {
          widget.loggedInUserData =
              userDetails.first; // Update with fetched data
        });
      }
    }
  }

  void _showSignOutBox(BuildContext context) {
    openSignOutBox(context);
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImagePath = widget.loggedInUserData['userprofile'];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFEEEEEE),
        drawer: AppDrawer(loggedInUserData: widget.loggedInUserData),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
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
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath))
                        : null,
                    radius: 40,
                  ),
                  SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.loggedInUserData['userName']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${widget.loggedInUserData['userEmail']}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          _openEditProfileDetailsBottomSheet(context);
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: ListTile(
            //     leading: Icon(
            //       Icons.dark_mode_outlined,
            //       color: Colors.black,
            //     ),
            //     title: Text('Dark Mode',
            //         style: TextStyle(fontSize: 16, color: Colors.black)),
            //     trailing: Transform.scale(
            //       scale: 1,
            //       child: Switch(
            //         value: _switchValue,
            //         onChanged: (bool newValue) {
            //           setState(() {
            //             _switchValue = newValue;
            //           });
            //         },
            //       ),
            //     ),
            //     contentPadding: EdgeInsets.all(0),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  openClearBottomSheet(context, widget.loggedInUserData);
                },
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                ),
                title: Text('Clear App Data',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('AppInfo');
                },
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.black,
                ),
                title: Text('App Info',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('Terms');
                },
                leading: Icon(
                  Icons.sticky_note_2_outlined,
                  color: Colors.black,
                ),
                title: Text('Terms & Conditions',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('Privacy');
                },
                leading: Icon(
                  Icons.category_outlined,
                  color: Colors.black,
                ),
                title: Text('Privacy & Policy',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('Help');
                },
                leading: Icon(
                  Icons.live_help_outlined,
                  color: Colors.black,
                ),
                title: Text('Help',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
            InkWell(
              onTap: () {
                _showSignOutBox(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: Icon(
                    Icons.directions_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: Text('Sign out',
                      style: TextStyle(
                          fontSize: 16, color: CustomColors.primaryColor)),
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditProfileDetailsBottomSheet(BuildContext context) async {
    final updatedDetails = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditProfileDetailsBottomSheet(
          loggedInUserData: widget.loggedInUserData,
          onProfileDetailsUpdated: _updateProfileDetails,
        );
      },
    );

    // Check if updatedDetails is not null and update the UI accordingly
    if (updatedDetails != null) {
      setState(() {
        widget.loggedInUserData['userName'] =
            updatedDetails['userName'] ?? widget.loggedInUserData['userName'];
        widget.loggedInUserData['userEmail'] =
            updatedDetails['userEmail'] ?? widget.loggedInUserData['userEmail'];
        // Add other fields if needed
      });
    }
  }

  void _updateProfileDetails(Map<String, dynamic> updatedDetails) async {
    // ignore: unnecessary_null_comparison
    if (updatedDetails != null && widget.loggedInUserData['userId'] != null) {
      // Create a new map with the updated userName and userEmail
      Map<String, dynamic> updatedUserData = {
        ...widget.loggedInUserData,
        'userName':
            updatedDetails['userName'] ?? widget.loggedInUserData['userName'],
        'userEmail':
            updatedDetails['userEmail'] ?? widget.loggedInUserData['userEmail'],
        // Add other fields if needed
      };

      // Update the UI with the new values immediately
      setState(() {
        widget.loggedInUserData = updatedUserData;
      });

      // Update the data in the database
      await DatabaseHelper.instance.updateProfileRecord(
        widget.loggedInUserData['userId'],
        updatedUserData,
      );

      print('Finished');

      // Navigate to 'Navigation' screen and wait for the result
      final result = await Navigator.pushNamed(context, 'Navigation',
          arguments: NavigationArguments(widget.loggedInUserData, 3));

      // Check if the result is not null and update the UI accordingly
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          widget.loggedInUserData['userName'] = result['userName'];
          widget.loggedInUserData['userEmail'] = result['userEmail'];
          // Add other fields if needed
        });
      }
    }
  }

  void openClearBottomSheet(
      BuildContext context, Map<String, dynamic> loggedInUserData) {
    clearAppBottomSheet(context, loggedInUserData);
  }
}
