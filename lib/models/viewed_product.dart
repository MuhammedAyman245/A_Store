
import 'package:flutter/material.dart';

class ViewedProduct with ChangeNotifier{
  final String viewedProductId;
  final String productId;
  ViewedProduct({
    required this.viewedProductId,
    required this.productId,
  });
}
