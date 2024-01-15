//category_page.dart
import 'package:flutter/material.dart';
import 'place_list_page.dart';
import '../models/region.dart';

class CategoryPage extends StatelessWidget {
  final Region region;

  const CategoryPage({Key? key, 
    required this.region,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Categories')),
      body: ListView.builder(
        itemCount: region.categories!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text(region.categories![index].name, style: const TextStyle(fontSize: 18)),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceListPage(
                      categoyName: region.categories![index].name,
                      regionName: region.name!),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}