import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/models/place.dart';
import 'package:project_app/models/region.dart';

class DataBase {
  Future<Map<String, dynamic>> getPlacesData(
      String regionName, String categoyName) async {
    List<Place> places = [];
    try {
      QuerySnapshot<Map<String, dynamic>> regionsSnapshot =
          await FirebaseFirestore.instance
              .collection('places')
              .where("region", isEqualTo: regionName)
              .where("category", isEqualTo: categoyName)
              .get();
      List<dynamic> allData =
          regionsSnapshot.docs.map((doc) => doc.data()).toList();
      places = Place.getPlaces(allData);
      return {"Success": true, "Places": places, "Message": "success"};
    } catch (e) {
      log(e.toString());
      return {
        "Success": false,
        "Places": places,
        "Message": "Somthing went wrong"
      };
    }
  }

  Future<Map<String, dynamic>> getRegionsData() async {
    List<Region> regions = [];
    try {
      QuerySnapshot<Map<String, dynamic>> regionsSnapshot =
          await FirebaseFirestore.instance.collection('regions').get();
      List<dynamic> allData =
          regionsSnapshot.docs.map((doc) => doc.data()).toList();
      for (var element in allData) {
        Region model =  Region.getRegion(element);
        regions.add(model);
      }
      return {"Success": true, "Regions": regions, "Message": "success"};
    } catch (e) {
      log(e.toString());
      return {
        "Success": false,
        "Regions": regions,
        "Message": "Somthing went wrong"
      };
    }
  }

  Future<bool> setPlace(Place place) async {
    try {
      FirebaseFirestore.instance.collection('places').doc(place.id).set({
        'id': place.id,
        'category': place.category,
        'region': place.region,
        'name': place.name,
        'photoUrl': place.photoUrl,
        'description': place.description,
        'userLikes': place.userLikes,
        'userComments': place.userComments,
        'rate': place.rate,
        'asset': place.asset
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> addPlace(Place place) async {
    try {
      await FirebaseFirestore.instance.collection('places').doc(place.id).set({
        'id': place.id,
        'category': place.category,
        'region': place.region,
        'name': place.name,
        'photoUrl': place.photoUrl,
        'description': place.description,
        'userLikes': place.userLikes,
        'userComments': place.userComments,
        'rate': place.rate,
        'asset': place.asset
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }



 
}
