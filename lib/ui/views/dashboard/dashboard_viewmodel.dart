import 'package:growsmart/app/app.locator.dart';
import 'package:growsmart/app/app.logger.dart';
import 'package:growsmart/core/data/models/cart_item.dart';
import 'package:growsmart/core/data/models/product.dart';
import 'package:growsmart/core/data/models/raffle_cart_item.dart';
import 'package:growsmart/core/data/repositories/repository.dart';
import 'package:growsmart/core/network/api_response.dart';
import 'package:growsmart/core/utils/local_store_dir.dart';
import 'package:growsmart/core/utils/local_stotage.dart';
import 'package:growsmart/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/data/models/app_notification.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final bool _isDataLoaded = false;
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Product> productList = [];
  List<Raffle> raffleList = [];
  List<Product> sellingFast = [];
  List<Raffle> featuredRaffle = [];


  void changeSelected(int i) {
    selectedIndex = i;
    notifyListeners(); // Notify the UI of changes
    rebuildUi();
  }

  late VideoPlayerController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initialise() {
    controller = VideoPlayerController.asset('assets/videos/dashboard.mp4')
      ..initialize().then((_) {
        controller.setLooping(true);
        controller.play();
        notifyListeners();
      }).onError((error, stackTrace) {
        // Handle the error here
      });
  }

  Future<void> init() async {

    await loadNotifications();
    notifyListeners();
  }


  Future<void> loadNotifications() async {
    dynamic storedNotifications = await locator<LocalStorage>().fetch(LocalStorageDir.notification);
    if (storedNotifications != null) {
      notifications.value = List<Map<String, dynamic>>.from(storedNotifications)
          .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
       getNotifications();
    }
    notifyListeners();
  }

  Future<void> refreshData() async {
    setBusy(true); // Use this to show loading indicator
    getResourceList();
    setBusy(false); // Reset loading indicator after data is refreshed
  }

  void getResourceList(){

    if (userLoggedIn.value == true) {
      getNotifications();
    }
  }

  void getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications(profile.value.id!);
      if (res.statusCode == 200) {
        notifications.value = (res.data["events"] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        List<Map<String, dynamic>> storedNotice = notifications.value.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.notification, storedNotice);
      }
    } catch (e) {
      log.e(e);
    }
  }





  void onEnd() {
    print('onEnd');
    //TODO SEND USER NOTIFICATION OF AVAILABILITY OF PRODUCT
    notifyListeners();
  }

}
