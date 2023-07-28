import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/main.dart';
import 'package:tripline/styles/text_styles.dart';

class TripViewRecent extends StatelessWidget {
 
   final Map<String, dynamic> loggedInUserData;

  const TripViewRecent({
    Key? key,
    required this.loggedInUserData,
   
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    int userId=loggedInUserData['userId'];
    print(userId);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.queryTripRecordRecent(userId),
      builder: (context, snapshot) {
        
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return CircularProgressIndicator();
        // }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        else if (snapshot.data==null || snapshot.data!.isEmpty || !snapshot.hasData) {
          
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(
              'No Recent trips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } 
        
        final tripData = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Recent Trips',
                    style: CustomTextStyles.title2,
                  ),
                ),
               SizedBox(
                  height: 15,
                ),
            Container(
              
              padding: EdgeInsets.only(left: 20),
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tripData.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15,
                  );
                },
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
          ],
        );

        }
        
      
    );
  }
}

class TripCard extends StatelessWidget {
  final int tripId;
  final String destination;
  final String startDate;
  final String tripCover;
  final Map<String, dynamic> loggedInUserData;
  const TripCard({
    Key? key,
    required this.tripId,
    required this.destination,
    required this.startDate,
    required this.tripCover,
    required this.loggedInUserData
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
        Navigator.pushNamed(context, 'tripdetailsscreen',arguments: TripDetailsScreenArguments(loggedInUserData, tripId),);
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
              width: 200,
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
