import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/dashboard/reviews.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

import 'dashboard_view.dart';

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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: kcWhiteColor),
            floating: true,
            expandedHeight: 300,
            flexibleSpace: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: (widget.product.raffle == null ||
                              widget.product.raffle!.isEmpty)
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(activePic),
                            ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )),
                ),
                Positioned(
                  bottom: 30,
                  child: Container(
                    height: 40,
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.light
                          ? kcWhiteColor
                          : kcBlackColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (widget.product.raffle == null ||
                                widget.product.raffle!.isEmpty)
                            ? ""
                            : "${widget.product.raffle?[0].ticketName}",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(widget.product.pictures!.length, (index) {
                    String? image = widget.product.pictures![index].location;
                    return image == null
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                activePic = image;
                              });
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(image)),
                                color: kcWhiteColor,
                                border: Border.all(
                                    color: activePic == image
                                        ? kcSecondaryColor
                                        : Colors.transparent,
                                    width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                  }),
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
                          : "${(widget.product.reviews?.map<int>((review) => review['rating'] as int).reduce((value, element) => value + element))! / widget.product.reviews!.length}",
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    widget.product.productName ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "N${widget.product.productPrice}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                verticalSpaceMedium,
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
                userLoggedIn.value == false
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: kcVeryLightGrey,
                                  borderRadius: BorderRadius.circular(9)),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          quantity--;
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: kcWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: kcBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpaceSmall,
                                  Text(
                                    "$quantity",
                                    style: const TextStyle(
                                      color: kcBlackColor,
                                    ),
                                  ),
                                  horizontalSpaceSmall,
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: kcWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: kcBlackColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                CartItem cartItem = CartItem(
                                    product: widget.product,
                                    quantity: quantity);
                                cart.value.add(cartItem);
                                cart.notifyListeners();
                                locator<SnackbarService>().showSnackbar(
                                    message: "Product added to cart");
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: 160,
                                decoration: BoxDecoration(
                                    color: kcPrimaryColor,
                                    borderRadius: BorderRadius.circular(9)),
                                child: const Center(
                                  child: Text(
                                    "Add to cart",
                                    style: TextStyle(color: kcWhiteColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
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
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (c) {
                                        return ProductDetail(product: product);
                                      }));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RecommendedRow(product: product),
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
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.network(
                        product.raffle![0].pictures![0].location!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 150,
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
                                text: " N${product.productPrice}",
                                style: GoogleFonts.inter(
                                    color: kcSecondaryColor, fontSize: 12))
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
