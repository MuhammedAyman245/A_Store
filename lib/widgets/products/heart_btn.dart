import 'package:e_commerce/provider/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
    required this.productId,
    this.isInWishList = false,
  });
  final Color bkgColor;
  final double size;
  final String productId;
  final bool? isInWishList;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () {
          wishListProvider.addOrRemoveFromWishList(productId: widget.productId);
        },
        icon: Icon(
            wishListProvider.isProdInWishList(productId: widget.productId)
                ? IconlyBold.heart
                : IconlyLight.heart,
            size: widget.size,
            color:
                wishListProvider.isProdInWishList(productId: widget.productId)
                    ? Colors.red
                    : Colors.grey),
      ),
    );
  }
}
