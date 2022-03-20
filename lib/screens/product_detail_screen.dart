import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black,
                    offset: Offset(0, 1),
                  ),
                ]),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 10),
              Text('R\$ ${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 800),
            ],
          )),
        ],
      ),
    );
  }
}
