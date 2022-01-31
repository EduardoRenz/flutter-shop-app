import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyShop'),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                const PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favorites),
                const PopupMenuItem(
                    child: Text('Show All'), value: FilterOptions.All),
              ],
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.Favorites) {
                  provider.showFavoritesOnly();
                } else {
                  provider.showAll();
                }
              },
            ),
          ],
        ),
        body: const ProductGrid());
  }
}
