import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Scaffold(
        appBar: AppBar(title: const Text("Your Cart")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total: ',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      const Spacer(),
                      Chip(
                        label: Text(
                          '\$${cart.totalAmount}',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<Orders>().addOrder(
                                cart.items.values.toList(), cart.totalAmount);
                            cart.clear();
                          },
                          child: const Text(
                            'Order Now',
                            // style: TextStyle(co) Theme.of(context).,
                          )),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: cart.itemCount,
                itemBuilder: (context, index) => CartItemWidget(
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price),
              )
            ],
          ),
        ));
  }
}
