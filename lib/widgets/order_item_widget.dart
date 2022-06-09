import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  final OrderItem order;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _isExpanded ? min(widget.order.products.length * 30 + 110, 200) : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime)),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            // if (_isExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded
                  ? min(widget.order.products.length * 30 + 10, 100)
                  : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              // height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.order.products[i].title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                                '${widget.order.products[i].quantity} x ${widget.order.products[i].price}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ])),
            )
          ],
        ),
      ),
    );
  }
}
