import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../utils/money_util.dart';
import 'cart_viewmodel.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class ShopCartView extends StackedView<CartViewModel> {
  const ShopCartView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CartViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3DB),
        centerTitle: false,
        title: const Text(
          "My Carts",
        ),
        actions: [
          viewModel.itemsToDelete.isNotEmpty
              ? InkWell(
                  onTap: () {
                    viewModel.clearCart();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: shopCart.value.isEmpty
          ? const EmptyState(
              animation: "empty_cart.json",
              label: "Cart Is Empty",
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: shopCart,
                  builder: (context, value, child) => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      CartItem item = value[index];
                      return GestureDetector(
                        onTap: () {
                          viewModel.addRemoveDelete(item);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: uiMode.value == AppUiModes.light ? const Color(0xFFFFFAF0) : kcBlackColor,
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
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                                image: NetworkImage(item
                                                    .product
                                                    ?.pictures![0]
                                                    .location ?? "assets/images/paypal.png"),
                                              ),
                                      ),
                                    ),
                                    horizontalSpaceMedium,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(item.product?.productName ?? "",
                                            style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,),
                                          verticalSpaceTiny,
                                          Text(
                                            MoneyUtils().formatAmount(item.product?.productPrice ?? 0 * item.quantity!),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                              fontFamily: "satoshi",
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  viewModel.itemsToDelete.contains(item)
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
                                            border:
                                                Border.all(color: kcLightGrey),
                                          ),
                                        ),
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (item.quantity! > 1) {
                                            item.quantity = item.quantity! - 1;
                                            shopCart.notifyListeners();
                                            viewModel.getShopSubTotal();
                                            viewModel.getDeliveryTotal();
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kcLightGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.remove,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Text("${item.quantity!}"),
                                      horizontalSpaceSmall,
                                      InkWell(
                                        onTap: () {
                                          item.quantity = item.quantity! + 1;
                                          shopCart.notifyListeners();
                                          viewModel.getShopSubTotal();
                                          viewModel.getDeliveryTotal();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kcLightGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                            ),
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
                ),
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
                      MoneyUtils().formatAmount(viewModel.shopSubTotal),
                      style: TextStyle(
                        fontSize: 16,
                        color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                        fontFamily: "satoshi",
                      ),)
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
                      viewModel.deliveryFee == 0 ? "Free" : "N${viewModel.deliveryFee}",
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
                      MoneyUtils().formatAmount(viewModel.shopSubTotal + viewModel.deliveryFee),
                      style: TextStyle(
                        fontSize: 16,
                        color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                        fontFamily: "satoshi",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                verticalSpaceLarge,
                SubmitButton(
                  isLoading: viewModel.isBusy,
                  label: "Checkout",
                  submit: viewModel.checkout,
                  color: kcPrimaryColor,
                  boldText: true,
                )
              ],
            ),
    );
  }


  @override
  void onViewModelReady(CartViewModel viewModel) {
    viewModel.getShopSubTotal();
    viewModel.getDeliveryTotal();
    super.onViewModelReady(viewModel);
  }

  @override
  CartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartViewModel();
}
