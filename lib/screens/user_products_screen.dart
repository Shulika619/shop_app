import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_user_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<ProductsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      drawer: const AppDrauwer(),
      body: Padding(
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
    );
  }
}
