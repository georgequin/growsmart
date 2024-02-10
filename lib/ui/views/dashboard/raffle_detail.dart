import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/reviews.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/network/interceptors.dart';
import '../../../utils/money_util.dart';
import '../../components/submit_button.dart';
import 'dashboard_viewmodel.dart';

class RaffleDetail extends StatefulWidget {
  final Raffle raffle;

  const RaffleDetail({
    required this.raffle,
    Key? key,
  }) : super(key: key);

  @override
  State<RaffleDetail> createState() => _RaffleDetailState();



}

class _RaffleDetailState extends State<RaffleDetail> {
  int quantity = 1;
  String activePic = "";
  List<Raffle> recommended = [];



  @override
  void initState() {
    getRecommendedRaffles();
    setState(() {
      activePic =
          (widget.raffle == null)
              ? ""
              : widget.raffle.pictures?[0].location ?? "";
    });

    currentModuleNotifier.addListener(_handleModuleChange);
    super.initState();
  }

  @override
  void dispose() {
    currentModuleNotifier.removeListener(_handleModuleChange);
    super.dispose();
  }

  void _handleModuleChange() {
    if (currentModuleNotifier.value == AppModules.shop) {
      // TODO: Navigate to the Shop module if not already there
      // You might want to check the current route to avoid unnecessary navigation.
    }
  }

  void getRecommendedRaffles() async {
    try {
      ApiResponse res = await repo.getFeaturedRaffle();
      if (res.statusCode == 200) {
        setState(() {
          recommended = (res.data["raffle"] as List)
              .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Color?> _updateTextColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    // Calculate the brightness of the dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;
    final double luminance = dominantColor.computeLuminance();

    // Decide text color based on luminance
    return luminance < 0.1 ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        onModelReady: (viewModel) {
          // Perform any action on the viewModel if necessary when the model is ready
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                            decoration: BoxDecoration(
                                            color: kcPrimaryColor,
                              borderRadius: const BorderRadius.only( topLeft:
                              Radius.circular(12), topRight:  Radius.circular(12)
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only( topLeft:
                                Radius.circular(12), topRight:  Radius.circular(12)
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0, // Make the loader thinner
                                        valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                      ),
                                    ),
                                    imageUrl:  widget.raffle.pictures?.first.location ?? 'https://via.placeholder.com/150',
                                    height: 182,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fadeInDuration: const Duration(milliseconds: 500),
                                    fadeOutDuration: const Duration(milliseconds: 300),
                                  ),
                              Padding( // Add padding to the row
                                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0,0), // Adjust padding as needed
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Win!!!',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Panchang"
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Padding( // Add padding to the row
                                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0,8.0), // Adjust padding as needed
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.raffle.ticketName ?? 'Product Name',
                                      style:  TextStyle(
                                          fontSize: 20,
                                          color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Panchang"
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),
                              ),
                                ],
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300]?.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Buy \$5 Afriprize Card',
                                        style: TextStyle(
                                            color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: uiMode.value == AppUiModes.light ? kcPrimaryColor : kcSecondaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Afriprize Card',
                                            style: TextStyle(
                                                color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/card_icon.svg',
                                                height: 20, // Icon size
                                              ),
                                              horizontalSpaceTiny,
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '\$5',
                                                      style: TextStyle(
                                                        fontSize: 18, // Size for the dollar amount
                                                        fontWeight: FontWeight.bold,
                                                        color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcBlackColor,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '.00', // Assuming you want the decimal part smaller
                                                      style: TextStyle(
                                                        fontSize: 13, // Size for the cents
                                                        fontWeight: FontWeight.bold,
                                                        color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcBlackColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/loader.svg',
                                                height: 20, // Icon size
                                              ),
                                              horizontalSpaceTiny,
                                              Column(
                                                children: [
                                                  Text(
                                                    "${widget.raffle.verifiedSales} sold out of ${widget.raffle.stockTotal}",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 95,
                                                    child: LinearProgressIndicator(
                                                      value: (widget.raffle.verifiedSales != null && widget.raffle.stockTotal != null && widget.raffle.stockTotal! > 0)
                                                          ? widget.raffle.verifiedSales! / widget.raffle.stockTotal!
                                                          : 0.0, // Default value in case of null or invalid stock
                                                      backgroundColor: kcSecondaryColor.withOpacity(0.3),
                                                      valueColor: const AlwaysStoppedAnimation(kcSecondaryColor),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    verticalSpaceSmall,
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300]?.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        (widget.raffle == null        )
                                            ? ""
                                                        : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(widget.raffle.endDate ?? DateTime.now().toIso8601String()))}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(45.0, 5.0, 45.0, 5.0),
                            padding: const EdgeInsets.all(12), // Add padding inside the container
                            decoration: BoxDecoration(
                              color: Colors.white, // Set the background color to white
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kcSecondaryColor),// Round the corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'With Each Purchase Also get in-store Card voucher can be used to buy any item(s) from',
                                        style: TextStyle(
                                          fontSize: 13, // Size for the dollar amount
                                          color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' AfriprizeShop online store.', // Assuming you want the decimal part smaller
                                        style: TextStyle(
                                          fontSize: 13, // Size for the cents
                                          color: uiMode.value == AppUiModes.light ? Colors.blueAccent : kcWhiteColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                HorizontalSlidableButton(
                                  width: MediaQuery.of(context).size.width / 2,
                                  buttonWidth: 110.0,
                                  border: Border.all(color: kcPrimaryColor),
                                  color: kcSecondaryColor,
                                  buttonColor: kcPrimaryColor,
                                  dismissible: false,
                                  label: Center(child: Row(children: [
                                    horizontalSpaceTiny,
                                    Text('Go to Shop', style: TextStyle(color: kcWhiteColor),),
                                    SvgPicture.asset(
                                      'assets/icons/arrow-circle-right.svg',
                                      height: 20, // Icon size
                                    ),

                                   ],)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text('Left'),
                                        // Text('Right'),
                                      ],
                                    ),
                                  ),
                                  onChanged: (position) {
                                    setState(() {
                                      if (position == SlidableButtonPosition.end) {
                                        Navigator.of(context).pop();
                                        switchModule(AppModules.shop);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      verticalSpaceLarge,
                      //add to cart button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: userLoggedIn.value == false
                            ? const SizedBox()
                            : ValueListenableBuilder<List<RaffleCartItem>>(
                            valueListenable: raffleCart,
                            builder: (context, value, child) {
                              bool isInCart = value.any((item) =>
                              item.raffle?.id == widget.raffle.id);
                              RaffleCartItem? cartItem = isInCart
                                  ? value.firstWhere((item) =>
                              item.raffle?.id == widget.raffle.id)
                                  : null;

                              return isInCart && cartItem != null
                                  ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: kcVeryLightGrey,
                                    borderRadius:
                                    BorderRadius.circular(9)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 53,
                                      decoration: BoxDecoration(
                                        color: kcWhiteColor,
                                        borderRadius:
                                        BorderRadius.circular(9),
                                      ),
                                      child:  Row(
                                        children: [
                                          InkWell(
                                            onTap: () => viewModel
                                                .decreaseRaffleQuantity(cartItem),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: kcWhiteColor,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                  child: Icon(Icons.remove,
                                                      size: 18,
                                                      color: kcBlackColor)),
                                            ),
                                          ),
                                          horizontalSpaceSmall,
                                          Text(
                                            "${cartItem.quantity}",
                                            style: const TextStyle(
                                                color: kcBlackColor),
                                          ),
                                          horizontalSpaceSmall,
                                          InkWell(
                                            onTap: () => viewModel
                                                .increaseRaffleQuantity(cartItem),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: kcWhiteColor,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.add,
                                                      size: 18,
                                                      color: kcBlackColor)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        locator<NavigationService>()
                                            .navigateToCartView();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: kcWhiteColor,
                                          borderRadius:
                                          BorderRadius.circular(9),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Goto Cart",
                                              style: TextStyle(
                                                  color: kcPrimaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                              )
                                  : InkWell(
                                onTap: () async {
                                  RaffleCartItem newItem = RaffleCartItem(
                                      raffle: widget.raffle,
                                      quantity: 1);
                                  viewModel.addToRaffleCart(widget.raffle);
                                },
                                child: Container(
                                  height: 50,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: kcSecondaryColor,
                                    borderRadius:
                                    BorderRadius.circular(9),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: kcWhiteColor,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Add to cart",
                                        style: TextStyle(
                                            color: kcWhiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
