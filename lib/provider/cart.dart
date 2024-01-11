import 'package:e_commerce/models/cart.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Cart> _cartItems = {};
  Map<String, Cart> get getCartItems {
    return _cartItems;
  }

  void addProductToCart({required productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => Cart(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void updateQty({required productId, required int qty}) {
    _cartItems.update(
      productId,
      (cartItem) => Cart(
        cartId: cartItem.cartId,
        productId: productId,
        quantity: qty,
      ),
    );
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  bool isProdInCart({required productId}) {
    return _cartItems.containsKey(productId);
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0;

    _cartItems.forEach((key, value) {
      final getCurrentProduct = productProvider.findByProdId(value.productId);
      if (getCurrentProduct == null) {
        return;
      } else {
        total = total +
            double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total = total + value.quantity;
    });
    return total;
  }
}
