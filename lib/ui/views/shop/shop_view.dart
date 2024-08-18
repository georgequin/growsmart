import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:growsmart/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../home/module_switch.dart';
import '../profile/profile_viewmodel.dart';

class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/solarpallete.png',
      'title': 'MG Solar Panel',
      'subtitle': 'OVS',
      'price': '30\$',
      'rating': 4,
    },
    {
      'image': 'assets/images/solarpallete.png',
      'title': 'Total Inverter',
      'subtitle': 'Mango Boy',
      'price': '10\$',
      'rating': 5,
    },
    {
      'image': 'assets/images/solarpallete.png',
      'title': 'Solar Panel',
      'subtitle': 'Mango Boy',
      'price': '44\$',
      'rating': 3,
    },
    {
      'image': 'assets/images/solarpallete.png',
      'title': 'Solar Panel',
      'subtitle': 'Mango Boy',
      'price': '44\$',
      'rating': 3,
    },
  ];

  final _selectedColor = kcPrimaryColor;
  final _unselectedColor = const Color(0xff5f6368);

  final _tabs = const [
    Tab(
      child: FittedBox(child: Text('Solar Energy System')),
    ),
    Tab(
      child: FittedBox(child: Text('Lighting Electronics')),
    ),
    Tab(
      child: FittedBox(child: Text('Services')),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
        viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildBottomSheet(context),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: kcMediumGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child:
                                    // CachedNetworkImage(
                                    //   placeholder: (context, url) => const Center(
                                    //     child: CircularProgressIndicator(
                                    //       strokeWidth: 2.0, // Make the loader thinner
                                    //       valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                    //     ),
                                    //   ),
                                    //   imageUrl: item['image'] ?? 'https://via.placeholder.com/150',
                                    //   height: 182,
                                    //   // width: 90,
                                    //   fit: BoxFit.cover,
                                    //   errorWidget: (context, url, error) => const Icon(Icons.error),
                                    //   fadeInDuration: const Duration(milliseconds: 500),
                                    //   fadeOutDuration: const Duration(milliseconds: 300),
                                    // ),

                                    Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(item['image']),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: 20,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:kcDarkGreyColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [

                                      const Icon(
                                        Icons.star,
                                        color: kcStarColor,
                                        size: 20,
                                      ),
                                      Text(item['rating'].toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors
                                .transparent, // Set the background color to blue
                            padding: const EdgeInsets.symmetric(horizontal:7.0), // Add padding to the container
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item['price'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.8,
                                    color: kcBlackColor, // Set the text color to white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildBottomSheet(BuildContext context) {
  return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 120, // Adjust the height as needed
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          verticalSpaceSmall,
          ModuleSwitch(
            isRafflesSelected: true,
            onToggle: (bool) {},
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal:8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           decoration: InputDecoration(
          //             hintText: 'Filters',
          //             border: InputBorder.none,
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.filter_list_sharp),
          //         onPressed: () {
          //           // Handle search button press
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ));
}
