import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/imagehelpers/image_helper.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/widgets/input_fields.dart';
import 'package:tripline/widgets/other_widgets.dart';

// ignore: must_be_immutable
class Screen2 extends StatefulWidget {
  Map<String, dynamic> dataMap;

  Screen2({required this.dataMap});
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  String _CoverImagePath = '';
  final TextEditingController tripBudget = TextEditingController();
  final TextEditingController startLocation = TextEditingController();
  List<String> checkpoints = [];
  @override
  void dispose() {
    tripBudget.dispose();
    startLocation.dispose();
    super.dispose();
  }

  void updateDataMap() {
    widget.dataMap[DatabaseHelper.columnTripBudget] = tripBudget.text;
    widget.dataMap[DatabaseHelper.columnTripStartLocation] = startLocation.text;
    widget.dataMap[DatabaseHelper.columnTripCover] = _CoverImagePath;
    widget.dataMap['checkpoints'] = checkpoints;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 250,
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (1 / .8),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    InkWell(
                      onTap: () {
                        OpenCoverSelection(context);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                image: FileImage(File(_CoverImagePath)),
                                fit: BoxFit.cover)),
                        child: _CoverImagePath.trim().isNotEmpty
                            ? null
                            : Container(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                    
                                      Icon(Icons.drive_folder_upload_outlined,
                                          size: 40,
                                          color: Colors.grey.shade700),
                                      SizedBox(height: 10),
                                      Text(
                                        'Choose / Upload\na cover image',
                                        style: CustomTextStyles.GridText1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            CustomInputField(
              hintText: 'Enter your budget for this trip',
              InputControl: tripBudget,
              inputIcon: Icons.currency_rupee_sharp,
              onChanged: (_) => updateDataMap(),
            ),
            SizedBox(height: 15),
            CustomInputField(
              hintText: 'Enter your start location',
              InputControl: startLocation,
              inputIcon: Icons.location_on_outlined,
              onChanged: (_) => updateDataMap(),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add your checkpoints:', style: CustomTextStyles.subtitle),
                Container(
                  decoration: BoxDecoration(),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        openCheckpointsBottomSheet(context);
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      size: 15,
                    ),
                    label: Text('Add'),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: checkpoints.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    tileColor: Color(0xFFFCEBDF),
                    title: Text(checkpoints[index]),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${index + 1}'),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              openEditCheckpointBottomSheet(context,
                                  index: index);
                            },
                            child: Icon(Icons.edit_outlined),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              setState(() {
                                checkpoints.removeAt(index);
                              });
                            },
                            child: Icon(Icons.delete_outline_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void openCheckpointsBottomSheet(BuildContext context, {int? index}) {
    TextEditingController tripCheckpoints = TextEditingController();
    bool showError = false;
    List<String> checkPointssheet = [];
    checkPointssheet.addAll(checkpoints);

    if (index != null) {
      tripCheckpoints.text = checkPointssheet[index];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter customState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 220,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outlined,
                            color: Colors.red.shade500,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'You Can Add Up to 6 Checkpoints',
                            style: TextStyle(
                              color: Colors.red.shade500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      if (!showError && checkPointssheet.length < 6)
                        CustomInputField(
                          hintText:
                              'Checkpoint Location ${checkPointssheet.length + 1}',
                          InputControl: tripCheckpoints,
                          inputIcon: Icons.add_location_alt_outlined,
                        ),
                      if (showError || checkPointssheet.length >= 6)
                        Text(
                          'You have reached the limit of checkpoints',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(height: 15),
                      if (!showError && checkPointssheet.length < 6)
                        Row(
                          children: [
                            Expanded(
                              child: CustomAlertButton(
                                  buttonText: 'Cancel',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: CustomSecondaryButton(
                                buttonText: 'Add',
                                onPressed: () {
                                  if (tripCheckpoints.text.isNotEmpty) {
                                    if (checkPointssheet.length < 6) {
                                      customState(() {
                                        if (index != null) {
                                          checkPointssheet[index] =
                                              tripCheckpoints.text;
                                        } else {
                                          checkPointssheet
                                              .add(tripCheckpoints.text);
                                        }

                                        tripCheckpoints.clear();
                                        showError = false;
                                      });
                                      setState(() {
                                        checkpoints =
                                            List.from(checkPointssheet);
                                        updateDataMap();
                                      });
                                    } else {
                                      setState(() {
                                        showError = true;
                                      });
                                    }
                                  }
                                },
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
      },
    );
  }

  void openEditCheckpointBottomSheet(BuildContext context, {int? index}) {
    TextEditingController tripCheckpoints = TextEditingController();
    bool showError = false;
    List<String> checkPointssheet = [];
    checkPointssheet.addAll(checkpoints);

    if (index != null) {
      tripCheckpoints.text = checkPointssheet[index];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter customState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 220,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outlined,
                            color: Colors.red.shade500,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'You Can Edit the Checkpoint',
                            style: TextStyle(
                              color: Colors.red.shade500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      if (!showError)
                        CustomInputField(
                          hintText: 'Edit Checkpoint Location',
                          InputControl: tripCheckpoints,
                          inputIcon: Icons.add_location_alt_outlined,
                        ),
                      SizedBox(height: 15),
                      if (!showError)
                        CustomSecondaryButton(
                          buttonText: 'Update',
                          onPressed: () {
                            if (tripCheckpoints.text.isNotEmpty) {
                              customState(() {
                                if (index != null) {
                                  checkPointssheet[index] =
                                      tripCheckpoints.text;
                                }
                                tripCheckpoints.clear();
                                showError = false;
                              });
                              setState(() {
                                checkpoints = List.from(checkPointssheet);
                                updateDataMap();
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                  if (imagePath != null) {
                    setState(() {
                      _CoverImagePath = imagePath;
                    });
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
                  if (imagePath != null) {
                    setState(() {
                      _CoverImagePath = imagePath;
                    });
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
