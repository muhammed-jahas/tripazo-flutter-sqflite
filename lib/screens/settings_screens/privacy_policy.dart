import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEFEFEF),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Privacy & Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Welcome to Tripazo! We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and disclose the information you provide when you use our Tripazo mobile application (\"App\"). By using the App, you consent to the practices described in this policy.",
              ),
              SizedBox(height: 16),
              Text(
                "Information We Collect",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "When you register for an account or interact with the App, we may collect personal information from you, such as your name, email address, and location. This information is necessary for us to provide you with the services offered by the App. Additionally, we may collect data on how you use the App, including your interactions, searches, and preferences. This helps us improve the App and enhance your overall experience.",
              ),
              SizedBox(height: 16),
              Text(
                "How We Use Your Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We use the information we collect to provide and enhance the features and functionality of the App. This includes personalizing your experience, optimizing our services, and analyzing usage patterns to improve the App's performance. We may also use your email address to send you important notifications, updates, and promotional materials related to the App. If you prefer not to receive these communications, you can opt out at any time.",
              ),
              SizedBox(height: 16),
              Text(
                "Disclosure of Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We understand the importance of keeping your information secure. We implement reasonable security measures to protect your personal information from unauthorized access, alteration, or disclosure. However, please be aware that no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.",
              ),
              SizedBox(height: 16),
              Text(
                "Third-Party Links and Services",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "The App may contain links to third-party websites or services that are not owned or controlled by us. These third parties have their own privacy policies, and we are not responsible for their practices or the content they provide. We recommend reviewing their privacy policies before providing any personal information.",
              ),
              SizedBox(height: 16),
              Text(
                "Changes to This Policy",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. The effective date of the policy is 20-07-2023. We encourage you to review this policy periodically for any updates. By continuing to use the App after any changes to the policy, you acknowledge and accept the updated Privacy Policy.",
              ),
              SizedBox(height: 16),
              Text(
                "Contact Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "If you have any questions, concerns, or requests regarding this Privacy Policy, please contact us at Tripazoapp@gmail.com. We are here to assist you and address any privacy-related inquiries you may have.",
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
