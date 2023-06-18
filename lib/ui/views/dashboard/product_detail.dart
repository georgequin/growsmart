import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

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
  int quantity = 0;

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
                      image: widget.product.pictures!.isEmpty
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget
                                  .product.raffleAd!.pictures![0].location!),
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
                    decoration: const BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${widget.product.raffleAd?.adName}",
                        style: GoogleFonts.inter(fontSize: 11),
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
                        : Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(image)),
                              color: kcWhiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                  }),
                ),
                verticalSpaceMedium,
                const Row(
                  children: [
                    horizontalSpaceMedium,
                    Icon(
                      Icons.star,
                      color: kcStarColor,
                    ),
                    horizontalSpaceSmall,
                    Text(
                      "4.9",
                      style: TextStyle(
                        color: kcBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    horizontalSpaceSmall,
                    Text(
                      "(85)",
                      style: TextStyle(color: kcLightGrey),
                    ),
                    horizontalSpaceSmall,
                    Text(
                      "Reviews",
                      style: TextStyle(color: kcBlackColor),
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    widget.product.productDescription ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                verticalSpaceLarge,
                Padding(
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
                                  if (quantity > 0) {
                                    quantity--;
                                  }
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: kcWhiteColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpaceSmall,
                            Text("$quantity"),
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
                                    borderRadius: BorderRadius.circular(5)),
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
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          CartItem cartItem = CartItem(
                              product: widget.product, quantity: quantity);
                          cart.value.add(cartItem);
                          locator<SnackbarService>()
                              .showSnackbar(message: "Product added to cart");
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
