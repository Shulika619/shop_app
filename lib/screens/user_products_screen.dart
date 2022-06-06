import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_user_item.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<ProductsProvider>().fetchAndSetProducts;
  }

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<ProductsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, EditProductScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrauwer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: productsData.items.length,
              itemBuilder: (context, i) => ProductUserItem(
                    id: productsData.items[i].id,
                    title: productsData.items[i].title,
                    imageUrl: productsData.items[i].imageUrl,
                  )),
        ),
      ),
    );
  }
}
