import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin Auth {

  static final auth = FirebaseAuth.instance;
  static final db = FirebaseFirestore.instance;

  Future<String> getUidIfUserIsLoggedIn() async {
    if (await auth.currentUser != null) {
      return auth.currentUser?.uid ?? "";
    } else { return ""; }
  }

  Future<bool> login(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user != null;
  }

  Future<bool> createUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) { print(e); }
    return false;
  }

}