import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AppAuthProvider extends ChangeNotifier {
  LoadStatus _loadStatus = LoadStatus.Init;

  LoadStatus get loadStatus => _loadStatus;

  Future<void> loginWithEmail(String emailController,String passwordController) async {
    _loadStatus = LoadStatus.Loading;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController, password: passwordController);
      _loadStatus = LoadStatus.Done;
      notifyListeners();

    } catch (e) {
      _loadStatus = LoadStatus.Error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password,
      String confirmPassword) async {
    _loadStatus = LoadStatus.Loading;
    notifyListeners();

    if (password != confirmPassword) {
      _loadStatus = LoadStatus.Error;
      notifyListeners();
      throw Exception("Passwords do not match");
    }


    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      _loadStatus = LoadStatus.Done;
      notifyListeners();
    } catch (e) {
      _loadStatus = LoadStatus.Error;
      notifyListeners();
      rethrow;
    }
  }


String getEmailAfterSignIn() {
  return FirebaseAuth.instance.currentUser?.email ?? "No email available";
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();

}}
