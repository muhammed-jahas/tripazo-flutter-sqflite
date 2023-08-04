import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/bottom_sheets/edit_profile_details_bottomsheet.dart';
import 'package:tripline/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/styles/color_styles.dart';

class AppDrawer extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;

  AppDrawer({required this.loggedInUserData});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void _showSignOutBox(BuildContext context) {
    openSignOutBox(context);
  }

  void _updateProfileDetails(Map<String, dynamic>? updatedDetails) async {
    if (updatedDetails != null && widget.loggedInUserData['userId'] != null) {
      // Update the trip name in the database
      await DatabaseHelper.instance.updateProfileRecord(
          widget.loggedInUserData['userId'], updatedDetails);
      // Fetch the updated trip details from the database
      await fetchProfileDetails(updatedDetails);
      print('Finished');
    }
  }

  Future<void> fetchProfileDetails(Map<String, dynamic>? updatedDetails) async {
    widget.loggedInUserData['userName'] = updatedDetails!['userName'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? profileImagePath = widget.loggedInUserData['userprofile'];

    return Drawer(
      child: Column(
        children: [
          //Profile Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath))
                      : null,
                  radius: 35,
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.loggedInUserData['userName']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${widget.loggedInUserData['userEmail']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
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
                          Text('Edit Profile'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
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
        ],
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
          loggedInUserData: widget.loggedInUserData,
          // userId: widget.loggedInUserData['userId'],
          // userName: widget.loggedInUserData['userName'],
          // userEmail: widget.loggedInUserData['userEmail'],
          onProfileDetailsUpdated: _updateProfileDetails,
        );
      },
    );
  }
}
