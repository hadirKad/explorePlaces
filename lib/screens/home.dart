import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_app/screens/category_page.dart';
import 'package:project_app/fire_base/auth.dart';
import 'package:project_app/fire_base/database.dart';
import 'package:project_app/screens/login.dart';
import 'package:project_app/models/region.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  List<Region> regionsInfo = [];
  bool logoutLoading = false;
  bool isloading = false;
  signOut() async {
    setState(() {
      logoutLoading = true;
    });
    Map<String, dynamic> result = await Auth().signOut();
    setState(() {
      logoutLoading = false;
    });
    log(result.toString());
    if (result['Success']) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          result['Message'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route route) => false);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          result['Message'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  getRegiens() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> result = await DataBase().getRegionsData();
    setState(() {
      isloading = false;
    });
    if (result['Success']) {
      regionsInfo = result['Regions'];
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          result['Message'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    getRegiens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Places'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///sign out button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  signOut();
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    logoutLoading
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sign Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text(
            'Select a Region',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          isloading
              ? const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: regionsInfo.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      double screenWidth = MediaQuery.of(context).size.width;
                      double maxFontSize = 35;
                      double fontSize =
                          screenWidth < 600 ? maxFontSize * 0.7 : maxFontSize;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryPage(region: regionsInfo[index]),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(regionsInfo[index].image!),
                              radius: 100,
                            ),
                            Positioned(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  regionsInfo[index].name!,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
