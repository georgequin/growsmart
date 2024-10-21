import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/models/project.dart';

class DashboardViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final bool _isDataLoaded = false;
  int selectedIndex = 0;
  final log = getLogger("DashboardViewModel");
  List<Raffle> raffleList = [];
  List<Project> projects = [];
  List<Ads> adsList = [];
  List<ProjectResource> projectResources = [];
  List<Raffle> featuredRaffle = [];

  bool? onboarded;

  bool showDialog = true;  // Controls when to show the modal
  bool modalShown = false; // Flag to track if the modal was shown
  bool appBarLoading = false;
  bool shouldShowShowcase = true;  // Controls when to show showcase


  @override
  void initialise() {
    init();
  }

  bool showcaseShown = false; // Track whether the showcase has been shown
  void setShowcaseShown(bool value) {
    showcaseShown = value;
    notifyListeners();
  }

  void changeSelected(int i) {
    selectedIndex = i;
    rebuildUi();
  }


  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }


  Future<void> init() async {
    setBusy(true);
    onboarded = await locator<LocalStorage>().fetch(LocalStorageDir.onboarded) ?? false;
    if (!onboarded!) {
      showDialog = true; // Show modal if not onboarded
    }
    notifyListeners();
    await loadRaffles();
    await loadAds();
    // await loadProducts();
     await loadProjects();
    if (userLoggedIn.value == true) {
      initCart();
      await getNotifications();
      await getProfile();
    }
    setBusy(false);
    notifyListeners();
  }


  Future<void> loadRaffles() async {

    if (raffleList.isEmpty) {
      setBusy(true);
      notifyListeners();
    }

    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    if (storedRaffle != null) {
      // Extracting and filtering only active raffles
      raffleList = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .where((raffle) => raffle.status == "ACTIVE")
          .toList();
      notifyListeners();
    }

    await getRaffles();
    setBusy(false);
    notifyListeners();

  }

  Future<void> loadAds() async {

    if (raffleList.isEmpty) {
      setBusy(true);
      notifyListeners();
    }

    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    // if (storedRaffle != null) {
    //   // Extracting and filtering only active raffles
    //   raffleList = List<Map<String, dynamic>>.from(storedRaffle)
    //       .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
    //       .where((raffle) => raffle.status == "ACTIVE")
    //       .toList();
    //   notifyListeners();
    // }

    await getAds();
    setBusy(false);
    notifyListeners();

  }

  Future<void> loadWinners() async {

    if (raffleList.isEmpty) {
      setBusy(true);
      notifyListeners();
    }

    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    if (storedRaffle != null) {
      // Extracting and filtering only active raffles
      raffleList = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .where((raffle) => raffle.status == "ACTIVE")
          .toList();
      notifyListeners();
    }

    await getRaffles();
    setBusy(false);
    notifyListeners();

  }

  Future<void> loadProjects() async {
    if (projectResources.isEmpty) {
      setBusy(true);
      notifyListeners();
    }

    dynamic storedProjectResources = await locator<LocalStorage>().fetch(LocalStorageDir.projectResource);
    if (storedProjectResources != null) {
      projectResources = List<Map<String, dynamic>>.from(storedProjectResources)
          .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    await getProjects();
    setBusy(false);
    notifyListeners();
  }

  Future<void> refreshData() async {
    setBusy(true);
    notifyListeners();
    getResourceList();
    setBusy(false);
    notifyListeners();
  }

  void getResourceList(){
    getRaffles();
    getProjects();
    getAds();
    if (userLoggedIn.value == true) {
      initCart();
       getNotifications();
    }
  }

  Future<void> getRaffles() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse res = await repo.getRaffle();
      if (res.statusCode == 200) {
        if (res.data != null && res.data["data"]["items"] != null) {
          raffleList = (res.data["data"]["items"] as List)
              .map((e) {
            final raffle = Raffle.fromJson(Map<String, dynamic>.from(e['raffle']));
            final participants = (e['participants'] as List?)?.map((participant) => Participant.fromJson(Map<String, dynamic>.from(participant))).toList();
            raffle.participants = participants;
            return raffle;
          })
              .where((raffle) => raffle.status == "ACTIVE")
              .toList();

          // Store raffles locally
          List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);
          notifyListeners();
        }
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
    print('raffle list is: $raffleList');
  }


  Future<void> getAds() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse res = await repo.getAds();
      if (res.statusCode == 200) {
        if (res.data != null && res.data["data"]["items"] != null) {
          adsList = (res.data["data"]["items"] as List)
              .map((e) => Ads.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // Save ads to local storage if needed
          List<Map<String, dynamic>> storedAds = adsList.map((e) => e.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.ads, storedAds);
          notifyListeners();
        }
      }
    } catch (e) {
      log.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> getProjects() async {
    setBusy(true);
    notifyListeners();
    try {
      ApiResponse res = await repo.getProjects();

      if (res.statusCode == 200) {

        if (res.data != null && res.data["data"]["items"] != null) {

          projectResources = (res.data["data"]["items"] as List)
              .map((e) => ProjectResource.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          projects = projectResources.map((resource) => resource.project!).toList();
          List<Map<String, dynamic>> storedProjects = projects.map((e) => e.toJson()).toList();
          List<Map<String, dynamic>> storedProjectResources = projectResources.map((resource) => resource.toJson()).toList();

          locator<LocalStorage>().save(LocalStorageDir.projectResource, storedProjectResources);
          locator<LocalStorage>().save(LocalStorageDir.projects, storedProjects);
          notifyListeners();
        }
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }finally{
      setBusy(false);
      notifyListeners();
    }

  }

  Future<void> getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications();
      if (res.statusCode == 200) {
        notifications.value = (res.data['data']['items'] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        unreadCount.value = notifications.value.where((n) => n.unread).length;
        notifyListeners();
      }
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await repo.markNotificationAsRead();
      notifications.value.forEach((n) => n.unread = false);
      unreadCount.value--;
      notifyListeners();
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> getProfile() async {
    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data['data']));
        await locator<LocalStorage>().save(LocalStorageDir.profileView, res.data["data"]);
        notifyListeners();
        print(profile.value.accountPoints);
      }
    } catch (e) {
      throw Exception(e);
    }
  }




  void addToRaffleCart(Raffle raffle) async {
    setBusy(true);
    notifyListeners();
    try {
      final existingItem = raffleCart.value.firstWhere(
            (raffleItem) => raffleItem.raffle?.id == raffle.id,
        orElse: () => RaffleCartItem(raffle: raffle, quantity: 0),
      );

      if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.raffle != null) {
        existingItem.quantity = (existingItem.quantity! + 1);
      } else {
        existingItem.quantity = 1;
        raffleCart.value.add(existingItem);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);

      // Save to online cart using API
      final response = await repo.addToCart({
        "raffle": raffle.id,
        "quantity": existingItem.quantity,
      });

      if (response.statusCode == 201) {
        locator<SnackbarService>().showSnackbar(message: "Raffle added to cart", duration: Duration(seconds: 2));
      } else {
        locator<SnackbarService>().showSnackbar(message: response.data["message"], duration: Duration(seconds: 2));
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to add raffle to cart: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }
  
  void initCart() async {
    dynamic raffle = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<RaffleCartItem> localRaffleCart = List<Map<String, dynamic>>.from(raffle)
        .map((e) => RaffleCartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    raffleCart.value = localRaffleCart;
    raffleCart.notifyListeners();
  }
  
  Future<void> decreaseRaffleQuantity(RaffleCartItem item) async {
    setBusy(true);
    try {
      if (item.quantity! > 1) {
        item.quantity = item.quantity! - 1;

        // Update online cart
        await repo.addToCart({
          "raffle": item.raffle?.id,
          "quantity": item.quantity,
        });
      } else if (item.quantity! == 1) {
        // Remove from local cart
        raffleCart.value.removeWhere((cartItem) => cartItem.raffle?.id == item.raffle?.id);

        // Remove from online cart
        await repo.deleteFromCart(item.raffle!.id!);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to decrease raffle quantity: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }
  
  Future<void> increaseRaffleQuantity(RaffleCartItem item) async {
    setBusy(true);
    try {
      item.quantity = item.quantity! + 1;
      int index = raffleCart.value.indexWhere((raffleItem) => raffleItem.raffle?.id == item.raffle?.id);
      if (index != -1) {
        raffleCart.value[index] = item;
        raffleCart.value = List.from(raffleCart.value);

        // Update online cart
        await repo.addToCart({
          "raffle": item.raffle?.id,
          "quantity": item.quantity,
        });

        // Save to local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to increase raffle quantity: $e", duration: Duration(seconds: 2));
      log.e(e);
    } finally {
      setBusy(false);
      raffleCart.notifyListeners();
    }
  }




  String formatRemainingTime(DateTime drawDate) {
    final now = DateTime.now();
    final difference = drawDate.difference(now);
    // Format the Duration to your needs
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }



  void onEnd() {
    print('onEnd');
    //TODO SEND USER NOTIFICATION OF AVAILABILITY OF PRODUCT
    notifyListeners();
  }

}
