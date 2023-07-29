import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lottie/lottie.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_main_screen.dart';
import 'package:tripline/screens/drawer_screen/drawer_screen.dart';
import 'package:tripline/screens/search_screens/search_screen.dart';
import 'package:tripline/screens/home_screens/trip_view_ongoing.dart';
import 'package:tripline/screens/home_screens/trip_view_recent.dart';
import 'package:tripline/screens/home_screens/trip_view_upcoming.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/widgets/other_widgets.dart';
// Import the bottom sheet widget

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  static const Color myCustomColor = Color(0xFFFF974C);

  HomeScreen({required this.loggedInUserData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileImagePath;
  bool _isLoading = true;

  void _toggleSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    _showLoadingAnimation();
    super.initState();
  }

  // void _openSearchScreen() async {
  //   // ignore: unused_local_variable
  //   final String? result = await showSearch(
  //     context: context,
  //     delegate: CustomSearchDelegate(widget.loggedInUserData),
  //   );
  //   // Handle search result if needed
  // }

  Future<void> _showLoadingAnimation() async {
    // Wait for 2 seconds to simulate loading
    await Future.delayed(Duration(milliseconds: 1000));

    // After the duration, set _isLoading to false to hide the progress bar
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _onWillPop() async {
    backPressAlert(context);
    return false; // Prevents the app from exiting
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> loggedInUserData = widget.loggedInUserData;
    String? profileImagePath = loggedInUserData['userprofile'];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            drawerTheme: DrawerThemeData(
              width: 280,
              elevation: 0,
              scrimColor: Colors.black.withOpacity(0.5),
              backgroundColor: Colors.grey.shade100,
            ),
          ),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xFFFAFAFA),
            appBar: AppBar(
              toolbarHeight: 80,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
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
                        SizedBox(width: 15),
                        Text(
                          'Hi, ${loggedInUserData['userName']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _toggleSearch,
                          icon: Icon(Icons.search),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF974C),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTripScreen(
                                    loggedInUserData: loggedInUserData,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.add,
                              size: 20,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              leading: Container(),
            ),
            body: _isLoading
                ? Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 200,
                    color: Colors.white,
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: DatabaseHelper.instance
                        .emptyHomeValidation(loggedInUserData['userId']),
                    builder: (context, snapshotempty) {
                      if (snapshotempty.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshotempty.data == true ||
                          !snapshotempty.hasData) {
                        print('8888899999');
                        return EmptyAnimation();
                      }

                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: DatabaseHelper.instance
                                    .queryTripRecordOngoing(
                                        loggedInUserData['userId']),
                                builder: (context, snapshotOngoing) {
                                  if (snapshotOngoing.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: Colors.white,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshotOngoing.hasError) {
                                    return Text(
                                        'Error: ${snapshotOngoing.error}');
                                  }

                                  final tripDataOngoing =
                                      snapshotOngoing.data ?? [];

                                  return _buildTripViewSection(
                                    loggedInUserData: loggedInUserData,
                                    tripData: tripDataOngoing,
                                    TitleMessage: 'Ongoing trips',
                                    emptyMessage: 'No Ongoing trips',
                                    tripViewBuilder: (loggedInUserData) {
                                      return TripViewOngoing(
                                        loggedInUserData: loggedInUserData,
                                        // Add the callback here
                                      );
                                    },
                                  );
                                },
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: DatabaseHelper.instance
                                    .queryTripRecordUpcoming(
                                        loggedInUserData['userId']),
                                builder: (context, snapshotUpcoming) {
                                  if (snapshotUpcoming.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              200,
                                      color: Colors.white,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshotUpcoming.hasError) {
                                    return Text(
                                        'Error: ${snapshotUpcoming.error}');
                                  }

                                  final tripDataUpcoming =
                                      snapshotUpcoming.data ?? [];

                                  return _buildTripViewSection(
                                    loggedInUserData: loggedInUserData,
                                    tripData: tripDataUpcoming,
                                    TitleMessage: 'Upcoming trips',
                                    emptyMessage: 'No Upcoming trips',
                                    tripViewBuilder: (loggedInUserData) {
                                      return TripViewUpcoming(
                                        loggedInUserData: loggedInUserData,
                                        // Add the callback here
                                      );
                                    },
                                  );
                                },
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: DatabaseHelper.instance
                                    .queryTripRecordRecent(
                                        loggedInUserData['userId']),
                                builder: (context, snapshotRecent) {
                                  if (snapshotRecent.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              200,
                                      color: Colors.white,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshotRecent.hasError) {
                                    return Text(
                                        'Error: ${snapshotRecent.error}');
                                  }

                                  final tripDataRecent =
                                      snapshotRecent.data ?? [];

                                  return _buildTripViewSection(
                                    loggedInUserData: loggedInUserData,
                                    tripData: tripDataRecent,
                                    TitleMessage: 'Recent trips',
                                    emptyMessage: 'No Recent trips',
                                    tripViewBuilder: (loggedInUserData) {
                                      return TripViewRecent(
                                        loggedInUserData: loggedInUserData,
                                        // Add the callback here
                                      );
                                    },
                                  );
                                },
                              ),
                            ]),
                          ),
                        ],
                      );
                    }),
            drawer: AppDrawer(loggedInUserData: loggedInUserData),
          ),
        ),
      ),
    );
  }

  Widget _buildTripViewSection({
    required Map<String, dynamic> loggedInUserData,
    required List<Map<String, dynamic>> tripData,
    required String TitleMessage,
    required String emptyMessage,
    required Widget Function(Map<String, dynamic>) tripViewBuilder,
  }) {
    if (tripData.isEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                TitleMessage,
                style: CustomTextStyles.title2,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(), // This will push the "emptyMessage" to the center
                Text(
                  emptyMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(), // This will push the "emptyMessage" to the center
              ],
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tripViewBuilder(loggedInUserData),
      ],
    );
  }

  Widget EmptyAnimation() {
    return Container(
      height: MediaQuery.sizeOf(context).height - 200,
      width: double.maxFinite,
      // color: Colors.amber,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/hero_animation.json'),
          Text(
            'Time to plan a new adventure!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: CustomSecondaryButton(
              buttonText: 'Add Your Trip',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTripScreen(
                      loggedInUserData: widget.loggedInUserData,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void backPressAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 160,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to go back?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomSecondaryButton(
                      buttonText: 'No',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomAlertButton(
                      buttonText: 'Yes',
                      onPressed: () {
                        Navigator.pop(context);
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
