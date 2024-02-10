import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/order_info.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/utils/money_util.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app.dialogs.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../utils/cart_utill.dart';
import '../../common/ui_helpers.dart';
import 'add_shipping.dart';
import 'custom_reciept.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  bool loadingProfile = true;
  PaymentMethod paymentMethod = PaymentMethod.payStack;
  String shippingId = "";
  bool makingDefault = false;
  // String publicKeyTest = MoneyUtils().payStackPublicKey;
  List<RaffleTicket> raffle = [];
  // final plugin = PaystackPlugin();
  bool isPaying = false;
  late final WebViewController controller;


  @override
  void initState() {
    // plugin.initialize(publicKey: publicKeyTest);
    getProfile();
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
      body: isPaying
          ? const Center(
            child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                "Order review",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${getTotalShopItems(shopCart.value)} items in cart"),
              children: List.generate(shopCart.value.length, (index) {
                CartItem item = shopCart.value[index];

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
                                        item.product!.pictures![0].location ?? ''),
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
                                MoneyUtils().formatAmount(item.product!.productPrice!),
                                style: TextStyle(
                                  color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
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
              initiallyExpanded: true,
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
                      MoneyUtils().formatAmount(getShopSubTotal(shopCart.value)),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold,
                        fontFamily: "satoshi"),
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
                      getDeliveryFee(shopCart.value) == 0 ? "Free" : "N${getDeliveryFee(shopCart.value)}",
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
                      MoneyUtils().formatAmount(getShopSubTotal(shopCart.value) + getDeliveryFee(shopCart.value)),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold,  fontFamily: "satoshi"),
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
              initiallyExpanded: true,
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              title: const Text(
                "Shipping details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                loadingProfile == true ? const CircularProgressIndicator() :
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
                              Shipping shipping = profile.value.shipping![index];
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
                                    Expanded(child:Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(shipping.shippingAddress ?? "", overflow: TextOverflow
                                            .ellipsis,
                                          maxLines: 3,),
                                        Text(shipping.shippingCity ?? ""),
                                        Text(shipping.shippingState ?? "")
                                      ],
                                    ) ),
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
          // verticalSpaceMedium,
          // Card(
          //   child: ExpansionTile(
          //     initiallyExpanded: true,
          //     childrenPadding:
          //         const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          //     title: const Text(
          //       "Payment method",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     children: [
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             paymentMethod = PaymentMethod.payStack;
          //           });
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10),
          //           height: 50,
          //           decoration: BoxDecoration(
          //               border: Border.all(color: kcBlackColor, width: 0.5)),
          //           child: Row(
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
          //                 child: paymentMethod == "paystack"
          //                     ? const Center(
          //                         child: Icon(
          //                           Icons.check,
          //                           size: 12,
          //                         ),
          //                       )
          //                     : const SizedBox(),
          //               ),
          //               horizontalSpaceSmall,
          //               const Text(
          //                 "Paystack",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               horizontalSpaceSmall,
          //               const Expanded(
          //                 child: Text(
          //                   "You will be redirected to the Paystack website after submitting your order",
          //                   style: TextStyle(fontSize: 11),
          //                 ),
          //               ),
          //               horizontalSpaceSmall,
          //               // Image.asset("assets/images/paypal.png")
          //             ],
          //           ),
          //         ),
          //       ),
          //       verticalSpaceSmall,
          //       // InkWell(
          //       //   onTap: () {
          //       //     setState(() {
          //       //       paymentMethod = "card";
          //       //     });
          //       //   },
          //       //   child: Container(
          //       //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //       //     height: 250,
          //       //     decoration: BoxDecoration(
          //       //         border: Border.all(color: kcBlackColor, width: 0.5)),
          //       //     child: Column(
          //       //       children: [
          //       //         verticalSpaceSmall,
          //       //         Row(
          //       //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       //           children: [
          //       //             Row(
          //       //               children: [
          //       //                 Container(
          //       //                   height: 15,
          //       //                   width: 15,
          //       //                   decoration: BoxDecoration(
          //       //                       shape: BoxShape.circle,
          //       //                       border: Border.all(
          //       //                         color: kcBlackColor,
          //       //                         width: 1,
          //       //                       )),
          //       //                   child: paymentMethod == "card"
          //       //                       ? const Center(
          //       //                     child: Icon(
          //       //                       Icons.check,
          //       //                       size: 12,
          //       //                     ),
          //       //                   )
          //       //                       : const SizedBox(),
          //       //                 ),
          //       //                 horizontalSpaceSmall,
          //       //                 const Text(
          //       //                   "Pay with Credit Card",
          //       //                   style: TextStyle(
          //       //                     fontWeight: FontWeight.bold,
          //       //                   ),
          //       //                 ),
          //       //               ],
          //       //             ),
          //       //             Row(
          //       //               children: [
          //       //                 Image.asset("assets/images/visa.png"),
          //       //                 verticalSpaceTiny,
          //       //                 Image.asset("assets/images/discover.png"),
          //       //                 verticalSpaceTiny,
          //       //                 Image.asset("assets/images/maestro.png"),
          //       //                 verticalSpaceTiny,
          //       //                 Image.asset("assets/images/master_card.png"),
          //       //               ],
          //       //             )
          //       //           ],
          //       //         ),
          //       //         verticalSpaceMedium,
          //       //         Row(
          //       //           children: [
          //       //             Expanded(
          //       //               flex: 3,
          //       //               child: TextFieldWidget(
          //       //                 hint: "Card number",
          //       //                 controller: cardNumberController,
          //       //               ),
          //       //             ),
          //       //             horizontalSpaceSmall,
          //       //             Expanded(
          //       //               flex: 2,
          //       //               child: TextFieldWidget(
          //       //                 hint: "Expiry",
          //       //                 controller: cardExpiryController,
          //       //               ),
          //       //             ),
          //       //           ],
          //       //         ),
          //       //         verticalSpaceMedium,
          //       //         Row(
          //       //           children: [
          //       //             Expanded(
          //       //               flex: 3,
          //       //               child: TextFieldWidget(
          //       //                 hint: "Card Security Code",
          //       //                 controller: cardCvcController,
          //       //               ),
          //       //             ),
          //       //             horizontalSpaceSmall,
          //       //             const Expanded(
          //       //               flex: 2,
          //       //               child: Text(
          //       //                 "What is this?",
          //       //                 style: TextStyle(color: Colors.blue),
          //       //               ),
          //       //             ),
          //       //           ],
          //       //         ),
          //       //       ],
          //       //     ),
          //       //   ),
          //       // ),
          //       verticalSpaceSmall,
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             paymentMethod = PaymentMethod.wallet;
          //           });
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10),
          //           height: 50,
          //           decoration: BoxDecoration(
          //               border: Border.all(color: kcBlackColor, width: 0.5)),
          //           child: Row(
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
          //                 child: paymentMethod == "wallet"
          //                     ? const Center(
          //                         child: Icon(
          //                           Icons.check,
          //                           size: 12,
          //                         ),
          //                       )
          //                     : const SizedBox(),
          //               ),
          //               horizontalSpaceSmall,
          //               const Text(
          //                 "Wallet",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               horizontalSpaceSmall,
          //               const Expanded(
          //                 child: Text(
          //                   "Make payment from your in-app wallet",
          //                   style: TextStyle(fontSize: 11),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       verticalSpaceSmall,
          //       InkWell(
          //         onTap: () {
          //           setState(() {
          //             paymentMethod = PaymentMethod.binancePay;
          //           });
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10),
          //           height: 50,
          //           decoration: BoxDecoration(
          //               border: Border.all(color: kcBlackColor, width: 0.5)),
          //           child: Row(
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
          //                 child: paymentMethod == PaymentMethod.binancePay
          //                     ? const Center(
          //                   child: Icon(
          //                     Icons.check,
          //                     size: 12,
          //                   ),
          //                 )
          //                     : const SizedBox(),
          //               ),
          //               horizontalSpaceSmall,
          //               const Text(
          //                 "Binance Pay",
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               horizontalSpaceSmall,
          //               const Expanded(
          //                 child: Text(
          //                   "Make payment from your binance wallet",
          //                   style: TextStyle(fontSize: 11),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       verticalSpaceSmall,
          //       const Row(
          //         children: [
          //           Icon(
          //             Icons.lock,
          //             color: kcSecondaryColor,
          //           ),
          //           horizontalSpaceSmall,
          //           Expanded(
          //             child: Text(
          //               "We protect your payment information using encryption to provide bank-level security.",
          //               style: TextStyle(fontSize: 11),
          //             ),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          verticalSpaceLarge,
          SubmitButton(
            isLoading: loading,
            label: "Pay ${MoneyUtils().formatAmountToDollars(getShopSubTotal(shopCart.value) + getDeliveryFee(shopCart.value))}",
            submit: () async {
              setState(() {
                loading = true;
              });
              try {
                chargeCard();

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

  Future<void> getProfile() async {
    ApiResponse res = await locator<Repository>().getProfile();
    setState(() {
      loadingProfile = false;
      if (res.statusCode == 200) {
        Map<String, dynamic> userData = res.data["user"] as Map<String, dynamic>;
        profile.value = Profile.fromJson(userData);
      } else {
        locator<SnackbarService>().showSnackbar(message: res.data["message"]);
      }
    });
  }

  chargeCard() async {
    setState(() {
      isPaying = true;
    });

    // Calculate the amount
    int amount = getShopSubTotal(shopCart.value) + getDeliveryFee(shopCart.value);
    // Retrieve order IDs
    List<String> orderIds = widget.infoList.map((e) => e.id.toString()).toList();

    ApiResponse res = await MoneyUtils().chargeCardUtil(PaymentMethod.wallet, orderIds, context, amount);

    if (res.statusCode == 200) {
      if (paymentMethod == 'binance') {
        // var binanceData = res.data["binance"]["data"];
        Map<String, dynamic> binanceData = res.data['binance']['data'];
        _showBinanceModal(binanceData, orderIds);
        // _showBinanceWebViewModal(binanceData);
      } else {
        // Handle other payment methods
        getRaffles();
        showReceipt();
      }
    } else {
      Navigator.pop(context);
      locator<SnackbarService>().showSnackbar(message: res.data["message"]);
    }

    setState(() {
      isPaying = false;
    });
  }

  // void _showBinanceModal(Map binanceData) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
  //     ),
  //     // barrierColor: Colors.black.withAlpha(50),
  //     // backgroundColor: Colors.transparent,
  //     backgroundColor: Colors.white,
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.8, // 70% of the screen's height
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Image.asset("assets/images/binance.png",scale: 4),
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Image.network(
  //                   binanceData["qrcodeLink"],
  //                   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  //                     if (loadingProgress == null) return child;
  //                     return Center(
  //                       child: CircularProgressIndicator(
  //                         value: loadingProgress.expectedTotalBytes != null
  //                             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
  //                             : null,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               InkWell(
  //                 onTap: () {
  //                   _openBinanceApp(binanceData);
  //                 },
  //                 child: const Text('Open App >', style: TextStyle(color: kcSecondaryColor, fontWeight: FontWeight.bold),)
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  void _showBinanceModal(Map binanceData, List<String> orderIds) {
    bool isModalOpen = true;
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {

        void pollPaymentStatus() async {
          if (!isModalOpen) {
            // Modal is closed, stop cron
            return;
          }

          setState(() {
            isLoading = true;
          });
          bool paymentSuccessful = await checkPaymentStatus(orderIds);

          if (paymentSuccessful) {
            Navigator.pop(context);
            setState(() {
              showReceipt();
            });



          } else {
            // Payment not successful, continue polling
            Future.delayed(const Duration(seconds: 10), pollPaymentStatus);
          }
        }


        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/images/binance.png", scale: 4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    binanceData["qrcodeLink"],
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                if (!isLoading)
                  InkWell(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      _openBinanceApp(binanceData);
                      // Start the initial polling
                      pollPaymentStatus();
                    },
                    child: const Text('Open App >', style: TextStyle(color: kcSecondaryColor, fontWeight: FontWeight.bold)),
                  ),

                if (isLoading) const CircularProgressIndicator(color: kcSecondaryColor,),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      isModalOpen = false;
    });
  }


  // void _showBinanceWebViewModal(Map binanceData) {
  //   controller = WebViewController()..loadRequest(Uri.parse(binanceData["checkoutUrl"],));
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.8, // 80% of the screen's height
  //         child: WebViewWidget(controller: controller)
  //       );
  //     },
  //   );
  // }

  void _launchURL(String url) async {

    final Uri uri = Uri.parse(url);
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : locator<SnackbarService>().showSnackbar(message: "No app found, please install binance app to continue ${url}");

  }

  _openBinanceApp(Map binanceData) async {

    String deeplink = binanceData["deeplink"];
    final Uri toLaunch = Uri.parse(deeplink);

    if (!await launchUrl(toLaunch, mode: LaunchMode.platformDefault)) {
      // Show the popup if the app launch fails
      // final bool? result = await showDialog<bool>(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text('Binance App not installed?'),
      //       content: Text('Would you like to continue the payment in your web browser?'),
      //       actions: <Widget>[
      //         TextButton(
      //           child: Text('No'),
      //           onPressed: () => Navigator.of(context).pop(false), // User chose not to continue
      //         ),
      //         TextButton(
      //           child: Text('Yes'),
      //           onPressed: () => Navigator.of(context).pop(true), // User chose to continue
      //         ),
      //       ],
      //     );
      //   },
      // );

      // If the user chose to continue, launch the checkout URL
      // if (result == true) {
      //   if (!await launchUrl(Uri.parse(binanceData["checkoutUrl"]))) {
      //     // Handle the error if the URL launch fails
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Could not open the web browser')),
      //     );
      //   }
      // }

      final res = await locator<DialogService>().showCustomDialog(
          variant: DialogType.infoAlert,
          title: "Binance App not installed",
          description: "Continue on browser?");
      if (res!.confirmed) {
        if (!await launchUrl(Uri.parse(binanceData["checkoutUrl"]))) {
          // Handle the error if the URL launch fails
          locator<SnackbarService>().showSnackbar(message: 'Could not open the web browser');
        }
      }

    }
  }





  void showReceipt() {


    List<CartItem> receiptCart = List<CartItem>.from(raffleCart.value);

    raffleCart.value.clear();
    raffleCart.notifyListeners();
    List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
    locator<LocalStorage>().save(LocalStorageDir.cart, storedList);


    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return ReceiptPage(cart:receiptCart);
      },
    );
  }

  Future<void> getRaffles() async {
    try {
      ApiResponse res = await repo.raffleList();
      if (res.statusCode == 200) {
        var raffleData = (res.data["participant"] as List)
            .map((e) => RaffleTicket.fromJson(Map<String, dynamic>.from(e['raffledraw'])))
            .toList();

        setState(() {
          raffle = raffleData;
          // loading = false; // Now we set loading to false after we get data
        });
      } else {
        setState(() {
          // loading = false;
        });
      }
    } catch (e) {
      setState(() {
        // loading = false;
      });
    }
  }

  checkPaymentStatus(List<String> orderIds) async {
    print('order ids are${orderIds}');
    try {
      print('ordeer id is: ${orderIds.length}');
      var payload = {
        "orderId": [...orderIds],
        "id": profile.value.id,
      };
      ApiResponse res = await locator<Repository>()
          .getOrdersStatus(payload);
      if (res.statusCode == 200) {
        return true;
      }else{
        // locator<SnackbarService>()
        //     .showSnackbar(message: res.data["message"]);
        // Navigator.pop(context);
        return false;

      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // showSuccess() {
  //   cart.value.clear();
  //   cart.notifyListeners();
  //   List<Map<String, dynamic>> storedList = cart.value.map((e) => e.toJson()).toList();
  //   locator<LocalStorage>().save(LocalStorageDir.cart, storedList);
  //
  //   Navigator.pop(context);
  //   return Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PaymentSuccessPage(
  //         title: "Order Completed Successfully!",
  //         animation: 'payment_success.json',
  //         callback: () {
  //           locator<NavigationService>().clearStackAndShow(Routes.dashboardView);
  //         },
  //       ),
  //     ),
  //   );
  //  }
}
