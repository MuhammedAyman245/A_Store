import 'package:flutter/material.dart';

class WishList with ChangeNotifier{
  final String wishListId;
  final String productId;
  WishList({
    required this.wishListId,
    required this.productId,
  });
}
