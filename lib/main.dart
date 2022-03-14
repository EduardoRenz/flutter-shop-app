import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_form_screen.dart';
import 'package:shop/utils/app_routes.dart';

import 'screens/auth_or_home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
  await dotenv.load();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (ctx, auth, previous) =>
              ProductList(auth.token ?? '', previous?.items ?? []),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList('', []),
          update: (ctx, auth, previous) =>
              OrderList(auth.token ?? '', previous?.orders ?? []),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrange,
        ),
        //home: const ProductsOverviewScreen(),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => const AuthOrHomeScreen(),
          //AppRoutes.AUTH: (ctx) => const AuthScreen(),
          //AppRoutes.HOME: (ctx) => const ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailsScreen(),
          AppRoutes.CART: (ctx) => const CartScreen(),
          AppRoutes.ORDERS: (ctx) => const OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormScreen(),
        },
      ),
    );
  }
}
