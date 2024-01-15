// place_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_app/fire_base/database.dart';
import '../models/place.dart';

class PlaceDetailPage extends StatefulWidget {
  final Place place;

  const PlaceDetailPage({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  PlaceDetailPageState createState() => PlaceDetailPageState();
}

class PlaceDetailPageState extends State<PlaceDetailPage> {
  double userRating = 0.0;
  bool isLoading = false;

 @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              widget.place.asset
                  ? Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image(
                            image: AssetImage(widget.place.photoUrl),
                            fit: BoxFit.cover),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image(
                            image:NetworkImage(widget.place.photoUrl),
                            fit: BoxFit.cover),
                      ),
                    ),
              const SizedBox(height: 16),
              Text(
                widget.place.description,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
               isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                :RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    userRating = rating;
                    widget.place.rate =
                        ((widget.place.rate + rating) / 2) as int;
                  });
                  updatePlace();
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.thumb_up),
                              onPressed: () {
                                setState(() {
                                  widget.place.userLikes++;
                                });
                                updatePlace();
                              },
                            ),
                      Text('Likes: ${widget.place.userLikes}'),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () => _showCommentDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('User Comments:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              widget.place.userComments.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.place.userComments.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(widget.place.userComments[index]),
                        );
                      })
                  : const Text('No comment ', style: TextStyle(fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    String newComment = '';

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add a Comment'),
        content: TextField(
          onChanged: (value) {
            // Handle updating the new comment
            newComment = value;
          },
          decoration: const InputDecoration(labelText: 'Comment'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                widget.place.userComments.add(newComment);
              });
              updatePlace();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text('Add Comment'),
          ),
        ],
      ),
    );
  }

  Future<void> updatePlace() async {
    setState(() {
      isLoading = true;
    });
    bool result = await DataBase().setPlace(widget.place);
    if (result) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "comment added",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
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
      isLoading = false;
    });
  }
}
