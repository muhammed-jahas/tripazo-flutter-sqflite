import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';

import 'package:tripline/screens/drawer_screen.dart';
import 'package:tripline/bottom_sheets/sign_out_bottom_sheet.dart';

import 'package:tripline/styles/text_styles.dart';

class CatalogScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  CatalogScreen({required this.loggedInUserData});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int upcomingTripCount = 0;
  int recentTripCount = 0;
   @override
  void initState() {
    super.initState();
    
    fetchTripCount();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // ignore: unused_field
  bool _switchValue = true;

  // ignore: unused_element
  void _showSignOutBox(BuildContext context) {
    openSignOutBox(context);
  }
    fetchTripCount() async {
    final userId = widget.loggedInUserData['userId'];
    List<Map<String, dynamic>> tripUpcomingData = await DatabaseHelper.instance.queryTripRecordUpcoming(userId);
    List<Map<String, dynamic>> tripRecentData = await DatabaseHelper.instance.queryTripRecordRecent(userId);
    setState(() {
      upcomingTripCount = tripUpcomingData.length;
      recentTripCount = tripRecentData.length;
    });
  } 
   

  Widget _buildItemWidget(String count, String text) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 40, left: 30),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
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
    );
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
                    'Catalog',
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
                    _buildItemWidget('$upcomingTripCount', 'Upcoming\nTrips'),
                    _buildItemWidget('$recentTripCount', 'Recent\nTrips'),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
