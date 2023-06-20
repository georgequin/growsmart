import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/raffle_ticket.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:stacked/stacked.dart';

class DrawsViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("DrawsViewModel");
  List<RaffleTicket> raffle = [];
  int selectedIndex = 0;

  onPageChanged(int index){
    selectedIndex = index;
    rebuildUi();
  }

  void listRaffle() async {
    setBusyForObject(raffle, true);
    try {
      ApiResponse res = await repo.raffleList();
      if (res.statusCode == 200) {
        raffle = (res.data["tickets"] as List)
            .map((e) => RaffleTicket.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }
    setBusyForObject(raffle, false);
  }
}
