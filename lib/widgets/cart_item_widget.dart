import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {Key? key,
      required this.id,
      required this.productId,
      required this.title,
      required this.quantity,
      required this.price})
      : super(key: key);

  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<Cart>().removeItem(productId);
      },
      confirmDismiss: (diraction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content:
                      const Text('Do you want to remove item from the cart?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Yes')),
                  ],
                ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FittedBox(child: Text('\$$price'))),
              ),
              title: Text(title),
              subtitle: Text('Total: \$ ${price * quantity}'),
              trailing: Text('$quantity x'),
            )),
      ),
    );
  }
}
