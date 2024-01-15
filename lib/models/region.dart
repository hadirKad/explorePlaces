import 'category.dart';
class Region {
  String? name;
  String? image;
  List<Category>? categories;

  Region({
    required this.name,
    required this.image,
    required this.categories,
  });

  @override
  String toString() {
    return "name :  $name , image : $image , categories : ${categories.toString()}";
  }

  static Region getRegion(dynamic element) {
    String name = element['name'];
    String image = element['image'];
    return Region(
        name: name,
        image: image,
        categories: element['categories'] != null
            ? Category.getCategories(element['categories'])
            : []);
  }


 
}
