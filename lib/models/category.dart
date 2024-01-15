// category.dart


import 'package:project_app/models/place.dart';

class Category {
  String name;
  List<Place> places;

  Category(
    
    {
      required this.places,
    required this.name,
  });

  @override
  String toString() {
    return "name :  $name ";
  }

  
  static List<Category> getCategories(dynamic categoriesList) {
    List<Category> categories = [];
    for (var category in categoriesList) {
      String name = category['name'];
      categories.add(Category(name: name, places: []));
    }
    return categories;
  }

}