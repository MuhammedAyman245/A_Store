import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:e_commerce/provider/viewed_product.dart';
import 'package:e_commerce/root_screen.dart';
import 'package:e_commerce/screens/cart/empty_cart.dart';
import 'package:e_commerce/services/assets_handler.dart';
import 'package:e_commerce/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/products/product_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const id = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewdRecentlyProvider = Provider.of<ViewdRecentlyProvider>(context);

    return viewdRecentlyProvider.getviewdRecently.isEmpty
        ? Scaffold(
            body: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RootScreen()));
              },
              child: EmptyBagWidget(
                imagePath: AssetsManager.orderBag,
                title: "No viewed products yet",
                subtitle:
                    "Looks like your cart is empty add something and make me happy",
                buttonText: "Shop now",
              ),
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
                  label:
                      "Viewed recently (${viewdRecentlyProvider.getviewdRecently.length})"),
            ),
            body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return ProductWidget(
                  productId: viewdRecentlyProvider.getviewdRecently.values
                      .toList()[index]
                      .productId,
                );
              },
              itemCount: viewdRecentlyProvider.getviewdRecently.length,
              crossAxisCount: 2,
            ),
          );
  }
}
