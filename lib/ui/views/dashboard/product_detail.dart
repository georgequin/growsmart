import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
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
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/mac.png"),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )),
                ),
                Positioned(
                  bottom: 30,
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: const BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Stand a chance to win macbook pro 2020",
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
                  children: List.generate(
                      4,
                      (index) => Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/flip.png")),
                              color: kcWhiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )),
                ),
                verticalSpaceMedium,
                Row(
                  children: const [
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
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "Flipflop",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "\$7.50",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum nec morbi pellentesque lacus, aenean enim diam dolor. Dignissim porttitor magna quis facilisis elit lorem elit arcu. Sit mattis cursus feugiat a a arcu facilisis ipsum tortor. Arcu quisque tincidunt cras vehicula id et vulputate. Ut facilisis viverra nunc tempus. Id ",
                    style: TextStyle(fontSize: 12),
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
                            Container(
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
                            horizontalSpaceSmall,
                            const Text("2"),
                            horizontalSpaceSmall,
                            Container(
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
                            )
                          ],
                        ),
                      ),
                      Container(
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
