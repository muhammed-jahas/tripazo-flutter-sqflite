import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/imagehelpers/image_helper.dart';
import 'package:tripazo/messages/custom_toast.dart';
import 'package:tripazo/styles/text_styles.dart';
import 'package:tripazo/widgets/input_fields.dart';
import 'package:tripazo/widgets/other_widgets.dart';

class EditTripDetailsBottomSheet extends StatefulWidget {
  final int? tripId;
  final String? tripName;
  final String? tripDestination;
  final String? tridpStartDate;
  final String? tridpEndDate;

  final String? tripCompanions;
  final int? tripTransportation;

  final String? tripCover;
  final String? tripType;

  final Function(Map<String, dynamic>)? onTripUpdated;

  EditTripDetailsBottomSheet({
    this.tripId,
    this.tripName,
    this.tripDestination,
    this.tridpStartDate,
    this.tridpEndDate,
    this.tripTransportation,
    this.tripCover,
    this.tripType,
    this.tripCompanions,
    this.onTripUpdated,
  });

  @override
  _EditTripDetailsBottomSheetState createState() =>
      _EditTripDetailsBottomSheetState();
}

class _EditTripDetailsBottomSheetState
    extends State<EditTripDetailsBottomSheet> {
  String? CoverImagePath;
  TextEditingController tripNameController = TextEditingController();
  TextEditingController tripDestinationController = TextEditingController();
  TextEditingController tripStartDateController = TextEditingController();
  TextEditingController tripEndDateController = TextEditingController();

  TextEditingController tripTypeController = TextEditingController();

  TextEditingController tripCompanionsController = TextEditingController();

  @override
  void initState() {
    tripNameController.text = widget.tripName ?? '';
    tripDestinationController.text = widget.tripDestination ?? '';
    tripStartDateController.text = widget.tridpStartDate ?? '';
    tripEndDateController.text = widget.tridpEndDate ?? '';
    tripTypeController.text = widget.tripType ?? '';

    tripCompanionsController.text = widget.tripCompanions ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Trip Details',
                style: CustomTextStyles.title2,
              ),
              SizedBox(height: 20),
              CustomInputField(
                InputControl: tripNameController,
                hintText: '',
                inputIcon: Icons.bookmark_border_outlined,
                labelText: 'Trip Name',
              ),
              SizedBox(height: 20),
              CustomInputField(
                InputControl: tripDestinationController,
                hintText: '',
                inputIcon: Icons.share_location_rounded,
                labelText: 'Trip Destination',
              ),
              SizedBox(height: 15),
              CustomCalendarInputField(
                inputControl: tripStartDateController,
                hintText: '',
                inputIcon: Icons.calendar_today_outlined,
                labelText: 'Trip Start Date',
              ),
              SizedBox(height: 15),
              CustomCalendarInputField(
                inputControl: tripEndDateController,
                hintText: '',
                inputIcon: Icons.calendar_today_outlined,
                labelText: 'Trip End Date',
              ),
              SizedBox(height: 15),
              CustomInputField(
                InputControl: tripCompanionsController,
                hintText: '',
                inputIcon: Icons.group_sharp,
                labelText: 'Companions',
              ),
              SizedBox(height: 15),
              CustomSecondaryButton(
                  buttonText: 'Choose a new Cover Picture',
                  onPressed: () {
                    OpenCoverSelection(context);
                  }),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomAlertButton(
                      onPressed: () {
                        print(widget.tripCover);
                        Navigator.pop(context);
                      },
                      buttonText: 'CANCEL',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomPrimaryButton(
                      onPressed: () async {
                        await _saveUpdatedTripDetails();
                        widget.onTripUpdated;
                        Navigator.pop(context);
                        showCustomToast(
                          context,
                          'Trip Edited Successfully',
                          Icons.check_circle_rounded,
                          Colors.green,
                          height: 20,
                        );
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
  }

  Future<void> _saveUpdatedTripDetails() async {
    String updatedTripName = tripNameController.text.trim();
    String updatedTripDestination = tripDestinationController.text.trim();
    String updatedStartDate = tripStartDateController.text.trim();
    String updatedEndDate = tripEndDateController.text.trim();
    String updatedTripType = tripTypeController.text.trim();
    // String updatedTripCover = tripCoverController.text.trim();
    String updatedTripCompanions = tripCompanionsController.text.trim();

    Map<String, dynamic> updatedDetails = {
      'tripName': updatedTripName,
      'tripDestination': updatedTripDestination,
      'tripStartDate': updatedStartDate,
      'tripEndDate': updatedEndDate,
      'tripType': updatedTripType,
      'tripCover': CoverImagePath ?? widget.tripCover,
      'tripCompanions': updatedTripCompanions,
    };

    await DatabaseHelper.instance
        .updateTripRecord(widget.tripId, updatedDetails);
    print('***************');
    setState(() {});
    if (widget.onTripUpdated != null) {
      widget.onTripUpdated!(updatedDetails);
    }

    print(updatedDetails);

    print('******//////////*******');
  }

  void OpenCoverSelection(BuildContext context) {
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
                  if (imagePath!.isEmpty) {
                    setState(() {
                      CoverImagePath = widget.tripCover;
                    });
                    print(CoverImagePath);
                  } else if (imagePath.isNotEmpty) {
                    setState(() {
                      CoverImagePath = imagePath;
                    });
                    print('****************');
                  }
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
                  if (imagePath!.isEmpty) {
                    setState(() {
                      CoverImagePath = widget.tripCover;
                    });
                    print(CoverImagePath);
                  } else if (imagePath.isNotEmpty) {
                    setState(() {
                      CoverImagePath = imagePath;
                    });
                    print('****************');
                  }
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
