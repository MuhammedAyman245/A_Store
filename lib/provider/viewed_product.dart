import 'package:e_commerce/models/viewed_product.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewdRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedProduct> _viewdRecentlyIems = {};
  Map<String, ViewedProduct> get getviewdRecently {
    return _viewdRecentlyIems;
  }

  void addProduct({required productId}) {
    _viewdRecentlyIems.putIfAbsent(
      productId,
      () => ViewedProduct(
        viewedProductId: const Uuid().v4(),
        productId: productId,
      ),
    );

    notifyListeners();
  }
}
