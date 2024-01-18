import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import '../../../utils/money_util.dart';
import 'dashboard_viewmodel.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  String activePic = "";
  List<Product> recommended = [];

  @override
  void initState() {
    getRecommendedProducts();
    setState(() {
      activePic =
          (widget.product.raffle == null || widget.product.raffle!.isEmpty)
              ? ""
              : widget.product.raffle?[0].pictures?[0].location ?? "";
    });

    super.initState();
  }

  void getRecommendedProducts() async {
    try {
      ApiResponse res = await locator<Repository>()
          .recommendedProducts(widget.product.id.toString());
      if (res.statusCode == 200) {
        setState(() {
          recommended = (res.data["recommended"] as List)
              .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
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
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                child: (widget.product.raffle == null ||
                                        widget.product.raffle!.isEmpty)
                                    ? SizedBox(
                                        height: 178,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      )
                                    : Image.network(
                                        (widget.product.raffle![0].pictures !=
                                                    null &&
                                                widget.product.raffle![0]
                                                    .pictures!.isNotEmpty)
                                            ? widget.product.raffle![0]
                                                .pictures![0].location ?? ''
                                            : '',
                                        // Provide a default value or handle the case when pictures are empty
                                        fit: BoxFit.fill,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 130,
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
                          Container(
                            color: kcPrimaryColor,
                            // Set the background color to blue
                            padding: const EdgeInsets.all(7.0),
                            // Add padding to the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    (widget.product.raffle == null ||
                                            widget.product.raffle!.isEmpty)
                                        ? ""
                                        : widget.product.raffle?[0]
                                                .ticketName ??
                                            "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors
                                          .white, // Set the text color to white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 20.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              // Allocate 60% of the space to this widget
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      image: widget.product
                                                              .pictures!.isEmpty
                                                          ? null
                                                          : DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  widget
                                                                      .product
                                                                      .pictures![
                                                                          0]
                                                                      .location ?? 'assets/images/afriprize.png'),
                                                            ),
                                                      color: kcWhiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Add some spacing between the image and text
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Buy ${widget.product.productName!}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${MoneyUtils().formatAmount(widget.product.productPrice!)}",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 3,
                                                          style:
                                                               TextStyle(
                                                                color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                                                fontFamily: "satoshi",
                                                            fontSize: 19,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            flex: 3,
                                            // Allocate 60% of the space to this widget
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${widget.product.verifiedSales} sold out of ${widget.product.stockTotal}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: (widget.product.verifiedSales != null &&
                                                            widget.product
                                                                    .stockTotal !=
                                                                null &&
                                                            widget.product
                                                                    .stockTotal! >
                                                                0)
                                                        ? widget.product
                                                                .verifiedSales! /
                                                            widget.product
                                                                .stockTotal!
                                                        : 0.0,
                                                    // Default value in case of null or invalid stock
                                                    backgroundColor:
                                                        kcSecondaryColor
                                                            .withOpacity(0.3),
                                                    valueColor:
                                                        const AlwaysStoppedAnimation(
                                                            kcSecondaryColor),
                                                  ),
                                                ),
                                                Text(
                                                  (widget.product.raffle ==
                                                              null ||
                                                          widget.product.raffle!
                                                              .isEmpty)
                                                      ? ""
                                                      : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(widget.product.raffle?[0].startDate ?? DateTime.now().toIso8601String()))}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
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
                                              image: NetworkImage(image),
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
                          horizontalSpaceSmall,
                          Text(
                            (widget.product.reviews == null ||
                                    widget.product.reviews!.isEmpty)
                                ? ""
                                : "${(widget.product.reviews?.map<int>((review) => review.rating as int).reduce((value, element) => value + element))! / widget.product.reviews!.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          horizontalSpaceSmall,
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
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      verticalSpaceLarge,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: userLoggedIn.value == false
                            ? const SizedBox()
                            : ValueListenableBuilder<List<CartItem>>(
                            valueListenable: cart,
                            builder: (context, value, child) {
                              bool isInCart = value.any((item) =>
                              item.product?.id == widget.product.id);
                              CartItem? cartItem = isInCart
                                  ? value.firstWhere((item) =>
                              item.product?.id == widget.product.id)
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
                                  children: [
                                    InkWell(
                                      onTap: () => viewModel
                                          .decreaseQuantity(cartItem),
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
                                          .increaseQuantity(cartItem),
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
                              )
                                  : InkWell(
                                onTap: () async {
                                  CartItem newItem = CartItem(
                                      product: widget.product,
                                      quantity: 1);
                                  viewModel.addToCart(widget.product);
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



                      verticalSpaceSmall,
                      recommended.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                    child: Text(
                                  "Related",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                verticalSpaceMedium,
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommended.length,
                                      itemBuilder: (context, index) {
                                        Product product = recommended[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (c) {
                                              return ProductDetail(
                                                  product: product);
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RecommendedRow(
                                                product: product),
                                          ),
                                        );
                                      }),
                                ),
                                verticalSpaceMedium,
                              ],
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
                                text: "Buy ${product.productName} for: ",
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
