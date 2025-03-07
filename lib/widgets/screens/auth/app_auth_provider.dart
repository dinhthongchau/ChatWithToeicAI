import 'package:ct312hm01_temp/common/enum/load_status.dart';
import 'package:ct312hm01_temp/widgets/common_widgets/custom_notice_snackbar.dart';
import 'package:ct312hm01_temp/widgets/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';


class AppAuthProvider extends ChangeNotifier {
  LoadStatus _loadStatus = LoadStatus.Init;

  LoadStatus get loadStatus => _loadStatus;

  Future<void> loginWithEmail(BuildContext context,String emailController, String passwordController) async {

    _loadStatus = LoadStatus.Loading;
    notifyListeners();
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController, password: passwordController);
      _loadStatus = LoadStatus.Done;
      notifyListeners();
      Navigator.of(context).pushNamed(ChatScreen.route);
    }catch(e){
      _loadStatus = LoadStatus.Error;
      ScaffoldMessenger.of(context).showSnackBar(
        customNoticeSnackbar(context, "$e", true),
      );
      notifyListeners();
    }

  }

  Future<void> signUpWithEmail(context,String email, String password, String confirmPassword) async {
    _loadStatus = LoadStatus.Loading;
    if (password== confirmPassword){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      _loadStatus = LoadStatus.Done;
      Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamed(LoginScreen.route);
    }
    else {
      _loadStatus = LoadStatus.Error;
    }

  }
  String getEmailAfterSignIn(){
    return FirebaseAuth.instance.currentUser?.email ?? "No email available";
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed(LoginScreen.route);
  }

}


