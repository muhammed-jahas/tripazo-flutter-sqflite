import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
            Text(
              "Terms & Conditions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Welcome to Tripazo! These Terms and Conditions govern your use of our Tripazo mobile application (the \"App\"). By accessing or using the App, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, please do not use the App.",
            ),
            SizedBox(height: 16),
            Text(
              "License and App Usage",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "We grant you a non-exclusive, non-transferable, revocable license to use the App for personal, non-commercial purposes. You may not sublicense, distribute, or modify the App without our prior written consent.",
            ),
            SizedBox(height: 16),
            Text(
              "User Conduct",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "You agree not to use the App for any unlawful or unauthorized purposes. You will comply with all applicable laws and regulations while using the App.",
            ),
            SizedBox(height: 16),
            Text(
              "Intellectual Property Rights",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "All intellectual property rights in the App, including but not limited to copyrights, trademarks, and trade secrets, are owned by us or our licensors. You may not copy, reproduce, or modify any part of the App without our prior written consent.",
            ),
            SizedBox(height: 16),
            Text(
              "Disclaimer of Warranties",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "The App is provided on an \"as is\" and \"as available\" basis. We make no warranties or representations of any kind, whether express or implied, regarding the App's accuracy, reliability, or suitability for your purposes.",
            ),
            SizedBox(height: 16),
            Text(
              "Limitation of Liability",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "To the extent permitted by law, we shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with the use of the App or these Terms and Conditions.",
            ),
            SizedBox(height: 16),
            Text(
              "Indemnification",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "You agree to indemnify and hold us harmless from any claims, damages, liabilities, or expenses arising out of your use of the App or violation of these Terms and Conditions.",
            ),
            SizedBox(height: 16),
            Text(
              "Governing Law and Jurisdiction",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "These Terms and Conditions are governed by and construed in accordance with the laws of India. Any disputes arising out of or in connection with these terms shall be subject to the exclusive jurisdiction of the courts in India.",
            ),
            SizedBox(height: 16),
            Text(
              "Changes to These Terms and Conditions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "We reserve the right to update or modify these Terms and Conditions at any time without prior notice. The revised version will be effective when it is posted in the App.",
            ),
          ],
        ),
      ),
    );
  }
}
