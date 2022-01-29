import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> loadedPRoducs = dummy_products;
  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
              itemCount: loadedPRoducs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (ctx, i) => ProductItem(loadedPRoducs[i])),
        ));
  }
}
