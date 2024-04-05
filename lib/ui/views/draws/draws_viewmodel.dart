import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';

class DrawsViewModel extends BaseViewModel {
  // Example data lists
  List<Raffle> pastDraws = [];
  List<Raffle> soldOutDraws = [];
  List<Winner> winners = [];


  Future<void> refreshData() async {
    setBusy(true); // Use this to show loading indicator
    getResourceList();
    setBusy(false); // Reset loading indicator after data is refreshed
  }

  void getResourceList(){
    getSoldOuts();
    getWinners();
    getPastDraws();
  }

  Future<void> init() async {
    await loadSoldOuts();
    await loadWinners();
    await loadPastDraws();
    notifyListeners();
  }

  Future<void> loadSoldOuts() async {
    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.soldOut);
    if (storedRaffle != null) {
      soldOutDraws = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
      getSoldOuts();
      notifyListeners();
    }
  }

  Future<void> loadWinners() async {
    dynamic storedWinner = await locator<LocalStorage>().fetch(LocalStorageDir.winners);
    if (storedWinner != null) {
      winners = List<Map<String, dynamic>>.from(storedWinner)
          .map((e) => Winner.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
      getWinners();
      notifyListeners();
    }
  }

  Future<void> loadPastDraws() async {
    dynamic storedPastDraws = await locator<LocalStorage>().fetch(LocalStorageDir.pastDraws);
    if (storedPastDraws != null) {
      pastDraws = List<Map<String, dynamic>>.from(storedPastDraws)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } else {
      getPastDraws();
      notifyListeners();
    }
  }

  void getSoldOuts() async {
    setBusyForObject(soldOutDraws, true);
    try {
      ApiResponse res = await repo.getSoldOutRaffle();
      if (res.statusCode == 200) {
        soldOutDraws = (res.data["raffle"] as List).map((e) => Raffle.fromJson(Map<String, dynamic>.from(e))).toList();
        List<Map<String, dynamic>> storedRaffles = soldOutDraws.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.soldOut, storedRaffles);
        rebuildUi();
      }
    } catch (e) {
      print(e);
    }
    setBusyForObject(soldOutDraws, false);
  }

  void getPastDraws() async {
    setBusyForObject(pastDraws, true);
    try {
      ApiResponse res = await repo.getSoldOutRaffle();
      if (res.statusCode == 200) {
        var allDraws = (res.data["raffle"] as List).map((e) => Raffle.fromJson(Map<String, dynamic>.from(e))).toList();

        // Filter draws to include only those with end-date after today's date
        pastDraws = allDraws.where((draw) {
          DateTime endDate = DateTime.parse(draw.endDate!);
          return endDate.isAfter(DateTime.now());
        }).toList();

        List<Map<String, dynamic>> pastRaffles = pastDraws.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.pastDraws, pastRaffles);
        rebuildUi();
      }
    } catch (e) {
      print(e);
    }
    setBusyForObject(pastDraws, false);
  }

  void getWinners() async {
    setBusyForObject(winners, true);

    try {
      ApiResponse res = await repo.getRaffleResult();
      if (res.statusCode == 200) {
        print('log res just before updating: ${res.data['winners']}');
        // print('entry raw value ${res.data['winners'].json('entry')}');
        winners = (res.data['winners'] as List).map((json) => Winner.fromJson(json)).toList();
        print('log res just after updating: ${res.data['winners']}');
        List<Map<String, dynamic>> storedWinner = winners.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.winners, storedWinner);
        rebuildUi();

      }
    } catch (e) {
      print(e);
    }
    setBusyForObject(winners, false);
  }

}
