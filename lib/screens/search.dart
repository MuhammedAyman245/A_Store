import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/services/assets_handler.dart';
import 'package:e_commerce/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products/product_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String id = 'searchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategories =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategories == null
        ? productProvider.products
        : productProvider.findProductByCat(catName: passedCategories);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.shoppingCart,
            ),
          ),
          title: TitlesTextWidget(label: passedCategories ?? "Search products"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // setState(() {
                      FocusScope.of(context).unfocus();
                      searchTextController.clear();
                      // });
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productListSearch = productProvider.searchQuery(
                        searchText: searchTextController.text,
                        passedList: productList);
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    productListSearch = productProvider.searchQuery(
                      searchText: searchTextController.text,
                      passedList: productList,
                    );
                  });
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              if (searchTextController.text.isNotEmpty &&
                  productListSearch.isEmpty) ...[
                const Center(
                  child: TitlesTextWidget(label: 'No Products Found'),
                )
              ],
              Expanded(
                child: DynamicHeightGridView(
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  builder: (context, index) {
                    return ProductWidget(
                      productId: searchTextController.text.isNotEmpty
                          ? productListSearch[index].productId
                          : productList[index].productId,
                    );
                  },
                  itemCount: searchTextController.text.isNotEmpty
                      ? productListSearch.length
                      : productList.length,
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
