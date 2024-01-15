// common_layout.dart

import 'package:flutter/material.dart';

class CommonLayout extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;
  final Widget destinationPage; 

  const CommonLayout({Key? key, 
    required this.title,
    required this.description,
    required this.onPressed,
    required this.destinationPage, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => destinationPage,
                  ));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
