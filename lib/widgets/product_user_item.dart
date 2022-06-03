import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class ProductUserItem extends StatelessWidget {
  const ProductUserItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // final products = context.watch<ProductsProvider>();
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content:
                              const Text("Do you want to remove this product?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  context
                                      .read<ProductsProvider>()
                                      .removeProduct(id);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Yes')),
                          ],
                        ));
              },
              icon: const Icon(Icons.delete, color: Colors.red)),
        ]),
      ),
    );
  }
}
