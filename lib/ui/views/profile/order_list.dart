import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/empty_state.dart';
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
        for (var element in (res.data["orders"] as List)) {
          if (element != null) {
            orders.add(OrderItem.fromJson(Map<String, dynamic>.from(element)));
          }
        }
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
          : orders.isEmpty
              ? const EmptyState(
                  animation: "empty_order.json", label: "No Orders Yet")
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    OrderItem order = orders[index];
                    return ListTile(
                      onTap: () {
                        locator<NavigationService>()
                            .navigateToTrack(item: order);
                      },
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kcVeryLightGrey,
                            image: order.product?.pictures == null ||
                                    order.product!.pictures!.isEmpty
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(order
                                        .product!.pictures![0].location!))),
                      ),
                      title: Text(order.product?.productName ?? ""),
                      subtitle: Text("N${order.product?.productPrice}"),
                    );
                  }),
    );
  }
}
