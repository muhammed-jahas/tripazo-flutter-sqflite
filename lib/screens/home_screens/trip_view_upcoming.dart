import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/main.dart';
import 'package:tripazo/styles/text_styles.dart';

class TripViewUpcoming extends StatelessWidget {
  final Map<String, dynamic> loggedInUserData;

  const TripViewUpcoming({
    Key? key,
    required this.loggedInUserData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userId = loggedInUserData['userId'];
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.queryTripRecordUpcoming(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final tripData = snapshot.data ?? [];
        if (tripData.isEmpty) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              'No upcoming trips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Upcoming Trips',
                style: CustomTextStyles.title2,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ClipRRect(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),

                // color: Colors.black,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1 / .8,
                  ),
                  itemCount: tripData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final trip = tripData[index];
                    return TripCard(
                      tripId: trip['tripId'],
                      destination: trip['tripDestination'],
                      startDate: trip['tripStartDate'],
                      tripCover: trip['tripCover'],
                      loggedInUserData: loggedInUserData,
                    );
                  },
                ),
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
  final Map<String, dynamic> loggedInUserData;
  const TripCard(
      {Key? key,
      required this.tripId,
      required this.destination,
      required this.startDate,
      required this.tripCover,
      required this.loggedInUserData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              'tripdetailsscreen',
              arguments: TripDetailsScreenArguments(loggedInUserData, tripId),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
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
          height: 48,
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
          height: 48,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  destination,
                  style: CustomTextStyles.titlewhitenormal,
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 14,
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
    );
  }
}
