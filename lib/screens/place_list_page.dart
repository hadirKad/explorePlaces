// place_list_page.dart
import 'package:flutter/material.dart';
import 'package:project_app/fire_base/database.dart';
import 'package:project_app/models/place.dart';
import 'package:project_app/screens/place_add_page.dart';
import 'place_detail_page.dart';


class PlaceListPage extends StatefulWidget {
  final String regionName;
  final String categoyName;

  const PlaceListPage({
    Key? key,
    required this.categoyName,
    required this.regionName,
  }) : super(key: key);

  @override
  PlaceListPageState createState() => PlaceListPageState();
}

class PlaceListPageState extends State<PlaceListPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Place> places = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    // Simulate loading data (replace with your actual data loading logic)
    Map<String, dynamic> result =
        await DataBase().getPlacesData(widget.regionName, widget.categoyName);
    setState(() {
      _isLoading = false;
    });
    if (result["Success"]) {
      setState(() {
        places = result['Places'];
      });
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoyName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _navigateToAddPlacePage(context);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_hasError) {
      return const Center(
        child: Text('Error loading places. Please try again.'),
      );
    } else if (places.isEmpty) {
      return const Center(
        child: Text('No places available for this category.'),
      );
    } else {
      return _buildPlaceList();
    }
  }

  Widget _buildPlaceList() {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(places[index].name,
                style: const TextStyle(fontSize: 16)),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaceDetailPage(place: places[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _navigateToAddPlacePage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceAddPage(categoyName: widget.categoyName , regionName: widget.regionName),
      ),
    );
    // You can add additional logic here to refresh the place list if needed
  }
}
