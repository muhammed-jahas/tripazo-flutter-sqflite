import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/styles/text_styles.dart';
import 'package:tripazo/widgets/input_fields.dart';
import 'package:tripazo/widgets/other_widgets.dart';

// ignore: must_be_immutable
class Screen3 extends StatefulWidget {
  Map<String, dynamic> dataMap;

  Screen3({required this.dataMap});
  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final TextEditingController companion = TextEditingController();
  List<String> activities = [];

  @override
  void dispose() {
    companion.dispose();
    super.dispose();
  }

  void updateDataMap() {
    widget.dataMap[DatabaseHelper.columnTripCompanions] = companion.text;
    widget.dataMap['activities'] = activities;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomInputField(
                hintText: 'Enter how many companions you have',
                InputControl: companion,
                inputIcon: Icons.group_sharp,
                onChanged: (_) => updateDataMap(),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Trip Activities & Interests:',
                      style: CustomTextStyles.subtitle),
                  Container(
                    decoration: BoxDecoration(),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          openActivitiesBottomSheet(context);
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 15,
                      ),
                      label: Text('Add'),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(activities.length, (index) {
                  final text = activities[index];
                  return GestureDetector(
                    // onTap: () {
                    //   openActivitiesBottomSheet(context, index: index);
                    // },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                fontSize: 16,
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
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openActivitiesBottomSheet(BuildContext context, {int? index}) {
    TextEditingController activity = TextEditingController();
    bool showError = false;
    List<String> activitiessheet = [];
    activitiessheet.addAll(activities);

    if (index != null) {
      activity.text = activitiessheet[index];
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
                            'You Can Add Up to 12 Activities',
                            style: TextStyle(
                              color: Colors.red.shade500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      if (!showError && activitiessheet.length < 12)
                        CustomInputField(
                          hintText:
                              'Activity or Interest ${activitiessheet.length + 1}',
                          InputControl: activity,
                          inputIcon: Icons.local_activity,
                        ),
                      if (showError || activitiessheet.length >= 12)
                        Text(
                          'Hurray! You have added maximum number activities',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(height: 15),
                      if (!showError && activitiessheet.length < 12)
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
                                  if (activity.text.isNotEmpty) {
                                    if (activitiessheet.length < 12) {
                                      customState(() {
                                        if (index != null) {
                                          activitiessheet[index] =
                                              activity.text;
                                        } else {
                                          activitiessheet.add(activity.text);
                                        }
                                        activity.clear();
                                        showError = false;
                                      });
                                      setState(() {
                                        activities = List.from(activitiessheet);
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
}
