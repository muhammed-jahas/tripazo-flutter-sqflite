import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripazo/database/database_helper.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> allTrips = [];
  List<Map<String, dynamic>> searchResults = [];
  bool showEmptyMessage = true;

  @override
  void initState() {
    super.initState();
    _loadAllTrips();
  }

  Future<void> _loadAllTrips() async {
    List<Map<String, dynamic>> trips =
        await DatabaseHelper.instance.readAllTrips();
    setState(() {
      allTrips = trips;
    });
  }

  void _searchTrips(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        searchResults.clear();
        showEmptyMessage = true; // When search bar is empty
      } else {
        searchResults = allTrips
            .where((trip) => trip['tripName']
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
        showEmptyMessage =
            searchResults.isEmpty; // When search results are empty
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: _searchTrips,
                decoration: InputDecoration(
                  hintText: 'Search Trips',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                      child: showEmptyMessage
                          ? Text(
                              'Search for your trips',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              'Not found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final trip = searchResults[index];
                        return ListTile(
                          title: Text(trip["tripName"]),
                          subtitle: Text(trip["tripDestination"]),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(trip["tripCover"])),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
