import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/cart/checkout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CartViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "My Carts",
          style: TextStyle(
            color: kcBlackColor,
          ),
        ),
        actions: [
          viewModel.itemsToDelete.isNotEmpty
              ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
              )
              : const SizedBox()
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  viewModel.addRemoveDelete(index);
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
                              image: const DecorationImage(
                                image: AssetImage("assets/images/shoe.png"),
                              ),
                            ),
                          ),
                          horizontalSpaceMedium,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Cotton Shirt Regular Fit"),
                              Text("Cotton Shirt Regular Fit"),
                              verticalSpaceTiny,
                              Text(
                                "\$20",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          viewModel.itemsToDelete.contains(index)
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    color: kcSecondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: kcWhiteColor,
                                      size: 16,
                                    ),
                                  ),
                                )
                              : Container(
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
                                    border: Border.all(color: kcLightGrey),
                                    borderRadius: BorderRadius.circular(5)),
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
                                    border: Border.all(color: kcLightGrey),
                                    borderRadius: BorderRadius.circular(5)),
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
              );
            },
          ),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          verticalSpaceLarge,
          SubmitButton(
            isLoading: false,
            label: "Checkout",
            submit: () {
              locator<NavigationService>().navigateToView(const Checkout());
            },
            color: kcPrimaryColor,
            boldText: true,
          )
        ],
      ),
    );
  }

  @override
  CartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartViewModel();
}
