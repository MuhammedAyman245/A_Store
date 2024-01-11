import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModelProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel => userModel;
  Future<UserModel?> getUserData() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    String uId = user.uid;
    try {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();
      final res = userData.data();
      userModel = UserModel(
        userId: userData.get('userId'),
        userName: userData.get('userName'),
        userImage: userData.get('userImage'),
        userEmail: userData.get('userEmail'),
        creatAt: userData.get('createdAt'),
        userCart: res!.containsKey('userCart') ? userData.get('userCart') : [],
        userWish: res.containsKey('userWish') ? userData.get('userWish') : [],
      );
      return userModel;
    // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
