import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:growsmart/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    final Color primaryColor = kcPrimaryColor;
    int rating = 4;

    final List<String> names = [
      'Grid-Tied Solar ',
      'Off-Grid Solar ',
      'Hybrid Solar ',
      'Hybrid Solar ',
      'Hybrid Solar '
    ];

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
        'title': ' Solar Panel',
        'subtitle': 'Mango Boy',
        'price': '44\$',
        'rating': 3,
      },
      // Add more items as needed
    ];


    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search on Easy Power',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // Handle search button press
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 40,
                    ),
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(names.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        viewModel.selectedIndex = index;

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color:  viewModel.selectedIndex == index
                              ? primaryColor
                              : Colors.grey,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          names[index],
                          style: TextStyle(
                            color: viewModel.selectedIndex== index
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Content Card
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: kcPrimaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    // Use Row instead of Column for horizontal scrolling
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Best Full Solar Installation',
                              style: TextStyle(
                                fontSize: 20,
                                color: kcWhiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Light out your world',
                              style: TextStyle(
                                fontSize: 16,
                                color: kcWhiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/Mercury-10KVA-Solar-System-1 2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You’ve never seen it before!',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
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
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < item['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16.0,
                                );
                              }),
                            ),
                            Text(
                              item['subtitle'],
                              style: TextStyle(
                                fontSize: 12,
                                color: kcMediumGrey,
                              ),
                            ),
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item['price'],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  void onDispose(DashboardViewModel viewModel) {
    viewModel.dispose();
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
