import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/validations/add_trip_validate.dart';

import 'package:tripline/widgets/choice_chips.dart';
import 'package:tripline/widgets/input_fields.dart';

// ignore: must_be_immutable
class Screen1 extends StatefulWidget {
  Map<String, dynamic> dataMap;
  final GlobalKey<FormState> formKey;
  Screen1({required this.dataMap, required this.formKey});
  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController tripName = TextEditingController();
  final TextEditingController destination = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  String tripType = 'Business';
  String transportation = 'Flight';
  int selectedTransportationIndex = 5;
  Map<String, IconData> choices = {
    'Flight': Icons.flight_takeoff_rounded,
    'Train': Icons.directions_train_sharp,
    'Ship': Icons.directions_boat_filled_outlined,
    'Car': Icons.car_crash_outlined,
    'Bike': Icons.directions_bike_outlined,
    'Other': Icons.swap_vertical_circle_outlined,
  };

  @override
  void dispose() {
    tripName.dispose();
    destination.dispose();
    startDate.dispose();
    endDate.dispose();
    super.dispose();
  }

  void updateDataMap() {
    widget.dataMap[DatabaseHelper.columnTripName] = tripName.text;
    widget.dataMap[DatabaseHelper.columnTripDestination] = destination.text;
    widget.dataMap[DatabaseHelper.columnTripStartDate] = startDate.text;
    widget.dataMap[DatabaseHelper.columnTripEndDate] = endDate.text;
    widget.dataMap[DatabaseHelper.columnTripType] = tripType;
    widget.dataMap[DatabaseHelper.columnTripTransporatation] =
        selectedTransportationIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CustomInputField(
                hintText: 'Enter your trip name',
                InputControl: tripName,
                inputIcon: Icons.bookmark_border_outlined,
                onChanged: (_) => updateDataMap(),
                customValidator: AddTripValidator.validateTripName,
              ),
              SizedBox(height: 15),
              CustomInputField(
                hintText: 'Enter your destination',
                InputControl: destination,
                inputIcon: Icons.share_location_rounded,
                onChanged: (_) => updateDataMap(),
                customValidator: AddTripValidator.validateDestination,
              ),
              SizedBox(height: 15),
              CustomCalendarInputField(
                hintText: 'Select start date',
                inputControl: startDate,
                inputIcon: Icons.calendar_today_outlined,
                onChanged: (_) => updateDataMap(),
                customValidator: AddTripValidator.validateStartDate,
              ),
              SizedBox(height: 15),
              CustomCalendarInputField(
                hintText: 'Select end date',
                inputControl: endDate,
                inputIcon: Icons.calendar_today_outlined,
                onChanged: (_) => updateDataMap(),
              ),
              SizedBox(height: 15),
              Text('Select your trip type :', style: CustomTextStyles.subtitle),
              SizedBox(height: 15),
              CustomChoiceChips(
                choices: {
                  'Business': Icons.business,
                  'Family': Icons.family_restroom_outlined,
                  'Friends': Icons.groups_outlined,
                },
                selectedChoice: tripType,
                onSelected: (selectedTripType) {
                  setState(() {
                    tripType = selectedTripType;
                    updateDataMap();
                  });
                },
              ),
              SizedBox(height: 15),
              Text('Select your preferred transportation :',
                  style: CustomTextStyles.subtitle),
              SizedBox(height: 15),
              CustomChoiceChips(
                choices: choices,
                selectedChoice: transportation,
                onSelected: (selectedTransportation) {
                  setState(() {
                    transportation = selectedTransportation;
                    selectedTransportationIndex =
                        choices.keys.toList().indexOf(selectedTransportation);
                    print(
                        'Selected Transportation Index: $selectedTransportationIndex');
                    updateDataMap();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
