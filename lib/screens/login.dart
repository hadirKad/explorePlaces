// login.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_app/fire_base/auth.dart';
import 'package:project_app/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKeyLogin = GlobalKey<FormState>();

  String? _loginEmail;
  String? _loginPassword;
  bool isLoading = false;

  Future<void> _submitLogin() async {
    if (_formKeyLogin.currentState!.validate()) {
      log('Login - Email: $_loginEmail, Password: $_loginPassword');
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> result = await Auth().signInWithEmailAndPassword(email: _loginEmail!, password: _loginPassword!);
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
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyLogin,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                      _loginEmail = value;
                    }
                  },
                ),
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
                      _loginPassword = value;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isLoading)
                  const SizedBox(
                      height: 30, width: 30, child: CircularProgressIndicator()),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _submitLogin,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
