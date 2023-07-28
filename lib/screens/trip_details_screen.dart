import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripline/imagehelpers/image_helper.dart';
import 'package:tripline/main.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_main_screen.dart';
import 'package:tripline/screens/drawer_screen.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/edit_trip_details_bottom_sheet.dart';
import 'package:tripline/screens/expense_screen.dart';
import 'package:tripline/screens/navigation.dart';
import 'package:tripline/styles/color_styles.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/widgets/other_widgets.dart';

// ignore: must_be_immutable
class TripDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  int? tripId;
  TripDetailsScreen({required this.loggedInUserData, required this.tripId});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> activities = [];

  final TextEditingController notes = TextEditingController();

  Map<String, dynamic>? tripDetails = {};
  int? currenttripId;
  String? selectedImagePath;
  String? tripImagePath;

  final List<IconData> TravelIcons = [
    Icons.flight_takeoff_rounded,
    Icons.directions_train_sharp,
    Icons.directions_boat_filled_outlined,
    Icons.car_crash_outlined,
    Icons.directions_bike_outlined,
    Icons.traffic_rounded,
  ];

  @override
  void initState() {
    fetchTripDetails();
    super.initState();
  }

  void _updateTripDetails(Map<String, dynamic>? updatedDetails) async {
    if (updatedDetails != null && currenttripId != null) {
      // Update the trip name in the database
      await DatabaseHelper.instance
          .updateTripRecord(currenttripId!, updatedDetails);
      // Fetch the updated trip details from the database
      await fetchTripDetails();
      print('Finished');
    }
  }

  Future<void> fetchTripDetails() async {
    final tripId = widget.tripId;
    if (tripId != null) {
      final tripDetails = await DatabaseHelper.instance.getTripDetails(tripId);
      setState(() {
        this.tripDetails = tripDetails.isNotEmpty ? tripDetails.first : null;
        if (tripDetails.isNotEmpty &&
            tripDetails.first.containsKey('tripNotes')) {
          notes.text = tripDetails.first['tripNotes'] as String;
        }
      });
      currenttripId = tripId;
      await fetchActivities(tripId);
    }
  }

  Future<void> fetchActivities(int tripId) async {
    final fetchedActivities =
        await DatabaseHelper.instance.getTripActivities(tripId);
    setState(() {
      activities = fetchedActivities
          .map((activity) => activity['tripActivity'] as String)
          .toList();
      // print(fetchedActivities);
      // print('*********');
      // print(activities);
    });
  }

  void updateTripNotes(String updatedNotes) {
    setState(() {
      if (tripDetails != null) {
        tripDetails!['tripNotes'] = updatedNotes;
      }
    });
  }

  Future<bool> _onWillPop() async {
    // ignore: unused_local_variable
    final updateData = await DatabaseHelper.instance
        .queryTripRecordOngoing(tripDetails!['userId']);
    Navigator.of(context).pushNamedAndRemoveUntil(
      'Navigation',
      (route) => false,
      arguments: NavigationArguments(widget.loggedInUserData, 0),
    );

    print('*****----------');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUserData = widget.loggedInUserData;
    final String? profileImagePath = loggedInUserData['userprofile'];

    SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    )
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              'Navigation',
                              (route) => false,
                              arguments: NavigationArguments(
                                  widget.loggedInUserData, 0),
                            );
                          },
                          child: Icon(Icons.arrow_back_outlined),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          tripDetails!['tripName'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              if (currenttripId != null &&
                                  tripDetails != null) {
                                _openEditTripDetailsBottomSheet(context);
                              }
                            },
                            child: Icon(Icons.mode_edit_outlined)),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                            onTap: () {
                              showdeleteAlert(context);
                            },
                            child: Icon(Icons.delete_outline)),
                        SizedBox(
                          width: 20,
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
                  ],
                ),
              ),
            ),
            leading: Container(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: selectedImagePath !=
                                    null // Step 2: Use Image.file widget if selectedImagePath is not null
                                ? DecorationImage(
                                    image: FileImage(File(selectedImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : tripDetails!['tripCover'] !=
                                        null // If no image is selected, use the existing tripCover if available
                                    ? DecorationImage(
                                        image: FileImage(
                                            File(tripDetails!['tripCover'])),
                                        fit: BoxFit.cover,
                                      )
                                    : null, // If no image is available, use null
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 64,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 64,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tripDetails!['tripDestination'],
                                style: CustomTextStyles.titlewhitemedium,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                child: Icon(
                                  TravelIcons[
                                      tripDetails!['tripTransporatation']],
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: CustomTextStyles.Info1,
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 14),
                                SizedBox(width: 5),
                                Text(
                                  tripDetails!['tripStartDate'],
                                  style: CustomTextStyles.titlenormal,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'End Date',
                              style: CustomTextStyles.Info1,
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 14),
                                SizedBox(width: 5),
                                Text(
                                  tripDetails!['tripEndDate'],
                                  style: CustomTextStyles.titlenormal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 15,
                ),
                // Trip Budget & Trip Expenses
                GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1 / 1,
                  ),
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xFFFF974C),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trip\nBudget',
                            style: CustomTextStyles.titlewhite1,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '₹ ${tripDetails!['tripBudget'].toString()}',
                            style: CustomTextStyles.titlewhite2,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Balance: ₹ ${tripDetails!['tripBudget'].toString()}',
                            style: CustomTextStyles.titlewhite1,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (tripDetails != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseScreen(
                                loggedInUserData: widget.loggedInUserData,
                                tripData: tripDetails,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip\nExpenses',
                              style: CustomTextStyles.titlewhite1,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '₹0.00',
                              style: CustomTextStyles.titlewhite2,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.add_box,
                                  color: CustomColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add New',
                                  style: CustomTextStyles.titlewhite1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                // Trip Type & Companions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trip Type', style: CustomTextStyles.Info1),
                              SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  tripDetails!['tripType'],
                                  style: CustomTextStyles.titlenormal,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trip Companions',
                                  style: CustomTextStyles.Info1),
                              SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  tripDetails!['tripCompanions'].toString(),
                                  style: CustomTextStyles.titlenormal,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Activities & Interests',
                              style: CustomTextStyles.Info1),
                          InkWell(
                            onTap: () async {
                              await fetchTripDetails();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mode_edit_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Edit', style: CustomTextStyles.Info1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(activities.length, (index) {
                          final text = activities[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activities.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  thickness: 1,
                ),
                SizedBox(height: 15),
                // Notes
                // Notes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        // Notes
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notes', style: CustomTextStyles.Info1),
                                  InkWell(
                                    onTap: () {
                                      openNotesBottomSheet(
                                        context,
                                        notes.text,
                                        widget.tripId!,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.mode_edit_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Edit',
                                            style: CustomTextStyles.Info1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  openNotesBottomSheet(
                                    context,
                                    notes.text,
                                    widget.tripId!,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child:
                                      ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: notes,
                                    builder: (context, value, _) {
                                      return Text(
                                        value.text,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),
                // Pictures
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pictures', style: CustomTextStyles.Info1),
                            InkWell(
                              onTap: () {
                                openPictureSelection(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.photo_camera_back_outlined,
                                      size: 20, color: Colors.grey),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Add New',
                                      style: CustomTextStyles.Info1),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder(
                      future: DatabaseHelper.instance
                          .ReadAlbumRecord(tripDetails!['tripId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.data == null || snapshot.hasError) {
                          return Text('album not found');
                        }
                        final albumresuslt = snapshot.data;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12),
                          itemBuilder: (context, index) {
                            final images = albumresuslt![index];
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                      image:
                                          FileImage(File(images['albumImage'])),
                                      fit: BoxFit.cover)),
                            );
                          },
                          itemCount: albumresuslt?.length,
                          shrinkWrap: true,
                          // mainAxisSpacing: 12,
                          // crossAxisSpacing: 12,
                          physics: NeverScrollableScrollPhysics(),
                          // children: List.generate(6, (index) {
                          //   return Container(
                          //     color: Colors.grey,
                          //   );
                          // }),
                        );
                      }),
                ),
                SizedBox(height: 45),
                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSecondaryButton(
                    buttonText: 'Add New Trip',
                    onPressed: () {
                      //       Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AddTripScreen(
                      //       loggedInUserData: widget.loggedInUserData,
                      //     ),
                      //   ),
                      // );
                      print(tripDetails);
                    },
                  ),
                ),
                SizedBox(height: 50), // Added extra space at the bottom
              ],
            ),
          ),
          drawer: AppDrawer(loggedInUserData: loggedInUserData),
        ),
      ),
    );
  }

  void _openEditTripDetailsBottomSheet(BuildContext context) {
    print('***********');
    print(currenttripId);
    if (currenttripId == null || tripDetails == null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditTripDetailsBottomSheet(
          tripId: currenttripId!,
          tripName: tripDetails!['tripName'],
          tripDestination: tripDetails!['tripDestination'],
          tridpStartDate: tripDetails!['tripStartDate'],
          tridpEndDate: tripDetails!['tripEndDate'],
          tripCompanions: tripDetails!['tripCompanions'].toString(),
          tripType: tripDetails!['tripType'],
          tripTransportation: tripDetails!['tripTransportation'],
          tripCover: tripDetails!['tripCover'].toString(),
          onTripUpdated: _updateTripDetails,
        );
      },
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void openNotesBottomSheet(
      BuildContext context, String initialNotes, int tripId) {
    TextEditingController notesController =
        TextEditingController(text: initialNotes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Notes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: notesController,
                    maxLines: 8,
                    maxLength: 500,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add notes...',
                    ),
                    onTap: () {
                      final textLength = notesController.text.length;
                      notesController.selection = TextSelection.fromPosition(
                          TextPosition(offset: textLength));
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomSecondaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: 'CANCEL',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomPrimaryButton(
                          onPressed: () async {
                            String updatedNotes = notesController.text;
                            await DatabaseHelper.instance
                                .updateTripNotes(tripId, updatedNotes);

                            setState(() {
                              notes.text = updatedNotes;
                            });

                            print('------Notes updated------');
                            Navigator.pop(context);
                          },
                          buttonText: 'SAVE',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showdeleteAlert(BuildContext context) {
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
                'Are you sure you want to delete this trip?',
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
                      onPressed: () async {
                        final currentTripId = currenttripId;
                        print(currentTripId);
                        await DatabaseHelper.instance
                            .deleteTripRecord(currentTripId);
                        print('Trip Deleted Successfully');
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
                        // if (Platform.isAndroid) {
                        //   SystemNavigator.pop();
                        // } else if (Platform.isIOS) {
                        //   exit(0);
                        // }
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

  void openPictureSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  String? imagePath = await ImageHelper.openCamera();
                  if (imagePath != null && imagePath.isNotEmpty) {
                    Map<String, dynamic> Album = {
                      'tripId': tripDetails!['tripId'],
                      'albumImage': imagePath,
                    };
                    await DatabaseHelper.instance.insertAlbumRecord(Album);
                  }
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  String? imagePath = await ImageHelper.openGallery();
                  if (imagePath != null && imagePath.isNotEmpty) {
                    Map<String, dynamic> Album = {
                      'tripId': tripDetails!['tripId'],
                      'albumImage': imagePath,
                    };
                    await DatabaseHelper.instance.insertAlbumRecord(Album);
                  }

                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.image_outlined),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

