import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
            ),
            Consumer<Cart>(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                ),
                builder: (ctx, cart, child) => Badge(
                      value: cart.itemCount.toString(),
                      child: child!,
                    )),
          ],
        ),
        body: ProductGrid(showOnlyFavorites: _showOnlyFavorites));
  }
}
