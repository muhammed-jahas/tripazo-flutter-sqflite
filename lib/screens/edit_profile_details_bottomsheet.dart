import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/widgets/input_fields.dart';
import 'package:tripline/widgets/other_widgets.dart';

class EditProfileDetailsBottomSheet extends StatefulWidget {
  final int? userId;
  final String? userName;
  final String? userEmail;

  final Function(Map<String, dynamic>)? onTripUpdated;

  EditProfileDetailsBottomSheet({
    this.userId,
    this.userName,
    this.userEmail,
    this.onTripUpdated,
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
    userNameController.text = widget.userName ?? '';
    userEmailController.text = widget.userEmail ?? '';
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
                        widget.onTripUpdated;
                        Navigator.pop(context);
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

  Future<void> _saveUpdatedProfileDetails() async {
    String updatedUserName = userNameController.text.trim();
    String updatedEmail = userEmailController.text.trim();

    Map<String, dynamic> updatedDetails = {
      'userName': updatedUserName,
      'userEmail': updatedEmail,
    };

    await DatabaseHelper.instance
        .updateProfileRecord(widget.userId, updatedDetails);
    print('***************');
    setState(() {});
    if (widget.onTripUpdated != null) {
      widget.onTripUpdated!(updatedDetails);
    }
  }
}
