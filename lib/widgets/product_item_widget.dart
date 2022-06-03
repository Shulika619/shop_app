import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = context.read<Product>();
    final cart = context.read<Cart>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    // color: Theme.of(context).colorScheme.secondary,
                  )),
            ),
            title: Text(product.title, textAlign: TextAlign.center),
            trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Added item to cart!',
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'cancel',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
