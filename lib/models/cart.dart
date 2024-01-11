import 'package:flutter/material.dart';

class Cart with ChangeNotifier{
  final String cartId;
  final String productId;
  final int quantity;
  Cart({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}
