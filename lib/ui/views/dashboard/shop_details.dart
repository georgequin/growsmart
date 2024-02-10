import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/reviews.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../utils/money_util.dart';
import 'dashboard_viewmodel.dart';

class ShopDetail extends StatefulWidget {
  final Product product;

  const ShopDetail({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  int quantity = 1;
  String activePic = "";
  List<Product> recommended = [];

  @override
  void initState() {
    // getRecommendedProducts();
    setState(() {
      activePic = widget.product.pictures?[0].location ?? "https://via.placeholder.com/150";
    });

    super.initState();
  }

  // void getRecommendedProducts() async {
  //   try {
  //     ApiResponse res = await locator<Repository>()
  //         .recommendedProducts(widget.product.id.toString());
  //     if (res.statusCode == 200) {
  //       setState(() {
  //         recommended = (res.data["recommended"] as List)
  //             .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
  //             .toList();
  //       });
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

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
            backgroundColor: Color(0xFFFFF3DB),
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          verticalSpaceSmall,
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child:
                                CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0, // Make the loader thinner
                                      valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                    ),
                                  ),
                                  imageUrl: widget.product.pictures?.first.location ?? 'https://via.placeholder.com/150',
                                  height: 311,
                                  width: 354,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fadeInDuration: const Duration(milliseconds: 500),
                                  fadeOutDuration: const Duration(milliseconds: 300),
                                ),
                              ),
                              // Positioned(
                              //   top: 20,
                              //   right: 20,
                              //   child: Container(
                              //     height: 20,
                              //     width: 50,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         const Icon(
                              //           Icons.star,
                              //           color: kcStarColor,
                              //           size: 20,
                              //         ),
                              //         FutureBuilder<Color?>(
                              //             future: _updateTextColor(
                              //                 widget.product.raffle![0].pictures![0].location!),
                              //             builder: (context, snapshot) {
                              //               return Text(
                              //                 (widget.product.reviews == null ||
                              //                     widget.product.reviews!.isEmpty)
                              //                     ? "0"
                              //                     : "${(widget.product.reviews?.map<int>((review) => review['rating'] as int).reduce((value, element) => value + element))! / widget.product.reviews!.length}",
                              //                 style: TextStyle(
                              //                   fontWeight: FontWeight.bold,
                              //                   color: snapshot.data,
                              //                 ),
                              //               );
                              //             })
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 20.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      // Use Flexible for product name to take the remaining space
                                      child: Text(
                                        'Buy ${widget.product.productName!}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Adjust max lines as needed
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8), // Space between the name and the price
                                    Text(
                                      " ${MoneyUtils().formatAmount(widget.product.productPrice!)}",
                                      style: TextStyle(
                                        color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Panchang",
                                        fontSize: 19,
                                      ),
                                    ),
                                  ],
                                )

                              ),
                            ],
                          )
                        ],
                      ),
                      verticalSpaceSmall,
                      Container(
                        margin:  EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFecdcb7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Color(0xFFCC9933),
                            ),
                            Expanded(child: Text(
                              'Unlock shopping credit by joining raffles with Afriprize cards. Buy, win, and shop all in one go!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.7),
                              ),
                            ),)
                          ],
                        )

                      ),
                      verticalSpaceMedium,
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 10.0, 8.0, 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                              widget.product.pictures!.length, (index) {
                            String? image =
                                widget.product.pictures![index].location;
                            return Row(
                              // Add a Row to contain each item
                              children: [
                                image == null
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: InteractiveViewer(
                                                    child: Image.network(image),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                image ?? 'https://via.placeholder.com/120',
                                              ),
                                            ),

                                            color: kcWhiteColor,
                                            border: Border.all(
                                              color: activePic == image
                                                  ? kcSecondaryColor
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 10),
                                // Add horizontal space between items
                              ],
                            );
                          }),
                        ),
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          horizontalSpaceMedium,
                          const Icon(
                            Icons.star,
                            color: kcStarColor,
                          ),
                          horizontalSpaceTiny,
                          Text(
                            (widget.product.reviews == null ||
                                    widget.product.reviews!.isEmpty)
                                ? ""
                                : "${(widget.product.reviews?.map<int>((review) => review.rating as int).reduce((value, element) => value + element))! / widget.product.reviews!.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          horizontalSpaceTiny,
                          Text(
                            "(${widget.product.reviews?.length})",
                            style: const TextStyle(color: kcLightGrey),
                          ),
                          horizontalSpaceSmall,
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return Reviews(product: widget.product);
                              }));
                            },
                            child: const Text(
                              "Reviews",
                            ),
                          )
                        ],
                      ),
                      verticalSpaceSmall,
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Product description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          widget.product.productDescription ?? "",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      verticalSpaceLarge,
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: userLoggedIn.value == false
                              ? const SizedBox()
                              : ValueListenableBuilder<List<CartItem>>(
                              valueListenable: shopCart,
                              builder: (context, value, child) {
                                bool isInCart = value.any((item) =>
                                item.product?.id == widget.product.id);
                                CartItem? cartItem = isInCart
                                    ? value.firstWhere((item) =>
                                item.product?.id == widget.product.id)
                                    : null;

                                return isInCart && cartItem != null
                                    ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFFF3DB).withOpacity(0.9),
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
                                        child: Row(
                                          children: [
                                              InkWell(
                                                  onTap: () => viewModel
                                                .decreaseQuantity(cartItem),
                                            child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                            color: kcSecondaryColor,
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            ),
                                            child: const Center(
                                            child: Icon(Icons.remove,
                                            size: 18,
                                            color: kcBlackColor)),
                                            ),
                                            ),
                                            horizontalSpaceMedium,
                                            Text(
                                            "${cartItem.quantity}",
                                            style: const TextStyle(
                                            color: kcBlackColor),
                                            ),
                                            horizontalSpaceMedium,
                                            InkWell(
                                            onTap: () => viewModel
                                                .increaseQuantity(cartItem),
                                            child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                            color: kcSecondaryColor,
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
                                          ]
                                        ),
                                      ),
                                      InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              locator<NavigationService>()
                                                  .navigateToShopCartView();
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
                                    CartItem newItem = CartItem(
                                        product: widget.product,
                                        quantity: 1);
                                    viewModel.addToProductCart(widget.product);
                                  },
                                  child: Container(
                                    height: 50,
                                    // width: 160,
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
                      ),

                      verticalSpaceLarge,
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class RecommendedRow extends StatelessWidget {
  final Product product;

  const RecommendedRow({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kcBlackColor.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 4,
            )
          ]),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: (product.raffle == null ||
                            product.raffle?[0].pictures == null) ||
                        product.raffle![0].pictures!.isEmpty
                    ? SizedBox(
                        height: 179,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.network(
                        product.raffle![0].pictures![0].location!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 179,
                      ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: uiMode.value == AppUiModes.light
                        ? kcWhiteColor
                        : kcBlackColor,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: kcStarColor,
                        size: 20,
                      ),
                      Text(
                        "4.9",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    image: product.pictures!.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(product.pictures![0].location!)),
                    color: kcWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.raffle?[0].ticketName ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: " ${product.productName}",
                                style: GoogleFonts.inter(
                                    color: kcBlackColor, fontSize: 12)),
                            TextSpan(
                                text: " ${MoneyUtils().formatAmount(product.productPrice!)}",
                                style: TextStyle(color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                  fontFamily: "satoshi",),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "0 sold out of ${product.stock}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    verticalSpaceTiny,
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        value: 0.4,
                        backgroundColor: kcSecondaryColor.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation(kcSecondaryColor),
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      "Draw date: ${DateFormat("d MMM").format(DateTime.parse(product.raffle?[0].created ?? DateTime.now().toIso8601String()))}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
