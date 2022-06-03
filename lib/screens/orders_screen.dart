import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = context.read<Orders>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrauwer(),
        body: ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, index) => OrderItemWidget(
                  order: orderData.orders[index],
                )));
  }
}
