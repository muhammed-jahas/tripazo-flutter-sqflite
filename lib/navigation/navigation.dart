import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:tripline/screens/catalog_screens/catalog_screen.dart';
import 'package:tripline/screens/home_screens/home_screen.dart';
import 'package:tripline/screens/settings_screens/settings_screen.dart';
import 'package:tripline/screens/tools_screens/tools_screen.dart';
import 'package:tripline/styles/color_styles.dart';

// ...

// ignore: must_be_immutable
class NavigationItems extends StatefulWidget {
  final Map<String, dynamic> loggedInUserData;
  int? targetIndex;

  NavigationItems(this.loggedInUserData, [this.targetIndex]);

  @override
  State<NavigationItems> createState() => _NavigationItemsState();
}

class _NavigationItemsState extends State<NavigationItems> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.targetIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(loggedInUserData: widget.loggedInUserData),
            ToolsParentScreen(loggedInUserData: widget.loggedInUserData),
            CatalogScreen(loggedInUserData: widget.loggedInUserData),
            SettingsScreen(loggedInUserData: widget.loggedInUserData),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
              color: Colors.grey.shade100,
            ))),
        child: GNav(
          // rippleColor: Colors.grey.shade800,
          // hoverColor: Colors.grey.shade700,
          // haptic: true,
          tabBorderRadius: 15,
          // tabActiveBorder: Border.all(color: Colors.black, width: 1),
          // tabBorder: Border.all(color: Colors.grey, width: 1),
          // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
          // curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 100),
          gap: 8,

          activeColor: CustomColors.primaryColor.shade800,
          iconSize: 24,
          color: Colors.grey.shade500,
          tabBackgroundColor: CustomColors.primaryColor.withOpacity(.2),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: [
            GButton(
              icon: Icons.grid_view_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.layers_outlined,
              text: 'Tools',
            ),
            GButton(
              icon: Icons.bookmark_added_outlined,
              text: 'Catalog',
            ),
            GButton(
              icon: Icons.settings_outlined,
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
