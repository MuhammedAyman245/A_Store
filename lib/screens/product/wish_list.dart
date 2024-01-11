import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:e_commerce/provider/wish_list.dart';
import 'package:e_commerce/screens/cart/empty_cart.dart';
import 'package:e_commerce/services/assets_handler.dart';
import 'package:e_commerce/services/methods.dart';
import 'package:e_commerce/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/products/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const id = "/WishlistScreen";
  const WishlistScreen({super.key});
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final wishListProvier = Provider.of<WishListProvider>(context);

    return wishListProvier.getWishLists.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Nothing in ur wishlist yet",
              subtitle:
                  "Looks like your cart is empty add something and make me happy",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitlesTextWidget(
                  label: "Wishlist (${wishListProvier.getWishLists.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                        isError: false,
                        context: context,
                        subtitle: 'Clear Cart',
                        fct: () {
                          wishListProvier.clearLocalWishList();
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return ProductWidget(
                  productId: wishListProvier.getWishLists.values
                      .toList()[index]
                      .productId,
                );
              },
              itemCount: wishListProvier.getWishLists.length,
              crossAxisCount: 2,
            ),
          );
  }
}
