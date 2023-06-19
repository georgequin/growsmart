import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: viewModel.pages[viewModel.selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(color: kcSecondaryColor),
        selectedItemColor: kcSecondaryColor,
        onTap: viewModel.changeSelected,
        currentIndex: viewModel.selectedTab,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/app_home.png",
              color:
                  viewModel.selectedTab == 0 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/draws.png",
              color:
                  viewModel.selectedTab == 1 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Draws",
          ),
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cart,
              builder: (context, value, child) => Badge(
                isLabelVisible: value.isEmpty ? false : true,
                label: Text("${value.length}"),
                child: Image.asset(
                  "assets/images/cart.png",
                  color: viewModel.selectedTab == 2
                      ? kcSecondaryColor
                      : kcBlackColor,
                ),
              ),
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/notification.png",
              color:
                  viewModel.selectedTab == 3 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/profile.png",
              color:
                  viewModel.selectedTab == 4 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Profile",
          )
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
