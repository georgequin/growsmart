import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/utils/money_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../utils/order_util.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<OrderItem> orders = [];
  bool loading = false;
  bool loadingReview = false;
  bool loadingPayment = false;
  int selectedPaymentMethod = 1;
  final plugin = PaystackPlugin();

  @override
  void initState() {
    getOrders();
    plugin.initialize(publicKey: MoneyUtils().payStackPublicKey);
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
     throw Exception(e);
    }

    setState(() {
      loading = false;
    });
  }

  chargeCard(OrderItem order, String paymentMethod, PaystackPlugin plugin, void Function(void Function()) setModalState) async {
    setState(() {
      loadingPayment = true;
    });
    setModalState(() {
      loadingPayment = true;
    });

    int amount = order.product!.productPrice! * order.quantity!;

    if (profile.value.country != null && profile.value.country!.shippingFee != null) {
      amount += profile.value.country!.shippingFee!;
    }
    List<String> orderIds = [order.id!];

    ApiResponse res = await MoneyUtils().chargeCardUtil(paymentMethod, orderIds, plugin, context, amount);

    if (!mounted) return; // Check if the widget is still in the tree

    Navigator.pop(context);

    if (res.statusCode == 200) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildPaymentSuccessDialog();
        },
      );
    } else {
      locator<SnackbarService>().showSnackbar(message: res.data["message"]);
    }

    if (!mounted) return; // Check again before modifying the state
    setState(() {
      loadingPayment = false;
    });
    setModalState(() {
      loadingPayment = false;
    });
  }

  Widget buildPaymentSuccessDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              'assets/animations/payment_success.json',
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getOrders();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  List<OrderItem> _activeOrders() {
    return orders.where((order) => order.status! <= 4).toList();
  }

  List<OrderItem> _completedOrders() {
    return orders.where((order) => order.status! == 5 || order.status! == 6).toList();
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
                indicator: const BoxDecoration(
                  color: kcPrimaryColor, // Tab background color for active tab
                ),
                tabs: [
                  Tab(text: 'Active Orders (${orders.where((element) => element.status == 1).length})'),
                  Tab(text: 'Completed Orders (${orders.where((element) => element.status == 5 || element.status == 6).length})'),
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
    filteredOrder.sort((a, b) {
      DateTime dateA = DateTime.parse(a.created!);
      DateTime dateB = DateTime.parse(b.created!);
      return dateB.compareTo(dateA); // Use compareTo for the sorting
    });

    return filteredOrder.isEmpty ?  const EmptyState(
        animation: "empty_order.json", label: "No Orders Yet") :

    ListView.builder(
      itemCount: filteredOrder.length,
      itemBuilder: (context, index) {
        OrderItem order = filteredOrder[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    OrderUtil.statusText(order.status!),
                    horizontalSpaceSmall,
                    Text("On ${DateFormat("d MMM").format(DateTime.parse(order.created!))}",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                horizontalSpaceSmall,
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${order.product?.productName}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              verticalSpaceTiny,
                              Text("Quantity: ${order.quantity}",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              verticalSpaceTiny,
                              Text("Order ID: ${order.tracking?.trackingNumber}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),

                            ],
                          ),
                        ),
                      ],
                    ),)
                ),
                horizontalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: order.tracking!.status! != 1 ? () {
                          locator<NavigationService>().navigateToTrack(item: order);
                        } : null, // If trackStatus is false, button will be disabled
                        icon: Icon(
                          Icons.local_shipping_outlined,
                          size: 16,
                          color: order.tracking!.status! != 1 ? kcPrimaryColor : Colors.grey,
                        ),
                        label: Text(
                          "Track Order",
                          style: TextStyle(
                            color: order.tracking!.status! != 1 ? Colors.white : Colors.grey,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: order.tracking!.status! != 1 ? kcSecondaryColor : Colors.grey.shade400, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Color when the button is disabled
                          // Add other properties like padding, shape, etc., as needed
                        ),
                      ),
                    )
                  ],
                ),
                if (order.paymentStatus != 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: !loadingPayment, // Prevent dismiss when loading
                              enableDrag: !loadingPayment,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setStateModal)
                                {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Image.network(
                                              '${order.product?.pictures?.first
                                                  .location!}'),
                                          // Replace with product image URL
                                          title: Text(
                                              "${order.product?.productName!}"),
                                          subtitle: Text(
                                              'Quantity: ${order.quantity}\nOrder ID: ${order.tracking!.trackingNumber!}'),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Billing Summary',
                                          style: TextStyle(fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            const Text('Sub-Total'),
                                            Text(MoneyUtils().formatAmount(order.product!.productPrice!),
                                              style: TextStyle(
                                                color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                                fontFamily: "satoshi",
                                              ),),

                                            // Replace with actual data
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            const Text('Delivery'),
                                            Text(order.product?.shippingFee != null && order.product!.shippingFee! != 0 ?
                                            MoneyUtils().formatAmount(order.product!.shippingFee!) : 'Free', style: TextStyle(
                                              color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                              fontFamily: "satoshi",
                                            ),),
                                            // Replace with actual data
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            const Text('Total', style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                            Text(MoneyUtils().formatAmount(order.product!.productPrice! + order.product!.shippingFee!),  style: TextStyle(
                                color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                fontFamily: "satoshi",
                                              fontWeight: FontWeight.bold
                                ),),
                                            // Replace with actual data
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Choose Payment Method',
                                          style: TextStyle(fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  if (selectedPaymentMethod !=
                                                      1) {
                                                    setStateModal(() {
                                                      selectedPaymentMethod = 1;
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons
                                                    .account_balance_wallet, color: selectedPaymentMethod != 1 ? Colors.grey : Colors.blue,),
                                                label: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Wallet\n',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          // Adjust the size for 'Paystack'
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black, // You might want to use your text color here
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Pay from your In-App Wallet',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          // Adjust the size for the smaller text
                                                          color: Colors
                                                              .black, // You might want to use your text color here
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: selectedPaymentMethod ==
                                                          1
                                                          ? Colors.blue
                                                          : Colors.grey),
                                                ),
                                              ),
                                            ),
                                            horizontalSpaceSmall,
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  if (selectedPaymentMethod !=
                                                      2) {
                                                    setStateModal(() {
                                                      selectedPaymentMethod = 2;
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.credit_card, color: selectedPaymentMethod != 2 ? Colors.grey : Colors.blue,),
                                                label: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Paystack\n',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          // Adjust the size for 'Paystack'
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black, // You might want to use your text color here
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Pay with Card, Bank transfer & ...',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          // Adjust the size for the smaller text
                                                          color: Colors
                                                              .black, // You might want to use your text color here
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: selectedPaymentMethod ==
                                                          2
                                                          ? Colors.blue
                                                          : Colors.grey),
                                                ),
                                              ),
                                            )
                                            ,
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {

                                                chargeCard(order, selectedPaymentMethod == 2 ? 'paystack' : 'wallet', plugin, setStateModal);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kcSecondaryColor, disabledForegroundColor: kcSecondaryColor
                                                    .withOpacity(
                                                    0.5).withOpacity(0.38), disabledBackgroundColor: kcSecondaryColor
                                                    .withOpacity(
                                                    0.5).withOpacity(0.12), // Color when button is disabled
                                              ),
                                              child: loadingPayment
                                                  ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ) : const Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.shopping_bag_outlined, color: Colors.black),
                                                              Text("Proceed with Payment")
                                                            ],
                                                          ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text("Make Payment"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: kcPrimaryColor, backgroundColor: kcWhiteColor, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                if (order.tracking!.status! == 5 && (order.reviewStatus == null || order.reviewStatus == false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                double ratingValue = 0.0; // Variable to hold current rating
                                TextEditingController commentController = TextEditingController(); // Controller for comment text field

                                return AlertDialog(

                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Card(
                                            margin: const EdgeInsets.all(8),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
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
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${order.product?.productName}",
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                        verticalSpaceTiny,
                                                        Text("Quantity: ${order.quantity}",
                                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                        ),
                                                        verticalSpaceTiny,
                                                        Text("Order ID: ${order.tracking?.trackingNumber}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                                        const SizedBox(height: 4),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),)
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "Rate Product",
                                          style: TextStyle(  fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Panchang"),
                                        ),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: kcSecondaryColor,
                                            size: 11,
                                          ),
                                          onRatingUpdate: (rating) {
                                            ratingValue = rating;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: commentController,

                                          decoration: const InputDecoration(
                                            hintText: "Add a Comment (Optional)",
                                            hintStyle: TextStyle(fontSize: 13),
                                            border: OutlineInputBorder(),
                                          ),
                                          minLines: 3,
                                          maxLines: 5,
                                        ),
                                        const SizedBox(height: 20),
                                  Row(children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (!loadingReview) {
                                            setState(() {
                                              loadingReview = true;
                                            });
                                            try {
                                              ApiResponse res = await locator<Repository>()
                                                  .reviewOrder({
                                                "orderId": order.id,
                                                "comment": commentController.text,
                                                "rating": ratingValue.toInt()
                                              });
                                              if (res.statusCode == 200) {
                                                locator<SnackbarService>()
                                                    .showSnackbar(message: res.data["message"]);
                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              locator<SnackbarService>()
                                                  .showSnackbar(message: e.toString());
                                            } finally {
                                              setState(() {
                                                loadingReview = false;
                                              });
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kcSecondaryColor,
                                          disabledForegroundColor: kcSecondaryColor.withOpacity(0.5).withOpacity(0.38),
                                          disabledBackgroundColor: kcSecondaryColor.withOpacity(0.5).withOpacity(0.12), // Color when button is disabled
                                        ),
                                        child: loadingReview
                                            ? const SizedBox(
                                          height: 20, // Set a specific height for the loader
                                          width: 20, // Set a specific width for the loader
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2, // Set the stroke width of the loader
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                            : const Text("Submit Review"),
                                      ),
                                    ),
                                  ]),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.rate_review_outlined, size: 16, color: kcSecondaryColor),
                          label: const Text("Review Product"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: kcPrimaryColor, backgroundColor: kcWhiteColor, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),

              ],
            ),
          ),
        );
      },
    );
  }


}

