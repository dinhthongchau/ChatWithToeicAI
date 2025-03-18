import 'package:ct312hm01_temp/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:ct312hm01_temp/core/enum/load_status.dart';
import 'package:ct312hm01_temp/database/user_db.dart';
import 'package:ct312hm01_temp/models/user_model.dart';
import 'package:provider/provider.dart';

class AppAuthProvider extends ChangeNotifier {
  LoadStatus _loadStatus = LoadStatus.init;
  User? _currentUser;

  LoadStatus get loadStatus => _loadStatus;
  User? get currentUser => _currentUser;

  Future<void> loginWithEmail(String username, String password) async {
    _loadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      User? user = await UserDB.loginUser(username, password);
      if (user != null) {
        _currentUser = user;
        // Gọi ChatProvider để set userId


        _loadStatus = LoadStatus.done;
      } else {
        _loadStatus = LoadStatus.error;
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      _loadStatus = LoadStatus.error;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(
      String username, String password, String confirmPassword) async {
    _loadStatus = LoadStatus.loading;
    notifyListeners();

    if (password != confirmPassword) {
      _loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception("Passwords do not match");
    }

    try {
      User newUser = User(username: username, password: password);
      await UserDB.signupUser(newUser);
      _loadStatus = LoadStatus.done;
    } catch (e) {
      _loadStatus = LoadStatus.error;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  String getEmailAfterSignIn() {
    return _currentUser?.username ?? "No email available";
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}
