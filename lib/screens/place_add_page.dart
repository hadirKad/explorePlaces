import 'package:flutter/material.dart';
import 'package:project_app/fire_base/database.dart';
import 'package:project_app/models/place.dart';
import 'package:project_app/screens/place_list_page.dart';

class PlaceAddPage extends StatefulWidget {
  final String regionName;
  final String categoyName;

  const PlaceAddPage({
    Key? key,
    required this.categoyName,
    required this.regionName,
  }) : super(key: key);

  @override
  PlaceAddPageState createState() => PlaceAddPageState();
}

class PlaceAddPageState extends State<PlaceAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool isloading = false;

  // Add other necessary controllers for handling image and other inputs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Place')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Place in ${widget.categoyName}'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'imageUrl'),
            ),
            // Add other form elements for image, comments, etc.
            const SizedBox(height: 16),
            if (isloading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addPlace();
              },
              child: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPlace() async {
    // Handle adding the place to the category
    String name = _nameController.text;
    String description = _descriptionController.text;
    String imageUrl = _imageUrlController.text;
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    if (name.isNotEmpty && description.isNotEmpty && imageUrl.isNotEmpty) {
      setState(() {
        isloading = true;
      });
      Place place = Place(
          name: name,
          asset: false,
          category: widget.categoyName,
          region: widget.regionName,
          id: id,
          rate: 0,
          photoUrl: imageUrl, // Replace with actual image data
          description: description,
          userComments: [],
          userLikes: 0);
      bool result = await DataBase().addPlace(place);
      if (result) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "place added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => PlaceListPage(
                    categoyName: widget.categoyName,
                    regionName: widget.regionName)),
            (Route route) => false);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "somthing went wrong",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }

      setState(() {
        isloading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "complete all informtions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }

    // Navigate back to the previous screen
    //Navigator.pop(context);
  }
}
