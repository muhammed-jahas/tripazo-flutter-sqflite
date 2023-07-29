import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/add_trip_form_screens/add_trip_main_screen.dart';
import 'package:tripline/screens/settings_screens/app_info.dart';
import 'package:tripline/screens/catalog_screens/catalog_screen.dart';
import 'package:tripline/screens/expense_modules/expense_screen.dart';
import 'package:tripline/screens/settings_screens/help_screen.dart';
import 'package:tripline/screens/home_screens/home_screen.dart';
import 'package:tripline/navigation/navigation.dart';
import 'package:tripline/screens/settings_screens/privacy_policy.dart';
import 'package:tripline/screens/settings_screens/settings_screen.dart';
import 'package:tripline/screens/sign_in_screen/signin_screen.dart';
import 'package:tripline/screens/sign_up_screen/signup_screen.dart';
import 'package:tripline/screens/splash_screen/splash_screen.dart';
import 'package:tripline/screens/settings_screens/terms_and_conditions.dart';
import 'package:tripline/screens/trip_details_screens/trip_details_screen.dart';
import 'package:tripline/screens/welcome_screen/welcome_screen.dart';
import 'package:tripline/styles/color_styles.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDB();

  // Retrieve the loggedInUserData
  Map<String, dynamic> loggedInUserData =
      await DatabaseHelper.instance.getLoggedInUserData();

  runApp(TriplineApp(loggedInUserData: loggedInUserData));
}

class TriplineApp extends StatelessWidget {
  final Map<String, dynamic> loggedInUserData;

  TriplineApp({required this.loggedInUserData});

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setSystemUIOverlayStyle(
    // SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent
    // )
    // );
    return
        // AnnotatedRegion<SystemUiOverlayStyle>(
        // value: SystemUiOverlayStyle(
        //   systemNavigationBarColor: Colors.black, // Set your default SafeArea color for light mode
        //   systemNavigationBarDividerColor: null,
        //   statusBarColor: Colors.transparent,
        //   systemNavigationBarIconBrightness:
        //       MediaQuery.of(context).platformBrightness == Brightness.dark
        //           ? Brightness.light // Set the icons to light for dark mode
        //           : Brightness.dark, // Set the icons to dark for light mode
        //   statusBarIconBrightness: MediaQuery.of(context).platformBrightness,
        //   statusBarBrightness: MediaQuery.of(context).platformBrightness,
        // ),
        // child:
        MaterialApp(
      routes: {
        'Splash': (context) => SplashScreen(),
        'Signin': (context) => SigninScreen(),
        'Signup': (context) => SignupScreen(),
        'Home': (context) => HomeScreen(loggedInUserData: loggedInUserData),
        'Settings': (context) =>
            SettingsScreen(loggedInUserData: loggedInUserData),
        'Welcome': (context) => WelcomeScreen(),
        'Expenses': (context) =>
            ExpenseScreen(loggedInUserData: loggedInUserData),
        'Add Trip': (context) =>
            AddTripScreen(loggedInUserData: loggedInUserData),
        'tripdetailsscreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as TripDetailsScreenArguments;
          return TripDetailsScreen(
            loggedInUserData: args.loggedInUserData,
            tripId: args.tripId!,
          );
        },
        'Navigation': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as NavigationArguments;
          return NavigationItems(args.loggedInUserData, args.targetIndex);
        },
        'Privacy': (context) => PrivacyPolicy(),
        'Terms': (context) => TermsAndConditions(),
        'AppInfo': (context) => AppInfo(),
        'Help': (context) => HelpPage(),
        'Catalog': (context) => CatalogScreen(
              loggedInUserData: loggedInUserData,
            ),
      },
      theme: ThemeData(
        primaryColor: CustomColors.primaryColor,
        primarySwatch: CustomColors.primaryColor,
        fontFamily: 'Outfit',
        brightness: Brightness.light,
        navigationBarTheme: NavigationBarThemeData(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      // darkTheme: ThemeData(
      //   // Set your dark theme here
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.blueGrey,
      // ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationArguments {
  final Map<String, dynamic> loggedInUserData;
  final int targetIndex;

  NavigationArguments(this.loggedInUserData, this.targetIndex);
}

class TripDetailsScreenArguments {
  final Map<String, dynamic> loggedInUserData;
  final int? tripId;
  TripDetailsScreenArguments(this.loggedInUserData, this.tripId);
}

final darkTheme = ThemeData(
  primaryColor: CustomColors.primaryColor,
  primarySwatch: CustomColors.primaryColor,
  fontFamily: 'Outfit',
  navigationBarTheme: NavigationBarThemeData(
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    labelTextStyle: MaterialStateProperty.all(
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    ),
  ),
);
