import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<OrderItem> orders = [];
  bool loading = false;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    setState(() {
      loading = true;
    });

    try {
      ApiResponse res = await locator<Repository>().getOrderList();
      if (res.statusCode == 200) {
        orders = (res.data["orders"] as List)
            .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My orders",
          style: TextStyle(color: kcBlackColor),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                OrderItem order = orders[index];
                return ListTile(
                  onTap: () {
                    locator<NavigationService>().navigateToTrack(item: order);
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kcVeryLightGrey),
                  ),
                  title: Text(order.product?.productName ?? ""),
                  subtitle: Text("N${order.product?.productPrice}"),
                );
              }),
    );
  }
}
