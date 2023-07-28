import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/bottom_sheets/clear_app_data_bottomsheet.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/drawer_screen.dart';
import 'package:tripline/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:tripline/screens/edit_profile_details_bottomsheet.dart';
import 'package:tripline/styles/color_styles.dart';
import 'package:tripline/styles/text_styles.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  SettingsScreen({required this.loggedInUserData});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    super.initState();
  }
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
  int? currentUserId;
  void _updateProfileDetails(Map<String, dynamic>? updatedDetails) async {
    if (updatedDetails != null && widget.loggedInUserData['userId'] != null) {
      
      // Update the trip name in the database
      await DatabaseHelper.instance
          .updateProfileRecord(widget.loggedInUserData['userId'], updatedDetails);
      // Fetch the updated trip details from the database
      await fetchProfileDetails(updatedDetails);
      print('Finished');
    }
  }
  Future<void> fetchProfileDetails(Map<String, dynamic>? updatedDetails) async {
    widget.loggedInUserData['userName'] = updatedDetails!['userName'];
    setState(() {
      
    });

    // final userId = widget.loggedInUserData['userId'];
    // if (userId != null) {
    //   final userDetails = await DatabaseHelper.instance.getUserDetails(userId);
    //   setState(() {
       
    //   });
    //   // currentUserId = currentUserId;
      
    // }
  }


  bool _switchValue = true;
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
                  FutureBuilder(
                    future: DatabaseHelper.instance.getUserDataById(loggedInUserData['userId'] ?? 0),
                    builder: (context,snapshot) {
                       if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      else if(snapshot.data == null || snapshot.hasError){
                        return Text('user not found');

                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${loggedInUserData['userName']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${loggedInUserData['userEmail']}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              _openEditProfileDetailsBottomSheet(context);
                              setState(() {
                                
                              });
                              

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
                      );
                    }
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
  void _openEditProfileDetailsBottomSheet(BuildContext context) {
    print('***********');
  
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditProfileDetailsBottomSheet(
          userId: widget.loggedInUserData['userId'],
          userName: widget.loggedInUserData['userName'],
          userEmail: widget.loggedInUserData['userEmail'],
         onTripUpdated: _updateProfileDetails,
        );
      },
    );
  }
  
  void openClearBottomSheet(BuildContext context, Map<String, dynamic> loggedInUserData) {
    clearAppBottomSheet(context, loggedInUserData);
  }
}
