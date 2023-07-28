// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:tripline/bottom_sheets/sign_out_bottom_sheet.dart';
// import 'package:tripline/styles/color_styles.dart';

// class AppDrawer extends StatelessWidget {
//   final Map<String, dynamic> loggedInUserData;

//   AppDrawer({required this.loggedInUserData});
//   void _showSignOutBox(BuildContext context) {
//     openSignOutBox(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? profileImagePath = loggedInUserData['userprofile'];

//     return AppBar(
//       toolbarHeight: 80,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       flexibleSpace: Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Icon(Icons.arrow_back_outlined),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Text(
//                     tripDetails!['tripName'],
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.mode_edit_outlined),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Icon(Icons.delete_outline),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   GestureDetector(
//                     onTap: _openDrawer,
//                     child: Container(
//                       child: CircleAvatar(
//                         backgroundImage: profileImagePath != null
//                             ? FileImage(File(profileImagePath))
//                             : null,
//                         radius: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       leading: Container(),
//     );
//   }
// }
