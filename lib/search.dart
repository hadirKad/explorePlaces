import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) searchFunction;

  SearchBar({required this.searchFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (query) {
          List<String> results = searchFunction(query);
          // Handle the search results as needed
          print(results);
        },
        decoration: InputDecoration(
          labelText: 'Search Places',
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // Clear the search field
            },
          ),
        ),
      ),
    );
  }
}
