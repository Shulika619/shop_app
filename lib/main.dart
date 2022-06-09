import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_owerview_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (context) => ProductsProvider("", "", []),
            update: (context, auth, products) => ProductsProvider(auth.token,
                auth.userId, products == null ? [] : products.items)),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders("", "", []),
            update: (context, auth, orders) => Orders(
                auth.token, auth.userId, orders == null ? [] : orders.orders)),
      ],
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                title: 'Shop',
                theme: ThemeData(
                    fontFamily: 'Lato',
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                            .copyWith(secondary: Colors.amber[700])),
                home: auth.isAuth
                    ? const ProductsOwerviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()),
                routes: {
                  AuthScreen.routeName: (context) => const AuthScreen(),
                  ProductsOwerviewScreen.routeName: (context) =>
                      const ProductsOwerviewScreen(),
                  ProductDetailScreen.routeName: (context) =>
                      const ProductDetailScreen(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  UserProductsScreen.routeName: (context) =>
                      const UserProductsScreen(),
                  EditProductScreen.routeName: (context) =>
                      const EditProductScreen(),
                },
              )),
    );
  }
}
