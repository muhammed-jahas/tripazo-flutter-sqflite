import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/styles/text_styles.dart';
import 'package:tripazo/validations/add_trip_validate.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tripazo/widgets/choice_chips.dart';
import 'package:tripazo/widgets/input_fields.dart';

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
  String? tripStartDate;
  String? tripEndDate;
  String tripType = 'Business';
  String transportation = 'Flight';
  int selectedTransportationIndex = 0;
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
    // startDate.dispose();
    // endDate.dispose();
    super.dispose();
  }

  void updateDataMap() {
    
    widget.dataMap[DatabaseHelper.columnTripName] = tripName.text;
    widget.dataMap[DatabaseHelper.columnTripDestination] = destination.text;
    widget.dataMap[DatabaseHelper.columnTripStartDate] = tripStartDate;
    widget.dataMap[DatabaseHelper.columnTripEndDate] = tripEndDate;
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
              SfDateRangePicker(
                onSelectionChanged: onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                enablePastDates: false,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 0)),
                    DateTime.now().add(const Duration(days: 0))),
              ),
              SizedBox(height: 15),
              // CustomCalendarInputField(
              //   hintText: 'Select start date',
              //   inputControl: startDate,
              //   inputIcon: Icons.calendar_today_outlined,
              //   onChanged: (_) => updateDataMap(),
              //   customValidator: AddTripValidator.validateStartDate,
              // ),
              // SizedBox(height: 15),
              // CustomCalendarInputField(
              //   hintText: 'Select end date',
              //   inputControl: endDate,
              //   inputIcon: Icons.calendar_today_outlined,
              //   onChanged: (_) => updateDataMap(),
              // ),
              // SizedBox(height: 15),
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

  onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      tripStartDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
      tripEndDate = DateFormat('yyyy-MM-dd')
          .format(args.value.endDate ?? args.value.startDate);
    });
    print(tripStartDate);
    print(tripEndDate);
    updateDataMap();
  }
}
