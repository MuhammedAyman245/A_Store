import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String userId, userName, userImage, userEmail;
  final Timestamp creatAt;
  final List userCart, userWish;
  UserModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.creatAt,
    required this.userCart,
    required this.userWish,
  });
}
