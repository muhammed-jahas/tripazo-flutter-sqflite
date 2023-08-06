import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';
import 'package:tripazo/styles/text_styles.dart';

// ignore: must_be_immutable
class Screen4 extends StatefulWidget {
  Map<String, dynamic> dataMap;

  Screen4({required this.dataMap});
  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  final TextEditingController Notes = TextEditingController();
  @override
  void dispose() {
    Notes.dispose();
    super.dispose();
  }

  void updateDataMap() {
    widget.dataMap[DatabaseHelper.columnTripNotes] = Notes.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Trip Notes:', style: CustomTextStyles.subtitle),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    onChanged: (_) => updateDataMap(),
                    maxLines: 7,
                    controller: Notes,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Add Your Noted Here....',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.mode_edit_outlined),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
