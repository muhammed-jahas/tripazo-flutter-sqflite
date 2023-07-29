import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/main.dart';
import 'package:tripline/styles/text_styles.dart';

final List<IconData> TravelIcons = [
  Icons.flight_takeoff_rounded,
  Icons.directions_train_sharp,
  Icons.directions_boat_filled_outlined,
  Icons.car_crash_outlined,
  Icons.directions_bike_outlined,
  Icons.traffic_rounded,
];

class TripViewOngoing extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;

  TripViewOngoing({
    Key? key,
    required this.loggedInUserData,
  }) : super(key: key);

  @override
  State<TripViewOngoing> createState() => _TripViewOngoingState();
}

class _TripViewOngoingState extends State<TripViewOngoing> {
  @override
  Widget build(BuildContext context) {
    int userId = widget.loggedInUserData['userId'];

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.queryTripRecordOngoing(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final tripData = snapshot.data ?? [];

        if (tripData.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'No ongoing trips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ongoing Trips',
                style: CustomTextStyles.title2,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tripData.length,
                itemBuilder: (BuildContext context, int index) {
                  final trip = tripData[index];
                  return TripCard(
                    tripId: trip['tripId'],
                    destination: trip['tripDestination'],
                    startDate: trip['tripStartDate'],
                    tripCover: trip['tripCover'],
                    tripTransporatation: trip['tripTransporatation'],
                    loggedInUserData: widget.loggedInUserData,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final int tripId;
  final String destination;
  final String startDate;
  final String tripCover;
  final int tripTransporatation;
  final Map<String, dynamic> loggedInUserData;
  const TripCard(
      {Key? key,
      required this.tripId,
      required this.destination,
      required this.startDate,
      required this.tripCover,
      required this.tripTransporatation,
      required this.loggedInUserData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'tripdetailsscreen',
                  arguments:
                      TripDetailsScreenArguments(loggedInUserData, tripId),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(tripCover)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      destination,
                      style: CustomTextStyles.titlewhitemedium,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: Icon(
                        TravelIcons[tripTransporatation],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12),
                    SizedBox(width: 5),
                    Text(
                      startDate,
                      style: CustomTextStyles.titlenormal2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
