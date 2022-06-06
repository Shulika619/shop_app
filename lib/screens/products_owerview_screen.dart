import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOwerviewScreen extends StatefulWidget {
  const ProductsOwerviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOwerviewScreen> createState() => _ProductsOwerviewScreenState();
}

class _ProductsOwerviewScreenState extends State<ProductsOwerviewScreen> {
  var isLoading = false;
  var isShowOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    context.read<ProductsProvider>().fetchAndSetProducts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorite) {
                    isShowOnlyFavorites = true;
                  } else {
                    isShowOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                        child: Text("Only favorite "),
                        value: FilterOptions.favorite),
                    const PopupMenuItem(
                        child: Text("Show All"), value: FilterOptions.all)
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const AppDrauwer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavorites: isShowOnlyFavorites),
    );
  }
}
