import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/fire_base/shared_preferences.dart';
import 'package:project_app/models/user.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  static Future<UserModel?> getUserInfo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (doc.exists) {
      return UserModel(
          id: id,
          firstName: doc.get('firstName'),
          lastName: doc.get('lastName'),
          email: doc.get("email"));
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential auth = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (auth.user != null && auth.user!.emailVerified) {
        await auth.user!.sendEmailVerification();
        return {
          "Success": false,
          "Message": "please confirm your email address and logIn"
        };
      } else {
        String id = auth.user!.uid;
        UserModel? user = await getUserInfo(id);
        if (user != null) {
          SharedPreferencesController.saveUserInfo(user);
          return {"Success": true, "Message": "logIn sucesse"};
        } else {
          return {"Success": false, "Message": "User no found"};
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {"Success": false, "Message": "User no found."};
      } else if (e.code == 'wrong-password') {
        return {"Success": false, "Message": "The password is wrong"};
      } else {
        return {"Success": false, "Message": "Somthing went wrong"};
      }
    }
  }

  Future<Map<String, dynamic>> createUserWithEmailAndPassword(
      {required String lastName,
      required String firstName,
      required String email,
      required String password}) async {
    try {
      UserCredential auth = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (auth.user != null && auth.user!.emailVerified) {
        await auth.user!.sendEmailVerification();
        return {
          "Success": false,
          "Message": "please confirm your email address and logIn"
        };
      } else {
        String id = auth.user!.uid;
        FirebaseFirestore.instance.collection('users').doc(id).set({
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        });
        UserModel user = UserModel(
            id: id, firstName: firstName, lastName: lastName, email: email);
        SharedPreferencesController.saveUserInfo(user);
        return {"Success": true, "Message": "SignUp sucesse"};
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return {
          "Success": false,
          "Message": "The password provided is too weak."
        };
      } else if (e.code == 'email-already-in-use') {
        return {
          "Success": false,
          "Message": "The account already exists for that email."
        };
      } else {
        return {"Success": false, "Message": "Somthing went wrong"};
      }
    }
  }

  Future<Map<String, dynamic>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      SharedPreferencesController.resetUserInfo();
      return {"Success": true, "Message": "Sign out success"};
    } catch (e) {
      return {"Success": false, "Message": "Somthing went wrong"};
    }
  }
}
