import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Database Initialization
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
    return MaterialApp(
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
