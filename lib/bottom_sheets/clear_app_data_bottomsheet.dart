import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/messages/custom_toast.dart';
import 'package:tripazo/navigation/navigation.dart';
import 'package:tripazo/styles/text_styles.dart';
import 'package:tripazo/widgets/other_widgets.dart';

void clearAppBottomSheet(
    BuildContext context, Map<String, dynamic> loggedInUserData) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 135,
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
                    'Are you sure ?  All trips will be deleted',
                    style: CustomTextStyles.subtitle,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomAlertButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: 'NO',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomPrimaryButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteAllTrips();
                            Navigator.pop(context); // Dismiss the bottom sheet
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NavigationItems(loggedInUserData, 0),
                              ),
                              (route) => false,
                            );
                            showCustomToast(
                              context,
                              'Data Cleared Successfully',
                              Icons.check_circle_rounded,
                              Colors.green,
                            );
                          },
                          buttonText: 'YES',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
