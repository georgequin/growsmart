// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:growsmart/ui/common/ui_helpers.dart';
// import 'package:stacked/stacked.dart';
// import '../../../core/data/models/product.dart';
// import '../../common/app_colors.dart';
// import '../home/module_switch.dart';
// import '../profile/profile_viewmodel.dart';
// import 'package:top_modal_sheet/top_modal_sheet.dart';
//
//
// class ShopView extends StatefulWidget {
//   const ShopView({Key? key}) : super(key: key);
//
//   @override
//   _ShopViewState createState() => _ShopViewState();
// }
// List<Product> productList = [];
//
// String _topModalData = "";
//
// class _ShopViewState extends State<ShopView>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final List<Map<String, dynamic>> items = [
//     {
//       'image': 'assets/images/solarpallete.png',
//       'title': 'MG Solar Panel',
//       'subtitle': 'OVS',
//       'price': '30\$',
//       'rating': 4,
//     },
//     {
//       'image': 'assets/images/solarpallete.png',
//       'title': 'Total Inverter',
//       'subtitle': 'Mango Boy',
//       'price': '10\$',
//       'rating': 5,
//     },
//     {
//       'image': 'assets/images/solarpallete.png',
//       'title': 'Solar Panel',
//       'subtitle': 'Mango Boy',
//       'price': '44\$',
//       'rating': 3,
//     },
//     {
//       'image': 'assets/images/solarpallete.png',
//       'title': 'Solar Panel',
//       'subtitle': 'Mango Boy',
//       'price': '44\$',
//       'rating': 3,
//     },
//   ];
//
//
//   final _tabs = const [
//     Tab(
//       child: FittedBox(child: Text('Solar Energy System')),
//     ),
//     Tab(
//       child: FittedBox(child: Text('Lighting Electronics')),
//     ),
//     Tab(
//       child: FittedBox(child: Text('Services')),
//     ),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ProfileViewModel>.reactive(
//       viewModelBuilder: () => ProfileViewModel(),
//       onModelReady: (viewModel) {
//         viewModel.getProfile();
//       },
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           body: Column(
//             children: [
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: buildBottomSheet(context),
//               ),
//               MaterialButton(
//                 color: Colors.white,
//                 elevation: 5,
//                 child: const Text("Show TopModel"),
//                 onPressed: () async {
//                   var value =
//                   await showTopModalSheet<String?>(context, DummyModal());
//                   setState(() {
//                     _topModalData = value!;
//                   });
//                 },
//               ),
//               SizedBox(height: 10),
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(8.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0,
//                     childAspectRatio: 0.9,
//                   ),
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     final item = items[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       decoration: BoxDecoration(
//                         color: kcMediumGrey,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius:
//                                 const BorderRadius.all(Radius.circular(12)),
//                                 child:
//                                 // CachedNetworkImage(
//                                 //   placeholder: (context, url) => const Center(
//                                 //     child: CircularProgressIndicator(
//                                 //       strokeWidth: 2.0, // Make the loader thinner
//                                 //       valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
//                                 //     ),
//                                 //   ),
//                                 //   imageUrl: item['image'] ?? 'https://via.placeholder.com/150',
//                                 //   height: 182,
//                                 //   // width: 90,
//                                 //   fit: BoxFit.cover,
//                                 //   errorWidget: (context, url, error) => const Icon(Icons.error),
//                                 //   fadeInDuration: const Duration(milliseconds: 500),
//                                 //   fadeOutDuration: const Duration(milliseconds: 300),
//                                 // ),
//
//                                 Container(
//                                   height: 150,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(15),
//                                       topRight: Radius.circular(15),
//                                     ),
//                                     image: DecorationImage(
//                                       image: AssetImage(item['image']),
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: Container(
//                                   height: 20,
//                                   width: 50,
//                                   decoration: BoxDecoration(
//                                     color: kcDarkGreyColor.withOpacity(0.4),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     children: [
//                                       const Icon(
//                                         Icons.star,
//                                         color: kcStarColor,
//                                         size: 20,
//                                       ),
//                                       Text(item['rating'].toString()),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             color: Colors
//                                 .transparent, // Set the background color to blue
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal:
//                                 7.0), // Add padding to the container
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['title'] ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Text(
//                                   item['price'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13.8,
//                                     color:
//                                     kcBlackColor, // Set the text color to white
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// enum Switch { first, second, third }
//
// Widget buildBottomSheet(BuildContext context) {
//   TabController _tabController = TabController(length: 3, vsync: TickerProviderStateMixin());
//
//   return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       height: 200, // Adjust the height as needed
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           verticalSpaceSmall,
//           ModuleSwitch(
//             isRafflesSelected: true,
//             onToggle: (bool) {
//             },
//           ),
//
//           TabBar(
//             controller: _tabController,
//             tabs: _tabs,
//             indicatorColor: kcPrimaryColor,
//             labelColor: kcPrimaryColor,
//             unselectedLabelColor: const Color(0xff5f6368),
//           ),
//
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Corresponding content for each tab
//                 Center(child: Text('Content for Solar Energy System')),
//                 Center(child: Text('Content for Lighting Electronics')),
//                 Center(child: Text('Content for Services')),
//               ],
//             ),
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal:8.0),
//           //   child: Row(
//           //     children: [
//           //       Expanded(
//           //         child: TextField(
//           //           decoration: InputDecoration(
//           //             hintText: 'Filters',
//           //             border: InputBorder.none,
//           //           ),
//           //         ),
//           //       ),
//           //       IconButton(
//           //         icon: const Icon(Icons.filter_list_sharp),
//           //         onPressed: () {
//           //           // Handle search button press
//           //         },
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ));
// }
//
//
//
// // Widget buildBottomSheet(BuildContext context) {
// //   return AnimatedContainer(
// //     duration: const Duration(milliseconds: 500),
// //     curve: Curves.easeInOut,
// //     height: 120,
// //     padding: const EdgeInsets.all(20),
// //     decoration: const BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black26,
// //           blurRadius: 10,
// //           spreadRadius: 5,
// //         ),
// //       ],
// //     ),
// //     child: Column(
// //       children: [
// //         // Switch between different display modes
// //         ToggleButtons(
// //           isSelected: [
// //             _currentMode == DisplayMode.Switch1,
// //             _currentMode == DisplayMode.Switch2,
// //             _currentMode == DisplayMode.Switch3,
// //           ],
// //           onPressed: (int index) {
// //             setState(() {
// //               _currentMode = DisplayMode.values[index];
// //             });
// //           },
// //           children: const [
// //             Text("Switch 1"),
// //             Text("Switch 2"),
// //             Text("Switch 3"),
// //           ],
// //         ),
// //         // Additional content for the bottom sheet (e.g., filters)
// //         const SizedBox(height: 10),
// //       ],
// //     ),
// //   );
// // }
//
// void setState(Null Function() param0) {
// }
//
//
// class DummyModal extends StatelessWidget {
//   const DummyModal({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: kcWhiteColor,
//       height: 450,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               verticalSpaceLarge,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {},
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.grey.shade200,
//                       backgroundImage: AssetImage('assets/images/profile.png'),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Balance:',
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                           horizontalSpaceSmall,
//                           Text(
//                             '\$10,000',
//                             style: TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Installment:',
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                           horizontalSpaceSmall,
//                           Text(
//                             '\$10,000',
//                             style: TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               verticalSpaceMedium,
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.grey.shade600,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildItem('Full Solar  Energy System', true ,false),
//                       _buildItem('Solar Panels', false, false),
//                       _buildItem('Inverters ',false, false),
//                       _buildItem('Battery Storage', false, true),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItem(String title, bool isFirst, bool isLast) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: isFirst ? Radius.circular(20.0) : Radius.zero,
//           topRight: isFirst ? Radius.circular(20.0) : Radius.zero,
//           bottomLeft: isLast ? Radius.circular(20.0) : Radius.zero,
//           bottomRight: isLast ? Radius.circular(20.0) : Radius.zero,
//         ),
//         border: Border.all(
//           color: Colors.grey.shade300,
//           width: 1.0,
//         ),
//       ),
//       child: ListTile(
//         title: Text(
//           title,
//           style: TextStyle(fontSize: 14), // Make the font size smaller
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:growsmart/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import '../../../core/data/models/product.dart';
import '../../common/app_colors.dart';
import '../home/module_switch.dart';
import '../profile/profile_viewmodel.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';




class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}
bool isSelected = false;
enum categories {solarEnergy, electronics, services}

List<Product> productList = [];
String _topModalData = "";

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


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
       // viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildBottomSheet(context, _tabController),
              ),
              MaterialButton(
                color: Colors.white,
                elevation: 5,
                child: const Text("Show TopModal"),
                onPressed: () async {
                  var value =
                  await showTopModalSheet<String?>(context, DummyModal());
                  setState(() {
                    _topModalData = value!;
                  });
                },
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
                                child: Container(
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
                                    color: kcDarkGreyColor.withOpacity(0.4),
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
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 7.0),
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
                                    color: kcBlackColor,
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


void _showDummyModal(BuildContext context) async {
  var value = await showTopModalSheet<String?>(context, const DummyModal());
  print('Modal closed with value: $value');
}


Widget buildBottomSheet(BuildContext context, TabController tabController) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    height: 120,
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
          isRafflesSelected: isSelected,
          onToggle: (isSelected) {
            isSelected = true;

            print('call topbotton $isSelected');

            if (isSelected) {
              _showDummyModal(context);
            }
          },
        ),
      ],
    ),
  );
}
class DummyModal extends StatelessWidget {
  const DummyModal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kcWhiteColor,
      height: 450,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              verticalSpaceLarge,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Balance:',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Text(
                            '\$10,000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Installment:',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Text(
                            '\$10,000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade600,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      _buildItem('Full Solar  Energy System', true ,false),
                      _buildItem('Solar Panels', false, false),
                      _buildItem('Inverters ',false, false),
                      _buildItem('Battery Storage', false, true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildItem(String title, bool isFirst, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(20.0) : Radius.zero,
          topRight: isFirst ? Radius.circular(20.0) : Radius.zero,
          bottomLeft: isLast ? Radius.circular(20.0) : Radius.zero,
          bottomRight: isLast ? Radius.circular(20.0) : Radius.zero,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14), // Make the font size smaller
        ),
      ),
    );
  }
}
