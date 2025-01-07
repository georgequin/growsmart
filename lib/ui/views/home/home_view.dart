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

        List<BottomNavigationBarItem> items = nav_Items(iconColor, selectedColor);


        int currentIndex = viewModel.selectedTab;

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: uiMode.value == AppUiModes.dark
              ? kcDarkGreyColor // Dark mode logo
              : kcWhiteColor,

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

  List<BottomNavigationBarItem> nav_Items(Color iconColor, Color selectedColor) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home.svg', 'home_outline.svg', viewModel.selectedTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('shopicon.svg', 'shopicon.svg', viewModel.selectedTab == 1, iconColor),
        label: "Shop",
      ),
      BottomNavigationBarItem(
          icon: _navBarItemWithCounter('buy.svg', 'buy.svg',  viewModel.selectedTab == 2, cart, iconColor),
          label: "Cart",
          ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('engineering.svg', 'engineering.svg', viewModel.selectedTab == 3, iconColor),
        label: "Services",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('menu.svg', 'menu_outline.svg', viewModel.selectedTab == 4, iconColor),
        label: "Profile",
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

  Widget _navBarItemWithCounter(String icon, String filledIcon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
    return ValueListenableBuilder<List<dynamic>>(
        valueListenable: counterListenable,
        builder: (context, value, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _navBarItemIcon(filledIcon, icon, isSelected, color),
              if (value.isNotEmpty)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${value.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          );
          },
        );
    }

}
