import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_power/ui/common/app_colors.dart';
import 'package:easy_power/ui/common/ui_helpers.dart';
import 'package:easy_power/ui/components/submit_button.dart';
import '../dashboard/dashboard_viewmodel.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

import 'cart.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  final DashboardViewModel viewModel = DashboardViewModel();
  String selectedImage = 'assets/images/Mercury-10KVA-Solar-System-1 2.png';
  late TabController _tabController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    viewModel.init();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void updateImage(String imagePath) {
    setState(() {
      selectedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = kcPrimaryColor;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          children: [
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: buildBottomSheet(context, _tabController),
            //),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Define the action when the avatar is tapped
                    },
                    child:
                        Icon(Icons.arrow_back, size: 25, color: Colors.black),
                  ),
                  const Text(
                    'Full System',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    softWrap: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        horizontalSpaceSmall,
                        GestureDetector(
                          onTap: () {
                            // Define the action when the share icon is tapped
                          },
                          child:
                              Icon(Icons.share, size: 25, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                updateImage('assets/images/innverter.png'),
                            child: buildImageContainer(
                                'assets/images/innverter.png', 80, 80),
                          ),
                          verticalSpaceLarge,
                          GestureDetector(
                            onTap: () =>
                                updateImage('assets/images/powerCable.png'),
                            child: buildImageContainer(
                                'assets/images/powerCable.png', 80, 80),
                          ),
                          verticalSpaceLarge,
                          GestureDetector(
                            onTap: () =>
                                updateImage('assets/images/solarpanals.png'),
                            child: buildImageContainer(
                                'assets/images/solarpanals.png', 80, 80),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 275,
                        height: 345,
                        decoration: BoxDecoration(
                          color:
                              Color(0xFFDADADA).withOpacity(0.5), // 50% opacity
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          selectedImage,
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HK Full Installation',
                        style: TextStyle(
                          fontSize: 20,
                          color: kcBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Define the action when the avatar is tapped
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            child: Icon(Icons.favorite_border_outlined,
                                size: 25, color: Colors.black),
                            radius: 18,
                            backgroundColor: kcWhiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to the start
                              children: const [
                                Text(
                                  'mk solar panels, ua inverter,',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                  softWrap: true,
                                ),
                                Text(
                                  'total inverter battery, cables',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '\$19.99',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        softWrap: true,
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors
                              .grey, // Replace kcPrimaryColor with your color
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ItemCount(
                                  initialValue: 0,
                                  minValue: 0,
                                  maxValue: 10,
                                  decimalPlaces: 0,
                                  onChanged: (value) {
                                    // Handle counter value changes
                                    print('Selected value: $value');
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  buildBottomSheetInstallment(
                                                      context,
                                                      _tabController,
                                                      viewModel),
                                              isScrollControlled:
                                                  true, // Optional if you want it to be scrollable
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: kcWhiteColor,
                                            backgroundColor:
                                                Colors.grey, // Text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Rounded corners
                                            ),
                                          ),
                                          child: Text(
                                            'Pay Installment',
                                            style: TextStyle(
                                              fontSize: 12, // Text size
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 145, // Set the width
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CartPageView(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: kcWhiteColor,
                                      backgroundColor:
                                          kcPrimaryColor, // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                    ),
                                    child: Text(
                                      'Add to cart',
                                      style: TextStyle(
                                        fontSize: 14, // Text size
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpaceSmall,
                                SizedBox(
                                  width: 145, // Set the width
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => buildBottomSheet(
                                            context, _tabController),
                                        isScrollControlled:
                                            true, // Optional if you want it to be scrollable
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: kcWhiteColor,
                                      backgroundColor:
                                          kcPrimaryColor, // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                    ),
                                    child: Text(
                                      'Purchase',
                                      style: TextStyle(
                                        fontSize: 14, // Text size
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      dense: true,
                      visualDensity:
                          VisualDensity(vertical: -4), // Reduce vertical space
                      title: Text(
                        "Item details",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                      ), // Add a next icon at the end
                    ),
                    ListTile(
                      dense: true,
                      visualDensity:
                          VisualDensity(vertical: -4), // Reduce vertical space
                      title: Text(
                        "shipping info",
                        style: TextStyle(
                            fontSize: 12), // Make the font size smaller
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                      ), // Add a next icon at the end
                    ),
                    ListTile(
                      dense: true, // Make the ListTile compact
                      visualDensity:
                          VisualDensity(vertical: -4), // Reduce vertical space
                      title: Text(
                        "support",
                        style: TextStyle(
                            fontSize: 12), // Make the font size smaller
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                      ), // Add a next icon at the end
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You can also like this',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '12 items',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 0.9,
              ),
              itemCount: viewModel.productList.length,
              itemBuilder: (context, index) {
                final item = viewModel.productList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kcSecondaryColor),
                                ),
                              ),
                              imageUrl: item.images?.first ??
                                  'https://via.placeholder.com/120',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: kcDarkGreyColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    item.rating?.toString() ?? "0.0",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      item.productName ?? '',
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(width: 2),
                        Text(
                          item.productName ?? '',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer(String imagePath, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}

class IndicatorDot extends StatelessWidget {
  final bool isActive;

  const IndicatorDot({Key? key, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isActive ? 10.0 : 8.0,
      height: isActive ? 10.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? kcPrimaryColor : kcMediumGrey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}

Widget buildBottomSheet(BuildContext context, TabController tabController) {
  return Container(
      height: 420,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Heading
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(
              'Select Recommended Service\nIf you require any of these services',
              textAlign: TextAlign.center, // Center the text
              style: const TextStyle(
                fontSize: 12,
                color: kcLightGrey,
              ),
            ),
          ),
        ),
        // Service List
        Expanded(
          child: ListView(
            children: [
              // Service 1
              buildServiceItem(
                'assets/images/girl.png',
                'Site Suitability Evaluation',
                '\$29.99',
              ),
              buildServiceItem(
                'assets/images/girl.png',
                'Panel Cleaning',
                '\$19.99',
              ),
              buildServiceItem(
                'assets/images/girl.png',
                'Inverter Installation',
                '\$39.99',
              ),
            ],
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter your promo code',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward, size: 25, color: Colors.black),
            ),
          ],
        ),
        Center(
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        verticalSpaceMedium,
        SubmitButton(
          isLoading: false,
          boldText: true,
          label: "CHECK OUT",
          submit: () {},
          color: kcPrimaryColor,
        ),
      ]));
}

Widget buildBottomSheetInstallment(BuildContext context,
    TabController tabController, DashboardViewModel viewModel) {
  return Container(
      height: 500,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Installation Form',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        verticalSpaceMedium,
        Container(
          height: 340,
          color: kcLightGrey,
        ),
        verticalSpaceMedium,
        InkWell(
          onTap: viewModel.toggleTerms,
          child: Row(
            children: [
              Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: viewModel.terms
                          ? kcSecondaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: viewModel.terms
                              ? Colors.transparent
                              : kcSecondaryColor)),
                  child: viewModel.terms
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            color: kcBlackColor,
                            size: 14,
                          ),
                        )
                      : const SizedBox()),
              horizontalSpaceSmall,
              const Text(
                "Agree with the Conditions",
                style: TextStyle(
                    fontSize: 14,),
              )
            ],
          ),
        ),
      ]));
}

Widget buildServiceItem(String imagePath, String serviceName, String price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Service Image
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Service Name and Price
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 3-dots Icon
        GestureDetector(
          onTap: () {
            // Handle more options
          },
          child: const Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
