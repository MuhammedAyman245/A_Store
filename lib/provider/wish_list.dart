import 'package:e_commerce/models/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishList> _wishListIems = {};
  Map<String, WishList> get getWishLists {
    return _wishListIems;
  }

  void addOrRemoveFromWishList({required productId}) {
    if (_wishListIems.containsKey(productId)) {
      _wishListIems.remove(productId);
    } else {
      _wishListIems.putIfAbsent(
        productId,
        () => WishList(
          wishListId: const Uuid().v4(),
          productId: productId,
        ),
      );
    }
    notifyListeners();
  }

  void clearLocalWishList() {
    _wishListIems.clear();
    notifyListeners();
  }

  bool isProdInWishList({required productId}) {
    return _wishListIems.containsKey(productId);
  }
}
