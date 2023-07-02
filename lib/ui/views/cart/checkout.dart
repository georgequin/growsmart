import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/order_info.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/profile/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';
import '../../common/ui_helpers.dart';
import '../../components/text_field_widget.dart';

class Checkout extends StatefulWidget {
  final List<OrderInfo> infoList;

  const Checkout({
    required this.infoList,
    Key? key,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool loading = false;
  final address = TextEditingController();
  String? state;
  final city = TextEditingController();
  final phone = TextEditingController();
  final zipCode = TextEditingController();
  String paymentMethod = "wallet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Checkout",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ExpansionTile(
              title: const Text(
                "Order review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${getTotalItems()} items in cart"),
              children: List.generate(cart.value.length, (index) {
                CartItem item = cart.value[index];

                return GestureDetector(
                  onTap: () {
                    // viewModel.addRemoveDelete(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.light
                          ? kcWhiteColor
                          : kcBlackColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFFE5E5E5).withOpacity(0.4),
                            offset: const Offset(8.8, 8.8),
                            blurRadius: 8.8)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: item.product!.pictures!.isEmpty
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(item
                                            .product!.pictures![0].location!),
                                      ),
                              ),
                            ),
                            horizontalSpaceMedium,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.product!.productName ?? ""),
                                Text(item.product!.productName ?? ""),
                                verticalSpaceTiny,
                                Text(
                                  "N${item.product!.productPrice}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // viewModel.itemsToDelete.contains(index)
                            //     ? Container(
                            //         height: 20,
                            //         width: 20,
                            //         decoration: const BoxDecoration(
                            //           color: kcSecondaryColor,
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: const Center(
                            //           child: Icon(
                            //             Icons.check,
                            //             color: kcWhiteColor,
                            //             size: 16,
                            //           ),
                            //         ),
                            //       )
                            //     :
                            // Container(
                            //   height: 20,
                            //   width: 20,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     border: Border.all(color: kcLightGrey),
                            //   ),
                            // ),
                            // Row(
                            //   children: [
                            //     Container(
                            //       height: 20,
                            //       width: 20,
                            //       decoration: BoxDecoration(
                            //           border:
                            //               Border.all(color: kcLightGrey),
                            //           borderRadius:
                            //               BorderRadius.circular(5)),
                            //       child: const Center(
                            //         child: Icon(
                            //           Icons.remove,
                            //           size: 18,
                            //         ),
                            //       ),
                            //     ),
                            //     horizontalSpaceSmall,
                            //     const Text("2"),
                            //     horizontalSpaceSmall,
                            //     Container(
                            //       height: 20,
                            //       width: 20,
                            //       decoration: BoxDecoration(
                            //           border:
                            //               Border.all(color: kcLightGrey),
                            //           borderRadius:
                            //               BorderRadius.circular(5)),
                            //       child: const Align(
                            //         alignment: Alignment.center,
                            //         child: Icon(
                            //           Icons.add,
                            //           size: 18,
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          verticalSpaceMedium,
          Card(
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: const Text(
                "Billing summary",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sub-total",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "N${getSubTotal()}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery-Fee",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "N0",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                const Divider(
                  thickness: 2,
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "N${getSubTotal()}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceMedium
              ],
            ),
          ),
          verticalSpaceMedium,
          Card(
            child: ExpansionTile(
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              title: const Text(
                "Shipping details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                TextFieldWidget(
                  hint: "Street Address",
                  controller: address,
                ),
                verticalSpaceMedium,
                DropdownWidget(
                  value: state,
                  itemsList: states,
                  hint: "State",
                  onChanged: (value) {
                    setState(() {
                      state = value;
                    });
                  },
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "City",
                  controller: city,
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Phone",
                  controller: phone,
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Zip Code",
                  controller: zipCode,
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Card(
            child: ExpansionTile(
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              title: const Text(
                "Payment method",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      paymentMethod = "paystack";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: kcBlackColor, width: 0.5)),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kcBlackColor,
                                width: 1,
                              )),
                          child: paymentMethod == "paystack"
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        horizontalSpaceSmall,
                        const Text(
                          "Paystack",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        horizontalSpaceSmall,
                        const Expanded(
                          child: Text(
                            "You will be redirected to the Paystack website after submitting your order",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        horizontalSpaceSmall,
                        // Image.asset("assets/images/paypal.png")
                      ],
                    ),
                  ),
                ),
                // verticalSpaceSmall,
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   height: 250,
                //   decoration: BoxDecoration(
                //       border: Border.all(color: kcBlackColor, width: 0.5)),
                //   child: Column(
                //     children: [
                //       verticalSpaceSmall,
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               Container(
                //                 height: 15,
                //                 width: 15,
                //                 decoration: BoxDecoration(
                //                     shape: BoxShape.circle,
                //                     border: Border.all(
                //                       color: kcBlackColor,
                //                       width: 1,
                //                     )),
                //               ),
                //               horizontalSpaceSmall,
                //               const Text(
                //                 "Pay with Credit Card",
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Row(
                //             children: [
                //               Image.asset("assets/images/visa.png"),
                //               verticalSpaceTiny,
                //               Image.asset("assets/images/discover.png"),
                //               verticalSpaceTiny,
                //               Image.asset("assets/images/maestro.png"),
                //               verticalSpaceTiny,
                //               Image.asset("assets/images/master_card.png"),
                //             ],
                //           )
                //         ],
                //       ),
                //       verticalSpaceMedium,
                //       Row(
                //         children: [
                //           Expanded(
                //             flex: 3,
                //             child: TextFieldWidget(
                //               hint: "Card number",
                //               controller: TextEditingController(),
                //             ),
                //           ),
                //           horizontalSpaceSmall,
                //           Expanded(
                //             flex: 2,
                //             child: TextFieldWidget(
                //               hint: "Expiry",
                //               controller: TextEditingController(),
                //             ),
                //           ),
                //         ],
                //       ),
                //       verticalSpaceMedium,
                //       Row(
                //         children: [
                //           Expanded(
                //             flex: 3,
                //             child: TextFieldWidget(
                //               hint: "Card Security Code",
                //               controller: TextEditingController(),
                //             ),
                //           ),
                //           horizontalSpaceSmall,
                //           const Expanded(
                //             flex: 2,
                //             child: Text(
                //               "What is this?",
                //               style: TextStyle(color: Colors.blue),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                verticalSpaceSmall,
                InkWell(
                  onTap: () {
                    setState(() {
                      paymentMethod = "wallet";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: kcBlackColor, width: 0.5)),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kcBlackColor,
                                width: 1,
                              )),
                          child: paymentMethod == "wallet"
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        horizontalSpaceSmall,
                        const Text(
                          "Wallet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        horizontalSpaceSmall,
                        const Expanded(
                          child: Text(
                            "Make payment from your in-app wallet",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpaceSmall,
                const Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: kcSecondaryColor,
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: Text(
                        "We protect your payment information using encryption to provide bank-level security.",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          verticalSpaceMassive,
          SubmitButton(
            isLoading: loading,
            label: "Pay N${getSubTotal()}",
            submit: () async {
              setState(() {
                loading = true;
              });
              try {
                ApiResponse res = await locator<Repository>().payForOrder({
                  "orderId": widget.infoList.map((e) => e.id).toList(),
                  "payment_method": paymentMethod == "wallet" ? 1 : 2
                });
                if (res.statusCode == 200) {
                  cart.value.clear();
                  cart.notifyListeners();
                  if ((res.data["paystack"] != null) &&
                      (res.data["paystack"] as Map).isNotEmpty) {
                    String? url =
                        res.data["paystack"]?["data"]["authorization_url"];
                    final result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) {
                      return PaymentView(
                        url: url ?? "",
                        isPayForOrder: true,
                      );
                    }));
                    if (result) {
                      List<Map<String, dynamic>> receipts = [];
                      int totalAmount = 0;
                      for (var element in (res.data["receipt"] as List)) {
                        if (element != null) {
                          receipts.add(Map<String, dynamic>.from(element));
                          totalAmount = totalAmount +
                              int.parse(element["amount"].toString());
                        }
                      }
                      locator<NavigationService>().navigateTo(Routes.receipt,
                          arguments: ReceiptArguments(
                              totalAmount: totalAmount,
                              info: Map<String, dynamic>.from(receipts[0])));
                    }
                  } else {
                    if ((res.data["receipt"] as List).isEmpty) {
                      locator<NavigationService>().back();
                      locator<SnackbarService>()
                          .showSnackbar(message: "Order Placed Successfully");
                      return;
                    }
                    List<Map<String, dynamic>> receipts = [];
                    int totalAmount = 0;
                    for (var element in (res.data["receipt"] as List)) {
                      if (element != null) {
                        receipts.add(Map<String, dynamic>.from(element));
                        totalAmount = totalAmount +
                            int.parse(element['amount'].toString());
                      }
                    }
                    locator<NavigationService>().navigateTo(Routes.receipt,
                        arguments: ReceiptArguments(
                            totalAmount: totalAmount,
                            info: Map<String, dynamic>.from(receipts[0])));
                  }
                } else {
                  locator<SnackbarService>()
                      .showSnackbar(message: res.data["message"]);
                }
              } catch (e) {
                print(e);
              }

              setState(() {
                loading = false;
              });
            },
            color: kcPrimaryColor,
            boldText: true,
            icon: Icons.credit_card,
            iconColor: Colors.blue,
            iconIsPrefix: true,
          )
        ],
      ),
    );
  }

  int getTotalItems() {
    int quantity = 0;
    for (var element in cart.value) {
      quantity = quantity + element.quantity!;
    }

    return quantity;
  }

  int getSubTotal() {
    int total = 0;

    for (var element in cart.value) {
      total = total + (element.product!.productPrice! * element.quantity!);
    }

    return total;
  }
}

List<String> states = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "FCT - Abuja",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara"
];
