import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/network/interceptors.dart';
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
              : widget.raffle.media?[0].location ?? "";
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
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 10.0),
                            child: Container(
                              width: double.infinity,
                              height: 370,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Image covering the entire card
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.raffle.media!.isNotEmpty == true
                                          ? widget.raffle.media![0].url!
                                          : 'https://via.placeholder.com/150',
                                      height: 350,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Tint overlay for better readability
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.6), // Dark semi-transparent overlay
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  ),
                                  // Raffle details positioned on top of the image
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: kcWhiteColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        widget.raffle.formattedTicketPrice ?? '',
                                        style: const TextStyle(
                                          color: kcPrimaryColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Draw Happening',
                                              style: TextStyle(
                                                color: kcSecondaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                            .format(DateTime.parse(widget.raffle.endDate ?? '')),
                                          style: const TextStyle(
                                            color: kcWhiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 23,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Image.asset("assets/images/partcipant_icon.png", width: 40,),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${widget.raffle.participants?.length ?? 0} Participants',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                                child: Text(
                                  widget.raffle.name ?? '',
                                  style: const TextStyle(
                                    color: kcBlackColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                                child: Text(
                                  widget.raffle.description ?? '',
                                  style: const TextStyle(
                                    color: kcBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                   Padding(
                                    padding: EdgeInsets.only(right: 0.0, left: 10.0, top: 10.0),
                                    child: SvgPicture.asset(
                                      "assets/images/benfits.svg",
                                      height: 20,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                                    child: Text(
                                      'Extra Benefits',
                                      style: TextStyle(
                                        color: kcBlackColor, // Ensure this color contrasts the background
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                                child: SvgPicture.asset(
                                  "assets/images/InfoSquare.svg",
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0,10.0,16.0,16.0),
                            child: doMoreOnAfriprize(context),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            padding: const EdgeInsets.all(12), // Add padding inside the container
                            decoration: BoxDecoration(
                              color: Colors.white, // Set the background color to white
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kcDarkGreyColor),// Round the corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'With Each Purchase Also get Afripoints which can be used on our ecommerce store',
                                        style: TextStyle(
                                          fontSize: 13, // Size for the dollar amount
                                          color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(height: 16),
                                // HorizontalSlidableButton(
                                //   width: MediaQuery.of(context).size.width / 2,
                                //   buttonWidth: 110.0,
                                //   border: Border.all(color: kcPrimaryColor),
                                //   color: kcSecondaryColor,
                                //   buttonColor: kcPrimaryColor,
                                //   dismissible: false,
                                //   label: Center(child: Row(children: [
                                //     horizontalSpaceTiny,
                                //     const Text('Go to Shop', style: TextStyle(color: kcWhiteColor),),
                                //     SvgPicture.asset(
                                //       'assets/icons/arrow-circle-right.svg',
                                //       height: 20, // Icon size
                                //     ),
                                //
                                //    ],)
                                //   ),
                                //   child: const Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         // Text('Left'),
                                //         // Text('Right'),
                                //       ],
                                //     ),
                                //   ),
                                //   onChanged: (position) {
                                //     setState(() {
                                //       if (position == SlidableButtonPosition.end) {
                                //         Navigator.of(context).pop();
                                //         switchModule(AppModules.shop);
                                //       }
                                //     });
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      verticalSpaceMedium,
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
                                          color: kcSecondaryColor,
                                          borderRadius:
                                          BorderRadius.circular(20),
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
                                    ),
                                    Container(
                                      height: 53,
                                      decoration: BoxDecoration(
                                        color: kcWhiteColor,
                                        borderRadius:
                                        BorderRadius.circular(20),
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
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: kcSecondaryColor,
                                    borderRadius:
                                    BorderRadius.circular(9),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add Raffle to cart",
                                        style: TextStyle(
                                            color: kcPrimaryColor),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: kcPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      verticalSpaceSmall
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget doMoreOnAfriprize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55, // Adjust height according to your design
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  // Action for the first container
                  print('Instant Wallet Credit clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Added padding around the content of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Colored Circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between the circle and the text
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Instant Wallet Credit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4), // Adjust space between title and description
                              Text(
                                'Value equal to the ticket\'s value!',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // First Container
              GestureDetector(
                onTap: () {
                  // Action for the first container
                  print('Instant Wallet Credit clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Added padding around the content of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Colored Circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between the circle and the text
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Donate to Non-profits',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4), // Adjust space between title and description
                              Text(
                                'Supported by our partners',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
