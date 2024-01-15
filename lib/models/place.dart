class Place {
  final String name;
  final String photoUrl;
  final String description;
  int userLikes;
  List<dynamic> userComments;
  bool asset;
  int rate;
  String id;
  String category;
  String region;

  Place(
      {required this.name,
      required this.photoUrl,
      required this.description,
      required this.userLikes,
      required this.userComments,
      required this.asset,
      required this.id,
      required this.rate,
      required this.category,
      required this.region});

  @override
  String toString() {
    return "name :  $name , photoUrl : $photoUrl , "
        "desc : $description , userLikes : $userLikes , userComments : $userComments"
        ", asset : $asset , id : $id";
  }

  static List<Place> getPlaces(category) {
    List<Place> places = [];
    for (var element in category) {
      String id = element['id'];
      bool asset = element['asset'];
      String name = element['name'];
      String photoUrl = element['photoUrl'];
      String description = element['description'];
      int userLikes = element['userLikes'];
      List<dynamic> userComments = element['userComments'];
      int rate = element['rate'];
      String category = element['category'];
      String region = element['region'];

      places.add(Place(
          name: name,
          photoUrl: photoUrl,
          description: description,
          userLikes: userLikes,
          userComments: userComments,
          id: id,
          asset: asset,
          rate: rate,
          category: category,
          region: region));
    }
    return places;
  }
}
