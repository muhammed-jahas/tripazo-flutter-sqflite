import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static const String _email = 'triplineapp@gmail.com';
  static const String _phoneNumber = '+919656462348';
  static const String _location = 'Kozhikode, Kerala, Pin: 673001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeading('Contact Info'),
            SizedBox(height: 16),
            _buildContactInfo('Email', _email),
            _buildContactInfo('Phone Number', _phoneNumber),
            _buildContactInfo('Location', _location),
            SizedBox(height: 16),
            _buildSectionHeading('Terms & Conditions'),
            SizedBox(height: 16),
            Text(
              "Welcome to Tripline! These Terms and Conditions govern your use of our TripLine mobile application (the \"App\"). By accessing or using the App, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, please do not use the App.",
            ),
            // Rest of the terms and conditions content
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildContactInfo(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          info,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
