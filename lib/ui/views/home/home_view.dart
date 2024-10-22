import 'dart:ui';

import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import 'home_viewmodel.dart';
import 'module_switch.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    viewModel.checkForUpdates(context);

    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier, // Your ValueNotifier
      builder: (context, currentModule, child) {
        return Scaffold(
          backgroundColor: currentModuleNotifier.value == AppModules.shop
              ? const Color(0xFFFFF3DB)
              : null,
          body: Stack(
            children: [
              viewModel.currentPage, // Assuming you have separate getters for pages in your viewModel

              // Floating Cart Button
              ValueListenableBuilder<List<dynamic>>(
                valueListenable: raffleCart, // Replace with your cart notifier
                builder: (context, cartItems, _) {
                  if (raffleCart.value.isNotEmpty && viewModel.selectedRafflesTab != 3) {

                    // Calculate total number of tickets and total amount
                    int totalTickets = raffleCart.value.fold(0, (sum, item) => sum + (item.quantity ?? 0));
                    // int totalAmount = raffleCart.value.fold(0, (int sum, item) => sum + ((item.quantity ?? 0) * (item.raffle.price ?? 0)).toInt());

                    return Positioned(
                      bottom: 20, // Adjust the value to control how high above the bottom it should be
                      left: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to cart page
                           locator<NavigationService>().navigateToCartView();
                        },
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: kcSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Bag.svg', // Replace with your cart icon
                                    height: 24,
                                    color: kcBlackColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Go to Cart',
                                        style: const TextStyle(
                                          color: kcPrimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${cartItems.length} Raffle, $totalTickets Tickets.',
                                        style: const TextStyle(
                                          color: kcPrimaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      color: kcPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '₦000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(viewModel: viewModel),
        );
      },
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    if(userLoggedIn.value == true){
      viewModel.fetchOnlineCart();
    }
    super.onViewModelReady(viewModel);
  }
}

class BottomNavBar extends StatelessWidget {
  final HomeViewModel viewModel;

  BottomNavBar({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier,
      builder: (context, currentModule, _) {
        Color iconColor = Colors.grey;
        Color selectedColor = kcSecondaryColor;

        List<BottomNavigationBarItem> items = (currentModule == AppModules.raffle)
            ? _rafflesItems(iconColor, selectedColor)
            : _shopItems(iconColor, selectedColor);

        int currentIndex = (currentModule == AppModules.raffle)
            ? viewModel.selectedRafflesTab
            : viewModel.selectedShopTab;

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: uiMode.value == AppUiModes.dark
              ? kcDarkGreyColor // Dark mode logo
              : kcWhiteColor,

          // currentModule == AppModules.shop ? const Color(0xFFFFF3DB) : Colors.white,
          selectedLabelStyle: TextStyle(color: selectedColor),
          selectedItemColor: selectedColor,
          unselectedItemColor: iconColor,
          onTap: (index) => viewModel.changeSelected(index, currentModule),
          currentIndex: currentIndex,
          items: items,
        );
      },
    );
  }

  List<BottomNavigationBarItem> _rafflesItems(Color iconColor, Color selectedColor) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home.svg', 'home_outline.svg', viewModel.selectedRafflesTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('ticket_star.svg', 'ticket_star_outline.svg', viewModel.selectedRafflesTab == 1, iconColor),
        label: "Draws",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('heart.svg', 'heart_outline.svg', viewModel.selectedRafflesTab == 2, iconColor),
        label: "Donate",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('menu.svg', 'menu_outline.svg', viewModel.selectedRafflesTab == 3, iconColor),
        label: "Menu",
      ),
    ];
  }

  List<BottomNavigationBarItem> _shopItems(Color iconColor, Color selectedColor) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home.svg', 'home_outline.svg', viewModel.selectedShopTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('ticket_star.svg', 'ticket_star_outline.svg', viewModel.selectedShopTab == 1, iconColor),
        label: "Draws",
      ),

      BottomNavigationBarItem(
        icon: _navBarItemIcon('notification.svg','notification.svg', viewModel.selectedShopTab == 3, iconColor),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('menu.svg', 'notification.svg', viewModel.selectedShopTab == 4, iconColor),
        label: "Menu",
      ),
    ];
  }


  Widget _navBarItemIcon(String filledIcon, String outlinedIcon, bool isSelected, Color iconColor) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? kcSecondaryColor.withOpacity(0.2) : Colors.transparent,
      ),
      child: SvgPicture.asset(
        'assets/icons/${isSelected ? filledIcon : outlinedIcon}', // Use filledIcon when selected, outlinedIcon when unselected
        height: 16, // Icon size
        color: isSelected ? kcSecondaryColor : iconColor,
      ),
    );
  }


  // Widget _navBarItemWithCounter(String icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
  //   return ValueListenableBuilder<List<dynamic>>(
  //     valueListenable: counterListenable,
  //     builder: (context, value, child) {
  //       return Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           _navBarItemIcon(icon, isSelected, color),
  //           if (value.isNotEmpty)
  //             Positioned(
  //               right: -6,
  //               top: -6,
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.red,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Text(
  //                   '${value.length}',
  //                   style: const TextStyle(color: Colors.white, fontSize: 12),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
