import 'package:afriprize/core/data/models/app_notification.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:flutter/foundation.dart';
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
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: uiMode,
        builder: (context, AppUiModes mode, child) {
          Color iconColor = mode == AppUiModes.dark ? Colors.white : Colors.black;
          Color selectedColor = mode == AppUiModes.dark ? Colors.white : kcSecondaryColor;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: mode == AppUiModes.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
            selectedLabelStyle: TextStyle(color: selectedColor),
            selectedItemColor: selectedColor,
            unselectedItemColor: iconColor,
            onTap: viewModel.changeSelected,
            currentIndex: viewModel.selectedTab,
            items: [
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.home_outlined, "Home", viewModel.selectedTab == 0, iconColor),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.bar_chart_outlined, "Draws", viewModel.selectedTab == 1, iconColor),
                label: "Draws",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemWithCounter(Icons.shopping_cart_outlined, viewModel.selectedTab == 2, cart, iconColor),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemWithCounter(Icons.notifications_none, viewModel.selectedTab == 3, notifications, iconColor),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.person_outline, "Profile", viewModel.selectedTab == 4, iconColor),
                label: "Profile",
              ),
            ],
          );
        },
      ),
    );


  }

  Widget _navBarItemIcon(IconData iconData, String label, bool isSelected, Color iconColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? kcSecondaryColor.withOpacity(0.2) : Colors.transparent,
      ),
      child: Icon(
        iconData,
        color: isSelected ? kcSecondaryColor : iconColor,
      )
    );
  }

  Widget _navBarItemWithCounter(IconData icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: counterListenable,
      builder: (context, value, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _navBarItemIcon(icon, '', isSelected, color),
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

  @override
  HomeViewModel viewModelBuilder(
      BuildContext context,
      ) =>
      HomeViewModel();
}
