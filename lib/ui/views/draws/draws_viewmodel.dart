import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';

class DrawsViewModel extends BaseViewModel {

  bool isDrawSelected = true;
  // Example data lists
  List<Raffle> raffleList = [];
  List<Raffle> filteredRaffle = [];
  String searchQuery = '';

  void togglePage(bool isDraw) {
    isDrawSelected = isDraw;
    notifyListeners(); // This ensures the UI rebuilds
  }


  Future<void> refreshData() async {
    setBusy(true); // Use this to show loading indicator
    getResourceList();
    setBusy(false); // Reset loading indicator after data is refreshed
  }

  void getResourceList(){
    getRaffles();
  }

  Future<void> init() async {
    await loadRaffles();
    notifyListeners();
  }



  Future<void> loadRaffles() async {
    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    if (storedRaffle != null) {
      raffleList = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      filteredRaffle = raffleList;
      notifyListeners();
    } else {
      getRaffles();
      notifyListeners();
    }
  }

  void getRaffles() async {
    setBusyForObject(raffleList, true);
    try {
      ApiResponse res = await repo.getRaffle();
      if (res.statusCode == 200) {
        // Check if 'items' exists and is not null
        print('res.data: ${res.data}');
        print('res.data: ${res.data["data"]}');
        print('res.data: ${res.data["data"]["items"]}');
        if (res.data != null && res.data["data"]["items"] != null) {
          // Extract raffles from 'items'
          raffleList = (res.data["data"]["items"] as List)
              .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e['raffle'])))
              .toList();
          List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);
          filteredRaffle = raffleList;
        } else {
          // Handle empty or null 'items' response here, e.g., set raffleList to empty
          raffleList = [];
        }
        rebuildUi();
      }
    } catch (e) {
      print(e);
    }
    setBusyForObject(raffleList, false);
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    if (searchQuery.isEmpty) {
      filteredRaffle = raffleList;
    } else {
      filteredRaffle = raffleList.where((service) {
        return service.name!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            service.description!.toLowerCase().contains(searchQuery.toLowerCase())
            ||
            service.formattedTicketPrice!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

}
