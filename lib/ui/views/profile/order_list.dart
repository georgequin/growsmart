import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/profile/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../utils/orderUtil.dart';
import '../../components/submit_button.dart';

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

  List<OrderItem> _activeOrders() {
    return orders.where((order) => order.status == 1).toList();
  }

  List<OrderItem> _completedOrders() {
    return orders.where((order) => order.status == 0).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My orders",
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
          : DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child:TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: kcPrimaryColor, // Tab background color for active tab
                ),
                tabs: [
                  Tab(text: 'Active Orders (${orders.where((element) => element.status == 1).length})'),
                  Tab(text: 'Completed Orders (${orders.where((element) => element.status == 0).length})'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(_activeOrders()), // Active Orders
                  _buildOrderList(_completedOrders()), // Completed Orders
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> filteredOrder) {
    return filteredOrder.isEmpty ?  const EmptyState(
        animation: "empty_order.json", label: "No Orders Yet") :
    ListView.builder(
      itemCount: filteredOrder.length,
      itemBuilder: (context, index) {
        OrderItem order = filteredOrder[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kcVeryLightGrey,
                        image: order.product?.pictures == null || order.product!.pictures!.isEmpty
                            ? null
                            : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(order.product!.pictures![0].location!),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${order.product?.productName}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text("Order ID: ${order.id}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          SizedBox(height: 4),

                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Quantity: ${order.quantity}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text("On ${DateFormat("d MMM").format(DateTime.parse(order.created!))}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        OrderUtil.statusChip(order.tracking!.status!),
                        // Chip(
                        //   label: Text('Delivered', style: TextStyle(color: Colors.white)),
                        //   backgroundColor: Colors.green,
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          locator<NavigationService>().navigateToTrack(item: order);
                        },
                        icon: Icon(Icons.local_shipping_outlined, size: 16),
                        label: Text("Track Order"),
                        style: ElevatedButton.styleFrom(
                          primary: kcSecondaryColor, // Background color
                          onPrimary: Colors.white, // Text color
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        // handle See Ticket action
                      },
                      icon: Icon(Icons.receipt_long_outlined, color: Colors.black),
                      label: Text("See Ticket", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


}

