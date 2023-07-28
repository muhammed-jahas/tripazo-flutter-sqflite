import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_screen1.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_screen2.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_screen3.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_screen4.dart';
import 'package:tripline/screens/navigation.dart';
import 'package:tripline/styles/color_styles.dart';
import 'package:tripline/widgets/other_widgets.dart';



class AddTripScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;

  AddTripScreen({required this.loggedInUserData});
  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  Map<String, dynamic> SuperdataMap = {};
  final globalformKey = GlobalKey<FormState>();
  int _currentStep = 0;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    print(widget.loggedInUserData);

    screens = [
      Screen1(dataMap: SuperdataMap, formKey: globalformKey),
      Screen2(dataMap: SuperdataMap),
      Screen3(dataMap: SuperdataMap),
      Screen4(dataMap: SuperdataMap),
    ];
  }

  Future<bool> _onWillPop() async {
    if (_currentStep == 0) {
      backPressAlert(context); // Call the showModalBottomSheet method
      return false; // Prevents the app from exiting
    } else {
      _previousStep();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final String? profileImagePath = widget.loggedInUserData['userprofile'];
    final int? userId = widget.loggedInUserData['userId'];

    SuperdataMap['userId'] = userId;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Your Trip.',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    CircleAvatar(
                        backgroundImage: profileImagePath != null
                            ? FileImage(File(profileImagePath))
                            : null,
                        radius: 25,
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start to add your trip details.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              LinearProgressIndicator(
                value: (_currentStep + 1) / screens.length,
                backgroundColor: CustomColors.primaryColor.shade50,
                minHeight: 5,
              ),
              SizedBox(height: 15),
              Expanded(
                child: IndexedStack(
                  index: _currentStep,
                  children: screens,
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 80,
                    //  color: Colors.amber,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 80,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomIconButton(
                                ButtonIcon: Icons.arrow_back_ios_new_outlined,
                                onPressed: () {
                                  if (_currentStep == 0) {
                                    backPressAlert(context);
                                  } else {
                                    _previousStep();
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              flex: 8,
                              child: CustomPrimaryButton(
                                buttonText: _currentStep == screens.length - 1
                                    ? 'Finish'
                                    : 'Continue',
                                onPressed: () {
                                  if (globalformKey.currentState!.validate()) {
                                    print('******true');
                                    _currentStep == screens.length - 1
                                        ? _finishStep() // Call the method using parentheses ()
                                        : _nextStep(); // Call the method using parentheses ()
                                  } else {
                                    print('******false');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < screens.length - 1) {
        _currentStep++;
      }
      print(SuperdataMap);
    });
  }

  void _previousStep() {
    if (_currentStep == 0) {
      backPressAlert(context);
    } else {
      setState(() {
        if (_currentStep > 0) {
          _currentStep--;
        }
        print(SuperdataMap);
      });
    }
  }

  void _finishStep() async {
    // final int userId = widget.loggedInUserData['userId'];
    // List<Map<String, dynamic>> results =
    //     await DatabaseHelper.instance.queryTripRecord(userId);
    // if (results.isEmpty) {
    //   print('not found');
    // } else {
    //   print(results);
    // }

    // print('-------------');
    // final List<Map<String, dynamic>> checkpoints =
    //     await DatabaseHelper.instance.queryCheckpointRecord();
    // if (results.isEmpty) {
    //   print('not found');
    // } else {
    //   print(checkpoints);
    // }
    // Insert trip record

    print('-------------------');
    Map<String, dynamic> tripRecord = {
      DatabaseHelper.columnUserId: SuperdataMap['userId'],
      DatabaseHelper.columnTripName:
          SuperdataMap[DatabaseHelper.columnTripName],
      DatabaseHelper.columnTripDestination:
          SuperdataMap[DatabaseHelper.columnTripDestination],
      DatabaseHelper.columnTripStartDate:
          SuperdataMap[DatabaseHelper.columnTripStartDate],
      DatabaseHelper.columnTripEndDate:
          SuperdataMap[DatabaseHelper.columnTripEndDate],
      DatabaseHelper.columnTripType:
          SuperdataMap[DatabaseHelper.columnTripType],
      DatabaseHelper.columnTripTransporatation:
          SuperdataMap[DatabaseHelper.columnTripTransporatation],
      DatabaseHelper.columnTripBudget:
          SuperdataMap[DatabaseHelper.columnTripBudget],
      DatabaseHelper.columnTripStartLocation:
          SuperdataMap[DatabaseHelper.columnTripStartLocation],
      DatabaseHelper.columnTripCover:
          SuperdataMap[DatabaseHelper.columnTripCover],
      DatabaseHelper.columnTripCompanions:
          SuperdataMap[DatabaseHelper.columnTripCompanions],
      DatabaseHelper.columnTripNotes:
          SuperdataMap[DatabaseHelper.columnTripNotes],
    };
    int tripId = await DatabaseHelper.instance.insertTripRecord(tripRecord);
    print(tripId);
     print('------tripRecord------');
    print(tripRecord);

    Map<String, dynamic> ExpenseOverview = {
      DatabaseHelper.columnTripId: tripId,
      DatabaseHelper.columnTripBalance:0,
      DatabaseHelper.columnExpenseTotal:0,
      DatabaseHelper.columnExpensePerPerson:0,
      DatabaseHelper.columnExpenseCount:0,
      
    };
    final expenseOverview = await DatabaseHelper.instance.insertExpenseOverview(ExpenseOverview);
    print('------ExpenseOverview------');
    print(expenseOverview);

    // List<String> checkpoints = SuperdataMap['checkpoints'];

    // for (String checkpoint in checkpoints) {
    //   Map<String, dynamic> checkpointRecord = {
    //     DatabaseHelper.columnTripId: tripId,
    //     DatabaseHelper.columnTripCheckpoint: checkpoint,
    //   };
    //   await DatabaseHelper.instance.insertCheckpointRecord(checkpointRecord);
    //   print('-------------------');
    //   print(checkpointRecord);
    // }

    // Insert activities
    // List<String> activities = SuperdataMap[DatabaseHelper.columnTripActivity];
    
    //   for (String activity in activities) {
    //     Map<String, dynamic> activityRecord = {
    //       DatabaseHelper.columnTripId: tripId,
    //       DatabaseHelper.columnTripActivity: activity,
    //     };
    //     await DatabaseHelper.instance.insertActivityRecord(activityRecord);
    //     print('--------88888------');
    //     print(activityRecord);
    //   }
    

    print('Data inserted into database');
    print(SuperdataMap);
    print('*************');
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationItems(widget.loggedInUserData),
      ),
      (route) => false,
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
                        Navigator.pop(context); // Dismiss the bottom sheet
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationItems(
                              widget.loggedInUserData,
                            ),
                          ),
                          (route) => false,
                        );
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

  // setState(() {
  //   print(SuperdataMap);
  // });
}
