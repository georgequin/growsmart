import 'dart:io';

import 'package:afriprize/app/app.bottomsheets.dart';
import 'package:afriprize/app/app.dialogs.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/utils/config.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/app_strings.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/cart/raffle_cart_view.dart';
import 'package:afriprize/ui/views/cart/shop_cart_view.dart';
import 'package:afriprize/ui/views/dashboard/dashboard_view.dart';
import 'package:afriprize/ui/views/dashboard/shop_dashboard_view.dart';
import 'package:afriprize/ui/views/notification/notification_view.dart';
import 'package:afriprize/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:update_available/update_available.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';
import '../../common/ui_helpers.dart';
import '../draws/draws_view.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

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

  int selectedRafflesTab = 0;
  int selectedShopTab = 0;

  @override
  void dispose() {
    // Don't forget to remove the listener when the view model is disposed.
    currentModuleNotifier.removeListener(notifyListeners);
    super.dispose();
  }



  // Pages for the Raffles dashboard
  List<Widget> rafflesPages = [
    DashboardView(),
     const DrawsView(),
    const NotificationView(),
    const ProfileView()
  ];

  // Pages for the Shop dashboard
  List<Widget> shopPages = [
    ShopDashboardView(),
     const DrawsView(),
    const ShopCartView(),
    const NotificationView(),
    const ProfileView()
  ];

  HomeViewModel() {
    currentModuleNotifier.addListener(notifyListeners);
  }


  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;
  int selectedTab = 0;

  AppModules selectedModule = AppModules.raffle;

  // void toggleModule(bool isRafflesSelected) {
  //   selectedModule = isRafflesSelected ? AppModules.raffle : AppModules.shop;
  //   notifyListeners();
  // }

  void toggleModule(bool isRafflesSelected) {
    currentModuleNotifier.value = isRafflesSelected ? AppModules.raffle : AppModules.shop;
    notifyListeners();
  }

  //for test
  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void changeSelected(int index, AppModules module) {
    if (index != 0 && !userLoggedIn.value) {
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
    if (module == AppModules.raffle) {
      selectedRafflesTab = index;
    } else {
      selectedShopTab = index;
    }
    notifyListeners();
  }


  Widget get currentPage {
    return currentModuleNotifier.value == AppModules.raffle
        ? rafflesPages[selectedRafflesTab]
        : shopPages[selectedShopTab];
  }

  void _showDialog() {
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

  Future<void> checkForUpdates(BuildContext context) async {
    final availability = await getUpdateAvailability();
    if (availability is UpdateAvailable) {
      showUpdateCard(context);
    }
  }

  void showUpdateCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/update.svg',
                  height: 94,
                ),
                const ListTile(
                  title: Text('App Updates', style: TextStyle(fontSize: 22,
                    fontFamily: "Panchang", fontWeight: FontWeight.bold, color: kcSecondaryColor)),
                  subtitle: Text('A new version of Afriprize is now available.'
                      ' download now to enjoy our lastest features.', style: TextStyle(fontSize: 13,
                    fontFamily: "Panchang",)),
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kcSecondaryColor)),
                      onPressed: () {
                        Platform.isIOS ? _launchURL(AppConfig.APPLESTOREURL) : _launchURL(AppConfig.GOOGLESTOREURL);
                        Navigator.pop(context);
                      },
                      child: const Text('Update Now', style: TextStyle(
                          fontFamily: "Panchang", fontWeight: FontWeight.bold, color: kcWhiteColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> fetchOnlineCart() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.cartList();
      if (res.statusCode == 200) {
        // Access the 'items' from the response 'data'
        List<dynamic> items = res.data["data"]["items"];

        print('online cart is:  $items');

        // Map the items list to List<RaffleCartItem>
        List<RaffleCartItem> onlineItems = items
            .map((item) => RaffleCartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();

        // Sync online items with the local cart
        raffleCart.value = onlineItems;

        // Update local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to load cart from server: $e");
    } finally {
      setBusy(false);
    }
  }
}
