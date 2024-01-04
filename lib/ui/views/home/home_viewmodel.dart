import 'package:afriprize/app/app.bottomsheets.dart';
import 'package:afriprize/app/app.dialogs.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/app_strings.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/cart/cart_view.dart';
import 'package:afriprize/ui/views/dashboard/dashboard_view.dart';
import 'package:afriprize/ui/views/notification/notification_view.dart';
import 'package:afriprize/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../state.dart';
import '../../common/ui_helpers.dart';
import '../draws/draws_view.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  List<Widget> pages = [
     DashboardView(),
    const DrawsView(),
    const CartView(),
    const NotificationView(),
    const ProfileView()
  ];

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;
  int selectedTab = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void changeSelected(int i) {
    if (i != 0 && !userLoggedIn.value) {
      showModalBottomSheet(
          context: StackedService.navigatorKey!.currentState!.context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          builder: (ctx) {
            return Container(
              padding: const EdgeInsets.all(30),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You need to login to continue"),
                  verticalSpaceMedium,
                  SubmitButton(
                    isLoading: false,
                    label: "Login",
                    submit: () {
                      locator<NavigationService>().replaceWithAuthView();
                    },
                    color: kcPrimaryColor,
                  )
                ],
              ),
            );
          });
      return;
    }
    selectedTab = i;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
