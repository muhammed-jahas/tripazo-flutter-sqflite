import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/messages/custom_toast.dart';
import 'package:tripazo/styles/color_styles.dart';

void openSignOutBox(BuildContext context) {
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
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Text('Cancel',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () async {
                await DatabaseHelper.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'Welcome',
                  (route) => false,
                );
                showCustomToast(context, 'Signed out successfully',
                    Icons.check_circle_rounded, Colors.green,
                    height: 20);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                decoration: BoxDecoration(
                  color: CustomColors.alertColor,
                  border: Border.all(
                    color: CustomColors.alertColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Sign out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
