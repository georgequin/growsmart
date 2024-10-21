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
  List<Winner> raffleWinnerList = [];
  List<DrawEvent> raffleDrawEvents = [];
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
    getRafflesWinners();
    getDrawEvents();
  }

  Future<void> init() async {
    setBusy(true);  // Show shimmer
    await loadRaffles();
    await loadRafflesWinners();
    await loadDrawsEvent();
    setBusy(false);  // Hide shimmer
  }




  Future<void> loadRaffles() async {
    dynamic storedRaffle = await locator<LocalStorage>().fetch(LocalStorageDir.raffle);
    if (storedRaffle != null) {
      raffleList = List<Map<String, dynamic>>.from(storedRaffle)
          .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      filteredRaffle = raffleList;

      List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
      locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);

      notifyListeners();
    }

      await getRaffles();
      notifyListeners();

  }

  Future<void> loadDrawsEvent() async {
    dynamic storedRaffleDrawsEvent = await locator<LocalStorage>().fetch(LocalStorageDir.drawsEvent);
    if (storedRaffleDrawsEvent != null) {
      raffleDrawEvents = List<Map<String, dynamic>>.from(storedRaffleDrawsEvent)
          .map((e) => DrawEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();

    }

    await getDrawEvents();
    notifyListeners();
  }

  Future<void> loadRafflesWinners() async {
    dynamic storedRaffleWinners = await locator<LocalStorage>().fetch(LocalStorageDir.winners);
    if (storedRaffleWinners != null) {
      raffleWinnerList = List<Map<String, dynamic>>.from(storedRaffleWinners)
          .map((e) => Winner.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      notifyListeners();

    }

    await getRafflesWinners();
    notifyListeners();
  }

  Future<void> getRaffles() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.getRaffle();
      if (res.statusCode == 200) {

        if (res.data != null && res.data["data"]["items"] != null) {
          // Extract raffles from 'items'
          raffleList = (res.data["data"]["items"] as List)
              .map((e) {
            final raffle = Raffle.fromJson(Map<String, dynamic>.from(e['raffle']));
            final participants = (e['participants'] as List?)?.map((participant) => Participant.fromJson(Map<String, dynamic>.from(participant))).toList();
            raffle.participants = participants;
            return raffle;
          })
              .where((raffle) => raffle.status == "ACTIVE")
              .toList();

          List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
          locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);
          filteredRaffle = raffleList;
          notifyListeners();
        }

        rebuildUi();
      }
    } catch (e) {
      print(e);
    }finally{
      setBusy(false);
    }

  }

  // Future<void> getRaffles() async {
  //   setBusy(true);
  //   try {
  //     ApiResponse res = await repo.getRaffle();
  //     if (res.statusCode == 200) {
  //       if (res.data != null && res.data["data"]["items"] != null) {
  //         // Extract raffles from 'items'
  //         raffleList = (res.data["data"]["items"] as List)
  //             .map((e) => Raffle.fromJson(Map<String, dynamic>.from(e['raffle'])))
  //             .where((raffle) => raffle.status == "ACTIVE" || raffle.status == "COMPLETED")
  //             .toList();
  //
  //         // Filter raffles with a valid winning ticket (not null and truthy)
  //         raffleWinnerList = raffleList
  //             .where((raffle) => raffle.winningTicket != null && raffle.winningTicket!.isNotEmpty) // Check if winningTicket is valid
  //             .map((raffle) => Winner(
  //           raffleId: raffle.id,
  //           raffleName: raffle.name,
  //           winningTicketId: raffle.winningTicket!,
  //         ))
  //             .toList();
  //
  //         // Save raffles to local storage
  //         List<Map<String, dynamic>> storedRaffles = raffleList.map((e) => e.toJson()).toList();
  //         locator<LocalStorage>().save(LocalStorageDir.raffle, storedRaffles);
  //
  //         // Save winners to local storage
  //         List<Map<String, dynamic>> storedWinners = raffleWinnerList.map((e) => e.toJson()).toList();
  //         locator<LocalStorage>().save(LocalStorageDir.winners, storedWinners);
  //
  //         // Filtered raffles for the UI
  //         filteredRaffle = raffleList;
  //         notifyListeners();
  //       }
  //
  //       rebuildUi();
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setBusy(false);
  //   }
  // }



  Future<void> getDrawEvents() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.getDrawEvents();
      if (res.statusCode == 200 && res.data != null && res.data['data'] != null) {
        List<dynamic> items = res.data['data']['items'];

        // Parse the items into a list of DrawEvent objects
        List<DrawEvent> drawEvents = items
            .map((item) => DrawEvent.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        raffleDrawEvents = drawEvents;
        List<Map<String, dynamic>> storedRaffles = raffleDrawEvents.map((e) => e.toJson()).toList();
        locator<LocalStorage>().save(LocalStorageDir.drawsEvent, storedRaffles);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching draw events: $e");
    }
    setBusy(false);
    notifyListeners();
  }


  Future<void> getRafflesWinners() async {
    setBusy(true);
    try {
      ApiResponse res = await repo.getRaffleWinners();
      if (res.statusCode == 200) {
        if (res.data != null && res.data["data"] != null && res.data["data"]["items"] != null) {
          // Extract the winners and the associated raffle data
          raffleWinnerList = (res.data["data"]["items"] as List).map((e) {
            var winnerData = e;
            return Winner.fromJson(Map<String, dynamic>.from(winnerData));
          }).toList();


          List<Map<String, dynamic>> storedWinners = raffleWinnerList.map((e) => e.toJson()).toList();
          await locator<LocalStorage>().save(LocalStorageDir.winners, storedWinners);
        }
        rebuildUi();  // Rebuild the UI after the data is processed
      }
    } catch (e) {
      print(e);
    }finally{
      setBusy(false);
      notifyListeners();
    }

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
