// authentication.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_app/fire_base/auth.dart';
import 'package:project_app/screens/home.dart';
import 'login.dart'; // Import the login page

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKeySignUp = GlobalKey<FormState>();

  String? _signUpFirstName;
  String? _signUpLastName;
  String? _signUpEmail;
  String? _signUpPassword;
  bool isLoading = false;

  Future<void> _submitSignUp() async {
    if (_formKeySignUp.currentState!.validate()) {
      log('Sign Up - First Name: $_signUpFirstName, Last Name: $_signUpLastName, Email: $_signUpEmail, Password: $_signUpPassword');
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> result = await Auth().createUserWithEmailAndPassword(firstName: _signUpFirstName!, lastName: _signUpLastName!,email: _signUpEmail!, password: _signUpPassword!);
      setState(() {
        isLoading = false;
      });
      log(result.toString());
      if (result['Success']) {
         // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['Message'] , style: const TextStyle(color: Colors.white),) , backgroundColor: Colors.green,));
       // ignore: use_build_context_synchronously
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route route) => false);       
      }else{
         // ignore: use_build_context_synchronously
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['Message'] , style: const TextStyle(color: Colors.white),) , backgroundColor: Colors.red,));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sign Up Form
              Form(
                key: _formKeySignUp,
                child: Column(
                  children: [
                    //first name
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _signUpFirstName = value.toString();
                        }
                      },
                    ),
                    //lastName
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _signUpLastName = value.toString();
                        }
                      },
                    ),
                    //email
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _signUpEmail = value.toString();
                        }
                      },
                    ),
                    //password
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _signUpPassword = value.toString();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(isLoading)
                    const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _submitSignUp();
                      },
                      child: const Text('Sign Up'),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Login Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                    "If you already have an account, click here to login",
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
