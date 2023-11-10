
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/order_info.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/profile/payment_view.dart';
import 'package:afriprize/utils/moneyUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../common/ui_helpers.dart';
import '../../components/text_field_widget.dart';
import 'add_shipping.dart';
import 'custom_reciept.dart';

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
  String paymentMethod = "paystack";
  String shippingId = "";
  bool makingDefault = false;
  String publicKeyTest = MoneyUtils().payStackPublicKey;
  final plugin = PaystackPlugin();


  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    super.initState();
  }

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
                    // height: 100,
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
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: item.product!.pictures!.isEmpty
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(
                                        item.product!.pictures![0].location!),
                                  ),
                          ),
                        ),
                        horizontalSpaceMedium,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.product!.productName ?? ""),
                              verticalSpaceTiny,
                              Text(
                                "N${item.product!.productPrice}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Delivery-Fee",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "N${getDeliveryFee()}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
                      "N${getSubTotal() + getDeliveryFee()}",
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
                (profile.value.shipping == null ||
                        profile.value.shipping!.isEmpty)
                    ? Column(
                        children: [
                          const Text("No Shipping address found"),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kcPrimaryColor)),
                            child: const Text(
                              "Add new shipping address",
                              style: TextStyle(color: kcWhiteColor),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => const AddShipping(),
                                    ),
                                  )
                                  .whenComplete(() => setState(() {}));
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ...List.generate(
                            profile.value.shipping!.length,
                            (index) {
                              Shipping shipping =
                                  profile.value.shipping![index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kcBlackColor, width: 0.5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(shipping.shippingAddress ?? ""),
                                        Text(shipping.shippingCity ?? ""),
                                        Text(shipping.shippingState ?? "")
                                      ],
                                    ),
                                    (shipping.isDefault ?? false)
                                        ? const Text("Default")
                                        : (shippingId == shipping.id &&
                                                makingDefault)
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                                kcPrimaryColor)),
                                                onPressed: () async {
                                                  setState(() {
                                                    shippingId = shipping.id!;
                                                    makingDefault = true;
                                                  });

                                                  try {
                                                    ApiResponse res =
                                                        await locator<
                                                                Repository>()
                                                            .setDefaultShipping(
                                                                {},
                                                                shipping.id!);
                                                    if (res.statusCode == 200) {
                                                      ApiResponse pRes =
                                                          await locator<
                                                                  Repository>()
                                                              .getProfile();
                                                      if (pRes.statusCode ==
                                                          200) {
                                                        profile.value = Profile
                                                            .fromJson(Map<
                                                                    String,
                                                                    dynamic>.from(
                                                                pRes.data[
                                                                    "user"]));

                                                        profile
                                                            .notifyListeners();
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(e);
                                                  }

                                                  setState(() {
                                                    shippingId = "";
                                                    makingDefault = false;
                                                  });
                                                },
                                                child: const Text(
                                                  "Make default",
                                                  style: TextStyle(
                                                      color: kcWhiteColor),
                                                ),
                                              )
                                  ],
                                ),
                              );
                            },
                          ),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kcPrimaryColor)),
                            child: const Text(
                              "Add new shipping address",
                              style: TextStyle(color: kcWhiteColor),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => const AddShipping(),
                                    ),
                                  )
                                  .whenComplete(() => setState(() {}));
                            },
                          ),
                        ],
                      )
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
                verticalSpaceSmall,
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       paymentMethod = "card";
                //     });
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     height: 250,
                //     decoration: BoxDecoration(
                //         border: Border.all(color: kcBlackColor, width: 0.5)),
                //     child: Column(
                //       children: [
                //         verticalSpaceSmall,
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Row(
                //               children: [
                //                 Container(
                //                   height: 15,
                //                   width: 15,
                //                   decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       border: Border.all(
                //                         color: kcBlackColor,
                //                         width: 1,
                //                       )),
                //                   child: paymentMethod == "card"
                //                       ? const Center(
                //                     child: Icon(
                //                       Icons.check,
                //                       size: 12,
                //                     ),
                //                   )
                //                       : const SizedBox(),
                //                 ),
                //                 horizontalSpaceSmall,
                //                 const Text(
                //                   "Pay with Credit Card",
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Row(
                //               children: [
                //                 Image.asset("assets/images/visa.png"),
                //                 verticalSpaceTiny,
                //                 Image.asset("assets/images/discover.png"),
                //                 verticalSpaceTiny,
                //                 Image.asset("assets/images/maestro.png"),
                //                 verticalSpaceTiny,
                //                 Image.asset("assets/images/master_card.png"),
                //               ],
                //             )
                //           ],
                //         ),
                //         verticalSpaceMedium,
                //         Row(
                //           children: [
                //             Expanded(
                //               flex: 3,
                //               child: TextFieldWidget(
                //                 hint: "Card number",
                //                 controller: cardNumberController,
                //               ),
                //             ),
                //             horizontalSpaceSmall,
                //             Expanded(
                //               flex: 2,
                //               child: TextFieldWidget(
                //                 hint: "Expiry",
                //                 controller: cardExpiryController,
                //               ),
                //             ),
                //           ],
                //         ),
                //         verticalSpaceMedium,
                //         Row(
                //           children: [
                //             Expanded(
                //               flex: 3,
                //               child: TextFieldWidget(
                //                 hint: "Card Security Code",
                //                 controller: cardCvcController,
                //               ),
                //             ),
                //             horizontalSpaceSmall,
                //             const Expanded(
                //               flex: 2,
                //               child: Text(
                //                 "What is this?",
                //                 style: TextStyle(color: Colors.blue),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
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
                Row(
                  children: const [
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
            label: "Pay N${getSubTotal() + getDeliveryFee()}",
            submit: () async {
              setState(() {
                loading = true;
              });
              try {


                chargeCard(getSubTotal() + getDeliveryFee());



                // ApiResponse res = await locator<Repository>().payForOrder({
                //   "orderId": widget.infoList.map((e) => e.id).toList(),
                //   "payment_method": paymentMethod == "card" ? 2 : 1,
                //   "Reference":
                // });
                // if (res.statusCode == 200) {
                //   cart.value.clear();
                //   cart.notifyListeners();
                //   //update local cart
                //   List<Map<String, dynamic>> storedList =
                //       cart.value.map((e) => e.toJson()).toList();
                //   await locator<LocalStorage>()
                //       .save(LocalStorageDir.cart, storedList);
                //
                //   if ((res.data["paystack"] != null) &&
                //       (res.data["paystack"] as Map).isNotEmpty) {
                //     String? url =
                //         res.data["paystack"]?["data"]["authorization_url"];
                //     final result = await Navigator.of(context)
                //         .push(MaterialPageRoute(builder: (c) {
                //       return PaymentView(
                //         url: url ?? "",
                //         isPayForOrder: true,
                //       );
                //     }));
                //     if (result) {
                //       List<Map<String, dynamic>> receipts = [];
                //       int totalAmount = 0;
                //       for (var element in (res.data["receipt"] as List)) {
                //         if (element != null) {
                //           receipts.add(Map<String, dynamic>.from(element));
                //           totalAmount = totalAmount +
                //               int.parse(element["transaction"][0]["amount"]
                //                   .toString());
                //         }
                //       }
                //       locator<NavigationService>().navigateTo(Routes.receipt,
                //           arguments: ReceiptArguments(
                //               totalAmount: totalAmount,
                //               info: Map<String, dynamic>.from(receipts[0])));
                //     }
                //   } else {
                //     if ((res.data["receipt"] as List).isEmpty) {
                //       locator<NavigationService>().back();
                //       locator<SnackbarService>()
                //           .showSnackbar(message: "Order Placed Successfully");
                //       return;
                //     }
                //     List<Map<String, dynamic>> receipts = [];
                //     int totalAmount = 0;
                //     for (var element in (res.data["receipt"] as List)) {
                //       if (element != null) {
                //         receipts.add(Map<String, dynamic>.from(element));
                //         totalAmount = totalAmount +
                //             int.parse(
                //                 element["transaction"][0]['amount'].toString());
                //       }
                //     }
                //     locator<NavigationService>().navigateTo(Routes.receipt,
                //         arguments: ReceiptArguments(
                //             totalAmount: totalAmount,
                //             info: Map<String, dynamic>.from(receipts[0])));
                //   }
                // } else {
                //   locator<SnackbarService>()
                //       .showSnackbar(message: res.data["message"]);
                // }
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

  int getDeliveryFee() {
    int total = 0;

    for (var element in cart.value) {
      total = total + (element.product!.shippingFee!);
    }

    return total;
  }




  chargeCard( int amount) async {
    if(paymentMethod == 'wallet'){
      print('payment is from wallet');
      ApiResponse res = await locator<Repository>().payForOrder({
        "orderId": widget.infoList.map((e) => e.id).toList(),
        "payment_method": 1,
        "reference": MoneyUtils().getReference(),
        "id": profile.value.id
      });

      if (res.statusCode == 200) {
        cart.value.clear();
        cart.notifyListeners();
        //update local cart
        List<Map<String, dynamic>> storedList =
        cart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>()
            .save(LocalStorageDir.cart, storedList);
        showReceipt('wallet', amount);
      }else{
        locator<SnackbarService>()
            .showSnackbar(message: res.data["message"]);
      }
      }
    else if(paymentMethod == 'paystack'){
      var charge = Charge()
        ..amount = (getSubTotal() + getDeliveryFee()) *
            100 //the money should be in kobo hence the need to multiply the value by 100
        ..reference = MoneyUtils().getReference()
        ..email = profile.value.email;
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      if (response.status == true) {
        print('paystack payment successful');
        ApiResponse res = await locator<Repository>().payForOrder({
          "orderId": widget.infoList.map((e) => e.id).toList(),
          "payment_method": 2,
          "reference": charge.reference,
          "id": profile.value.id
        });

        if (res.statusCode == 200) {
          cart.value.clear();
          cart.notifyListeners();
          //update local cart
          List<Map<String, dynamic>> storedList =
          cart.value.map((e) => e.toJson()).toList();
          await locator<LocalStorage>()
              .save(LocalStorageDir.cart, storedList);

          if ((res.data["receipt"] as List).isEmpty) {
            print('list is empty, no receipt');
            showReceipt('paystack', amount);
            locator<SnackbarService>()
                .showSnackbar(message: "Order Placed Successfully");
            return;
          }
          print('list is not empty, see receipt');
          List<Map<String, dynamic>> receipts = [];
          int totalAmount = 0;
          for (var element in (res.data["receipt"] as List)) {
            if (element != null && element["transaction"] is List && element["transaction"].isNotEmpty) {
              var transactions = element["transaction"] as List;
              if (transactions.isNotEmpty && transactions[0] != null) {
                var transactionAmount = transactions[0]['amount'];
                if (transactionAmount != null) {
                  receipts.add(Map<String, dynamic>.from(element));
                  totalAmount += int.parse(transactionAmount.toString());
                }
              }
            }
          }
          if (receipts.isNotEmpty) {
            showReceipt('paystack', amount);
            locator<NavigationService>().navigateTo(Routes.receipt,
              arguments: ReceiptArguments(
                totalAmount: totalAmount,
                info: Map<String, dynamic>.from(receipts[0]),
              ),
            );
          } else {
            print('no receipts found');
            showReceipt('paystack', amount);
            locator<SnackbarService>()
                .showSnackbar(message: "Order Placed Successfully");
            return;
          }
        } else {
          locator<SnackbarService>()
              .showSnackbar(message: res.data["message"]);
        }
      }
    }


  }

  void showReceipt(String paymentMethod, int amount) {
    print(getSubTotal());
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ReceiptWidget(
          amount: amount,
          drawTicketNumber: '',
          paymentMethod: paymentMethod,
          senderName: profile.value.firstname!,
          paymentTime: DateTime.now(),
        );
      },
    );
  }
}
