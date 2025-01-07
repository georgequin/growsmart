import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/order_info.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/data/models/cart_item.dart';
import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../utils/money_util.dart';
import '../../common/ui_helpers.dart';
import '../../components/text_field_widget.dart';
import 'add_shipping.dart';


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
  bool isShippingLoading = false;
  String paymentMethod = "paystack";
  String shippingId = "";
  bool makingDefault = false;
  String publicKeyTest = MoneyUtils().payStackPublicKey;
  List<Address> shippingAddresses = [];

  final plugin = PaystackPlugin();

  bool isPaying = false;
  final TextEditingController houseAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    getShippings();
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
          ? CircularProgressIndicator() // Show loader when updating
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
                            image: (item.product?.images?.isNotEmpty == true && item.product!.images![0].isNotEmpty)
                                ? DecorationImage(
                              image: NetworkImage(item.product!.images![0]),
                              fit: BoxFit.cover, // Optional: Adjust the image fit
                            )
                                : null,
                          )

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
                                "N${item.product!.price}",
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
                      MoneyUtils().formatAmount(getSubTotal()),
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
                      getDeliveryFee() == 0 ? "Free" : "N${getDeliveryFee()}",
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
                      MoneyUtils().formatAmount(
                          getSubTotal() + getDeliveryFee()),
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
              initiallyExpanded: true,
              title: const Text(
                "Shipping details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                isShippingLoading == true ? const CircularProgressIndicator() :
                shippingAddresses.isEmpty
                    ? Column(
                  children: [
                    const Text("No Shipping address found"),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kcPrimaryColor),
                      ),
                      child: const Text(
                        "Add new shipping address",
                        style: TextStyle(color: kcWhiteColor),
                      ),
                      onPressed: showAddAddressBottomSheet,
                    ),
                  ],
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: shippingAddresses.length,
                  itemBuilder: (context, index) {
                    final address = shippingAddresses[index];
                    return ListTile(
                      title: Text("${address.address}, ${address.city}, ${address.state}"),
                      subtitle: Text("Phone: ${address.phoneNumber}"),
                      trailing: Radio<String>(
                        value: address.id,
                        groupValue: shippingId,
                        onChanged: (String? value) {
                          setState(() {
                            shippingId = value!;
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Card(
            child: ExpansionTile(
              initiallyExpanded: true,
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
                //       paymentMethod = "wallet";
                //     });
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     height: 50,
                //     decoration: BoxDecoration(
                //         border: Border.all(color: kcBlackColor, width: 0.5)),
                //     child: Row(
                //       children: [
                //         Container(
                //           height: 15,
                //           width: 15,
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               border: Border.all(
                //                 color: kcBlackColor,
                //                 width: 1,
                //               )),
                //           child: paymentMethod == "wallet"
                //               ? const Center(
                //             child: Icon(
                //               Icons.check,
                //               size: 12,
                //             ),
                //           )
                //               : const SizedBox(),
                //         ),
                //         horizontalSpaceSmall,
                //         const Text(
                //           "Wallet",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         horizontalSpaceSmall,
                //         const Expanded(
                //           child: Text(
                //             "Make payment from your in-app wallet",
                //             style: TextStyle(fontSize: 11),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // verticalSpaceSmall,
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
            label: "Pay ${MoneyUtils().formatAmount(getSubTotal() + getDeliveryFee())}",
            submit: () async {
              setState(() {
                loading = true;
              });
              try {
                chargeCard(getSubTotal() + getDeliveryFee());
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
      total = total +
          (double.parse(element.product?.price.toString() ?? '0').round() *
              element.quantity!);
    }

    return total;
  }

  int getDeliveryFee() {
    int total = 0;

    // for (var element in raffleCart.value) {
    //   total = total + (element.product!.shippingFee!);
    // }

    return total;
  }


  chargeCard(int amount) async {

    setState(() {
      isPaying = true;
    });
    if (paymentMethod == 'wallet') {
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
        if (res.data['receipt'] != null) {
          // showReceipt(res.data['receipt']);
        }
      } else {
        locator<SnackbarService>()
            .showSnackbar(message: res.data["message"]);
      }
    }
    else
        if(paymentMethod == 'paystack'){
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
            List<Map<String, dynamic>> storedList = cart.value.map((e) => e.toJson()).toList();
            await locator<LocalStorage>().save(LocalStorageDir.cart, storedList);

            if (res.data['receipt'] != null) {
              print('receipt');
              // showReceipt(res.data['receipt']);
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
      setState(() {
        isPaying = false;
      });
  }

  // void showReceipt(Map<String, dynamic> info) {
  //   print(getSubTotal());
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ReceiptWidget(
  //         info: info,
  //       );
  //     },
  //   );
  // }

  void showAddAddressBottomSheet() {
    String name = '';
    String houseAddress = '';
    String city = '';
    String state = '';
    String phoneNumber = '';
    bool isDefaultPayment = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Address',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight
                            .bold),
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        hint: 'House address',
                        controller: houseAddressController,
                        onChanged: (value) => houseAddress = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'City',
                        controller: cityController,
                        onChanged: (value) => city = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'State/Nationality',
                        controller: stateController,
                        onChanged: (value) => state = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'Phone Number',
                        controller: phoneNumberController,
                        onChanged: (value) => phoneNumber = value,
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: isDefaultPayment,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onChanged: (value) {
                              setModalState(() {
                                isDefaultPayment = value ?? false;
                              });
                            },
                          ),
                          const Text("Set as default payment method"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SubmitButton(
                          isLoading: false,
                          label: 'Add Address',
                          submit: () {
                            if (houseAddressController.text.isNotEmpty &&
                                cityController.text.isNotEmpty &&
                                stateController.text.isNotEmpty &&
                                phoneNumberController.text.isNotEmpty) {
                              createNewShipping();
                              // addAddress(
                              //     name, houseAddress, city, state, phoneNumber,
                              //     isDefaultPayment);
                            }
                            houseAddressController.clear();
                            cityController.clear();
                            stateController.clear();
                            phoneNumberController.clear();
                          },
                          color: kcPrimaryColor),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> createNewShipping() async {
    try {
      loading = true;
      final response = await repo.saveShipping({
        "address": houseAddressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "phoneNumber": phoneNumberController.text,
        "type": "Shipping"
      });

      if (response.statusCode == 200) {
        locator<SnackbarService>().showSnackbar(message: "Created address successfully", duration: Duration(seconds: 2));
        loading = false;
      } else {
        Navigator.pop(context);
        locator<SnackbarService>().showSnackbar(message: response.data["message"], duration: Duration(seconds: 2));
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to create address: $e", duration: Duration(seconds: 2));
    }finally{
      loading = false;
    }
  }

  Future<void> getShippings() async {
    try {
      isShippingLoading = true;
      final response = await repo.getAddresses();

      if (response.statusCode == 200) {
        // Access the `data` key in the response before mapping
        final List<dynamic> addressList = response.data['data'] ?? [];

        // Parse the address data
        shippingAddresses = addressList
            .map((item) => Address.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        print('Shipping addresses: $shippingAddresses');
      } else {
        locator<SnackbarService>().showSnackbar(
          message: response.data["message"],
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(
        message: "Failed to fetch addresses: $e",
        duration: Duration(seconds: 2),
      );
    } finally {
      isShippingLoading = false;
      setState(() {}); // Update the UI with the new data
    }
  }

}
