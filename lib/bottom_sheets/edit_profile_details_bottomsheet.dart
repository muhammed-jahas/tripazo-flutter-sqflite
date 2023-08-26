import 'package:flutter/material.dart';
import 'package:tripazo/messages/custom_toast.dart';
import 'package:tripazo/styles/text_styles.dart';
import 'package:tripazo/widgets/input_fields.dart';
import 'package:tripazo/widgets/other_widgets.dart';

class EditProfileDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  final Function(Map<String, dynamic>) onProfileDetailsUpdated;

  EditProfileDetailsBottomSheet({
    required this.loggedInUserData,
    required this.onProfileDetailsUpdated,
  });

  @override
  _EditProfileDetailsBottomSheetState createState() =>
      _EditProfileDetailsBottomSheetState();
}

class _EditProfileDetailsBottomSheetState
    extends State<EditProfileDetailsBottomSheet> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.loggedInUserData['userName'] ?? '';
    userEmailController.text = widget.loggedInUserData['userEmail'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          // height: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile Details',
                  style: CustomTextStyles.title2,
                ),
                SizedBox(height: 20),
                CustomInputField(
                  InputControl: userNameController,
                  hintText: '',
                  inputIcon: Icons.person_3_outlined,
                  labelText: 'User Name',
                ),
                SizedBox(height: 20),
                CustomInputField(
                  InputControl: userEmailController,
                  hintText: '',
                  inputIcon: Icons.email_outlined,
                  labelText: 'Email',
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
                        buttonText: 'CANCEL',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomPrimaryButton(
                        onPressed: () async {
                          await _saveUpdatedProfileDetails();
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
      ),
    );
  }

  Future<void> _saveUpdatedProfileDetails() async {
    String updatedUserName = userNameController.text.trim();
    String updatedEmail = userEmailController.text.trim();

    Map<String, dynamic> updatedDetails = {
      'userName': updatedUserName,
      'userEmail': updatedEmail,
    };

    // Call the function to update the profile details in the SettingsScreen
    widget.onProfileDetailsUpdated(updatedDetails);
    showCustomToast(
      context,
      'Profile Details Updated',
      Icons.check_circle_rounded,
      Colors.green,
    );
    Navigator.pop(context); // Close the bottom sheet
  }
}
