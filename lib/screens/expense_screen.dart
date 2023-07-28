import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripline/database/database_helper.dart';
import 'package:tripline/screens/expense_modules/expense_chart_widget.dart';
import 'package:tripline/screens/trip_details_screen.dart';
import 'package:tripline/styles/color_styles.dart';
import 'package:tripline/styles/text_styles.dart';
import 'package:tripline/widgets/input_fields.dart';
import 'package:tripline/widgets/other_widgets.dart';

class ExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  final Map<String, dynamic>? tripData;
  ExpenseScreen({required this.loggedInUserData,this.tripData});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
  Map<String, dynamic>? tripExpenseOverview = {};

  final double currentExpense = 4000;

  final List<Expense> data = [
    Expense(category: 'Travel', amount: 800),
    Expense(category: 'Food', amount: 2000),
    Expense(category: 'Accommodation', amount: 500),
    Expense(category: 'Others', amount: 700),
  ];

  late TabController _tabController;

  @override
  void initState() {
  super.initState();
   _tabController = TabController(length: 2, vsync: this);
  print('loggedInUserData: ${widget.loggedInUserData}');
  print('tripData: ${widget.tripData}');
  fetchExpenseInformation(); // Make sure this method is called.
}
  Future<void> fetchExpenseInformation() async {
  final tripId = widget.tripData?['tripId'];
  print('rrrrrrrrrrrrrrrrr');
  print(widget.tripData);
  print('rrrrrrrdhdhdhdhdhdhrrrrrrrrrr');
 
  final fetch = await DatabaseHelper.instance.fetchExpenseInfo(tripId);

  if (fetch.isNotEmpty) {
    setState(() {
      this.tripExpenseOverview = fetch.first;
    });
  } 
}

 
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? selectedCategory =
      'Category 1'; // Variable to hold the selected category

  // Define the list of categories for the dropdown
  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4'
  ];

  double customTabBarHeight = 48.0;

  @override
  Widget build(BuildContext context) {

    // // final ExpenseScreenArguments args =
    // //     ModalRoute.of(context)?.settings.arguments as ExpenseScreenArguments;

    // // Now you can access the loggedInUserData and tripData like this:
    // final Map<String, dynamic> loggedInUserData = args.loggedInUserData!;
    // final Map<String, dynamic>? tripData = args.tripData;



    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double tabBarHeight = customTabBarHeight;
    EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;
    double availableHeight = screenHeight -
        appBarHeight -
        tabBarHeight -
        safeAreaPadding.top -
        safeAreaPadding.bottom;
    double containerHeight = availableHeight / 2 - 20;
    String? profileImagePath = widget.loggedInUserData['userprofile'];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Container(
                  child: Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back_outlined),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.mode_edit_outlined),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.delete_outline),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: _openDrawer,
                            child: Container(
                              child: CircleAvatar(
                                backgroundImage: profileImagePath != null
                                    ? FileImage(File(profileImagePath))
                                    : null,
                                radius: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PreferredSize(
              preferredSize: Size.fromHeight(0), // Set height to zero
              child: Container(),
            ),
            TabBar(
              padding: EdgeInsets.symmetric(horizontal: 20),
              controller: _tabController,
              automaticIndicatorColorAdjustment: true,
              unselectedLabelColor: Colors.grey.shade400,
              indicator: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(
                    0), // Adjust the border radius to remove rounded corners
              ),
              indicatorPadding:
                  EdgeInsets.zero, // Remove padding around the indicator
              indicatorWeight: 2, // Set the thickness of the indicator
              tabs: [
                Tab(
                  child: Container(
                    child: Text(
                      'Expenses',
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'History',
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          //color: Colors.amber,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      width: double.maxFinite,
                                      child: Column(
                                        children: [
                                          Expense_Container(
                                            //containerColor: Colors.grey,
                                           Title: '₹ ${widget.tripData!['tripBudget'].toString()}',
                                            subTitle: 'Budget',
                                            ButtonIcon: Icons.add,
                                            ButtonText: 'Increase',
                                            buttonColor:
                                                CustomColors.primaryColor,
                                            // containerColor:  Colors.grey,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Expense_Container(
                                            //containerColor: Colors.amber,
                                            Title: '₹ ${tripExpenseOverview!['tripExpenseTotal'].toString()}',
                                            subTitle: 'Expenses',
                                            ButtonText: '',
                                            // containerColor:  Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      width: double.maxFinite,
                                      child: Column(
                                        children: [
                                          Expense_Container(
                                            //containerColor: Colors.grey,
                                            Title: '₹ ${tripExpenseOverview!['tripBalance'].toString()}',
                                            subTitle: 'Balance',
                                            ButtonText: '',
                                            //  containerColor:  Colors.blue,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Expense_Container(
                                            //containerColor: Colors.amber,
                                             Title: '₹ ${tripExpenseOverview!['tripExpensePerPerson'].toString()}',
                                            subTitle: 'Per Person',
                                            ButtonText: '',
                                            // containerColor:  Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                height: 0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // color: Colors.grey,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('Expenses : ${tripExpenseOverview!['tripExpenseCount'].toString()}',),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Expanded(
                                      child: Container(
                                        // color: Colors.amber,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('Companions : ${widget.tripData!['tripCompanions'].toString()}',),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: containerHeight,
                          child: Column(
                            children: [
                              ChartCustom(
                                currentExpense: currentExpense,
                                data: data,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                height: 20,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // color: Colors.grey,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square_rounded,
                                            size: 10,
                                            color: Color(0xFF00CF85),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Travel'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.amber,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square_rounded,
                                            size: 10,
                                            color: Color(0xFFFFC976),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Food'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.grey,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square_rounded,
                                            size: 10,
                                            color: Color(0xFFFF7872),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Accomodation'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.amber,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.square_rounded,
                                            size: 10,
                                            color: Color(0xFF91E4F6),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Others'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: CustomSecondaryButton(
                                  buttonText: 'Add Expense',
                                  onPressed: () async {
                                    print(widget.tripData);
                                //  await fetchExpenseInformation();
                                //     // openCheckpointsBottomSheet(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                )),
                            height: 180,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                //First Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('22-10-2023'),
                                    Text('11:23 AM'),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.square,
                                          color: Color(0xFF00CF85),
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Travel'),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                //Second Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹ 1000',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //third row
                                Row(
                                  children: [
                                    Text('This is for food in Kozhikode'),
                                  ],
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    
                                    isExpanded: true,
                                    value: selectedCategory,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 28,
                                    dropdownColor: Colors.transparent,
                                    elevation: 0,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCategory = newValue!;
                                      });
                                    },
                                    padding: EdgeInsets.symmetric(horizontal: 20),

                                    items: categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        
                                        child: Text(category),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: containerHeight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCheckpointsBottomSheet(BuildContext context) {
    TextEditingController expenseAmount = TextEditingController();
    TextEditingController keyNote = TextEditingController();
    String? selectedCategory =
        'Category 1'; // Variable to hold the selected category

    // Define the list of categories for the dropdown
    List<String> categories = [
      'Category 1',
      'Category 2',
      'Category 3',
      'Category 4'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter customState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Add Your Expense',
                        style: CustomTextStyles.title2,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          // Icon(
                          //   Icons.info_outlined,
                          //   color: Colors.red.shade500,
                          // ),
                          // SizedBox(width: 5),
                          // Text(
                          //   'You Can Add Up to 6 Checkpoints',
                          //   style: TextStyle(
                          //     color: Colors.red.shade500,
                          //   ),
                          // ),
                        ],
                      ),

                      CustomInputField(
                        hintText: 'Add Expense Amount',
                        InputControl: expenseAmount,
                        inputIcon: Icons.currency_rupee_sharp,
                      ),
                      SizedBox(height: 15),
                      CustomInputField(
                        hintText: 'Add Key Note',
                        InputControl: keyNote,
                        inputIcon: Icons.sticky_note_2_outlined,
                      ),
                      SizedBox(height: 15),

                      // Dropdown field for selecting category
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                          // isDense: false,
                          isExpanded: true,
                          value: selectedCategory,
                          icon: Icon(Icons.keyboard_arrow_down),
                          iconSize: 28,
                          elevation: 2,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },

                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Container(
                                  color: Colors.red, child: Text(category)),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomAlertButton(
                                buttonText: 'Cancel',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: CustomSecondaryButton(
                              buttonText: 'Add',
                              onPressed: () {
                                // Perform actions on Add button click
                                // For example, you can access the selected category using "selectedCategory" variable.
                                // selectedCategory will hold the value of the currently selected category from the dropdown.
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Expense_Container extends StatelessWidget {
  final Color? containerColor;
  final String subTitle;
  final String Title;
  IconData? ButtonIcon;
  String? ButtonText;
  final Color? buttonColor;
  Expense_Container({
    this.containerColor,
    required this.subTitle,
    required this.Title,
    this.ButtonIcon,
    this.ButtonText,
    this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF636363),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            Title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: buttonColor,
                  ),
                  child: Icon(
                    ButtonIcon,
                    color: Colors.white,
                    size: 15,
                  )),
              SizedBox(
                width: 10,
              ),
              Text(ButtonText!),
            ],
          ),
        ],
      ),
    );
  }
}
