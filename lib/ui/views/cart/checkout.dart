import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/drop_down_widget.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';
import '../../common/ui_helpers.dart';
import '../../components/text_field_widget.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: kcBlackColor,
          ),
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
              subtitle: const Text("2 items in cart"),
              children: List.generate(
                  2,
                  (index) => GestureDetector(
                        onTap: () {
                          // viewModel.addRemoveDelete(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          decoration: BoxDecoration(
                            color: kcWhiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFE5E5E5).withOpacity(0.4),
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
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/shoe.png"),
                                      ),
                                    ),
                                  ),
                                  horizontalSpaceMedium,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Cotton Shirt Regular Fit"),
                                      Text("Cotton Shirt Regular Fit"),
                                      verticalSpaceTiny,
                                      Text(
                                        "\$20",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: kcLightGrey),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: kcLightGrey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      const Text("2"),
                                      horizontalSpaceSmall,
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: kcLightGrey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
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
                  children: const [
                    Text(
                      "Sub-total",
                      style: TextStyle(
                        fontSize: 16,
                        color: kcMediumGrey,
                      ),
                    ),
                    Text(
                      "\$60",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Delivery-Fee",
                      style: TextStyle(
                        fontSize: 16,
                        color: kcMediumGrey,
                      ),
                    ),
                    Text(
                      "\$10",
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
                  children: const [
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 16,
                          color: kcBlackColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$70",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  controller: TextEditingController(),
                ),
                verticalSpaceMedium,
                DropdownWidget(
                  value: null,
                  itemsList: const [],
                  hint: "State/Province",
                  onChanged: () {},
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "City",
                  controller: TextEditingController(),
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Phone",
                  controller: TextEditingController(),
                ),
                verticalSpaceMedium,
                TextFieldWidget(
                  hint: "Zip/Postal Code",
                  controller: TextEditingController(),
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
                Container(
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
                      ),
                      horizontalSpaceSmall,
                      const Text(
                        "PayPal",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      horizontalSpaceSmall,
                      const Expanded(
                        child: Text(
                          "You will be redirected to the PayPal website after submitting your order",
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Image.asset("assets/images/paypal.png")
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: kcBlackColor, width: 0.5)),
                  child: Column(
                    children: [
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                              ),
                              horizontalSpaceSmall,
                              const Text(
                                "Pay with Credit Card",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset("assets/images/visa.png"),
                              verticalSpaceTiny,
                              Image.asset("assets/images/discover.png"),
                              verticalSpaceTiny,
                              Image.asset("assets/images/maestro.png"),
                              verticalSpaceTiny,
                              Image.asset("assets/images/master_card.png"),
                            ],
                          )
                        ],
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFieldWidget(
                              hint: "Card number",
                              controller: TextEditingController(),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            flex: 2,
                            child: TextFieldWidget(
                              hint: "Expiry",
                              controller: TextEditingController(),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFieldWidget(
                              hint: "Card Security Code",
                              controller: TextEditingController(),
                            ),
                          ),
                          horizontalSpaceSmall,
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "What is this?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Container(
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
                        style: TextStyle(fontSize: 11, color: kcMediumGrey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          verticalSpaceMassive,
          SubmitButton(
            isLoading: false,
            label: "Pay \$70",
            submit: () {
              locator<NavigationService>().navigateTo(Routes.receipt);
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
}
