import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../utils/money_util.dart';
import '../../../utils/paymentModal.dart';
import '../../components/text_field_widget.dart';
import 'cart_viewmodel.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      CartViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      backgroundColor: kcSecondaryColor,
      appBar: AppBar(
        backgroundColor: kcSecondaryColor,
        centerTitle: false,
        title: const Text(
          "My Carts", style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Panchang"
        ),
        ),
        actions: [
          viewModel.itemsToDeleteRaffle.isNotEmpty
              ? InkWell(
            onTap: () {
              viewModel.clearRaffleCart();
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
      body:
        viewModel.isPaymentProcessing.value
      ? const Center(
          child: EmptyState(
            animation: "payment_process.json",
            label: "payment processing...",
          ) ) :

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: kcWhiteColor, // Set your desired background color
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: raffleCart.value.isEmpty
                      ? const EmptyState(
                    animation: "empty_cart.json",
                    label: "Cart Is Empty",
                  )
                      : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ValueListenableBuilder<List<RaffleCartItem>>(
                        valueListenable: raffleCart,
                        builder: (context, value, child) => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            RaffleCartItem item = value[index];
                            return GestureDetector(
                              onTap: () {
                                viewModel.addRemoveDeleteRaffle(item);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: uiMode.value == AppUiModes.light
                                      ? kcWhiteColor
                                      : kcBlackColor,
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
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              image:DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                  item.raffle?.media?[0].url ?? 'https://via.placeholder.com/120',
                                                ),
                                                fit: BoxFit.cover,
                                              ),

                                            ),
                                          ),
                                          horizontalSpaceSmall,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Win Prize!!!',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcWhiteColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Panchang"
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  item.raffle?.name ?? 'Product Name',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: "Panchang"
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                verticalSpaceTiny,

                                                Row(
                                                  children: [
                                                    Text(
                                                      MoneyUtils().formatAmountToDollars(item.raffle?.ticketPrice ?? 0 * item.quantity!),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                                          fontFamily: "Satoshi",
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    // horizontalSpaceSmall,
                                                    // Container(
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.grey[300]?.withOpacity(0.2),
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //   ),
                                                    //   child: Text(
                                                    //     '~${MoneyUtils().formatAmount(MoneyUtils().getRate(5 * item.quantity!))}',
                                                    //     style: TextStyle(
                                                    //       color: uiMode.value == AppUiModes.light ? kcBlackColor.withOpacity(0.5) : kcWhiteColor,
                                                    //       fontSize: 12,
                                                    //       fontWeight: FontWeight.bold,
                                                    //       fontFamily: "satoshi",
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                  ],
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
                                        viewModel.itemsToDeleteRaffle.contains(item)
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
                                                  viewModel.getRaffleSubTotal();
                                                  raffleCart.notifyListeners();
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
                                                viewModel.getRaffleSubTotal();
                                                raffleCart.notifyListeners();
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
                      //Refferal input field
                      verticalSpaceMedium,

                    ],
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                //   padding: const EdgeInsets.all(12), // Add padding inside the container
                //   decoration: BoxDecoration(
                //     color: Colors.white, // Set the background color to white
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: kcDarkGreyColor),// Round the corners
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1), // Shadow color
                //         spreadRadius: 1, // Spread radius
                //         blurRadius: 5, // Blur radius
                //         offset: const Offset(0, 3), // changes position of shadow
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       RichText(
                //         text: TextSpan(
                //           children: [
                //             TextSpan(
                //               text: 'With Each Purchase Also get Afripoints which can be used on our ecommerce store',
                //               style: TextStyle(
                //                 fontSize: 13, // Size for the dollar amount
                //                 color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       // const SizedBox(height: 16),
                //       // HorizontalSlidableButton(
                //       //   width: MediaQuery.of(context).size.width / 2,
                //       //   buttonWidth: 110.0,
                //       //   border: Border.all(color: kcPrimaryColor),
                //       //   color: kcSecondaryColor,
                //       //   buttonColor: kcPrimaryColor,
                //       //   dismissible: false,
                //       //   label: Center(child: Row(children: [
                //       //     horizontalSpaceTiny,
                //       //     const Text('Go to Shop', style: TextStyle(color: kcWhiteColor),),
                //       //     SvgPicture.asset(
                //       //       'assets/icons/arrow-circle-right.svg',
                //       //       height: 20, // Icon size
                //       //     ),
                //       //
                //       //    ],)
                //       //   ),
                //       //   child: const Padding(
                //       //     padding: EdgeInsets.all(8.0),
                //       //     child: Row(
                //       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       //       children: [
                //       //         // Text('Left'),
                //       //         // Text('Right'),
                //       //       ],
                //       //     ),
                //       //   ),
                //       //   onChanged: (position) {
                //       //     setState(() {
                //       //       if (position == SlidableButtonPosition.end) {
                //       //         Navigator.of(context).pop();
                //       //         switchModule(AppModules.shop);
                //       //       }
                //       //     });
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    label: "referral code",
                    hint: "referral code (optional)",
                    controller: viewModel.refferalCode,
                  ),
                ),
                verticalSpaceSmall,
                if(raffleCart.value.isNotEmpty)
                  _buildProceedToPaySection(context, viewModel), // This will be the bottom pinned section
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildProceedToPaySection(BuildContext context, CartViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: kcSecondaryColor, borderRadius: BorderRadius.circular(5),// Adjust the color to match the design
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -2), // Shadow for the top edge
          ),
        ],
        border: Border.all(color: kcPrimaryColor),
      ),
      child: SafeArea(
        child: InkWell(
          onTap: (){
            _showPaymentModal(context, viewModel);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward, // Use the appropriate icon
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kcPrimaryColor, // Adjust text color to match design
                      fontSize: 12, // Adjust font size to match design
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        MoneyUtils().formatAmount(viewModel.raffleSubTotal),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      // horizontalSpaceTiny,
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[300]?.withOpacity(0.2),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Text(
                      //     '~${MoneyUtils().formatAmount(MoneyUtils().getRate(viewModel.subTotal))}',
                      //     style: TextStyle(
                      //       color: kcWhiteColor,
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.bold,
                      //       fontFamily: "satoshi",
                      //     ),
                      //   ),
                      // ),
                    ],
                  )

                ],
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context, CartViewModel viewModel) {
    return ElevatedButton(
      onPressed: () {
          _showPaymentModal(context, viewModel);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: kcPrimaryColor, backgroundColor: kcSecondaryColor, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Button corner radius
        ),
        elevation: 0, // Remove elevation
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16, // Adjust the font size as needed
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Proceed to Pay",
            style: TextStyle(
              fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "Panchang"
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward, // Use the appropriate icon
          ),
        ],
      ),
    );
  }


  // void _showPaymentModal(BuildContext context, CartViewModel viewModel) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //     return ValueListenableBuilder<PaymentMethod>(
  //         valueListenable: viewModel.selectedPaymentMethod,
  //         builder: (context, value, child) {
  //       return DraggableScrollableSheet(
  //       expand: false,
  //       builder: (_, controller) {
  //         return ValueListenableBuilder<bool>(
  //           valueListenable: viewModel.isPaymentProcessing,
  //           builder: (context, isProcessing, child) {
  //             return PaymentModalWidget(
  //               onPaymentMethodSelected: (PaymentMethod method) {
  //                 viewModel.selectMethod(method);
  //               },
  //               onProceedWithPayment: ()  async {
  //                 viewModel.checkoutRaffle(context);
  //               },
  //               totalAmount: (viewModel.raffleSubTotal),
  //               selectedPaymentMethod: viewModel.selectedPaymentMethod.value,
  //               isPaymentProcessing: isProcessing,
  //             );
  //           });
  //       },
  //     );
  //       });
  //     },
  //   );
  // }

  void _showPaymentModal(BuildContext context, CartViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ValueListenableBuilder<PaymentMethod>(
          valueListenable: viewModel.selectedPaymentMethod,
          builder: (context, value, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: PaymentModalWidget(
                onPaymentMethodSelected: (PaymentMethod method) {
                  viewModel.selectMethod(method);
                },
                onProceedWithPayment: () async {
                  viewModel.checkoutRaffle(context);
                },
                totalAmount: viewModel.raffleSubTotal,
                selectedPaymentMethod: viewModel.selectedPaymentMethod.value,
                isPaymentProcessing: viewModel.isPaymentProcessing.value,
              ),
            );
          },
        );
      },
    );
  }


  @override
  void onViewModelReady(CartViewModel viewModel) {
    viewModel.fetchOnlineCart();
    viewModel.getRaffleSubTotal();
    super.onViewModelReady(viewModel);
  }

  @override
  CartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartViewModel();

}





