import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:stacked/stacked.dart';

class DrawsViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("DrawsViewModel");

  void listRaffle() async {
    try {
      ApiResponse res = await repo.raffleList();
      if (res.statusCode == 200) {}
    } catch (e) {
      log.e(e);
    }
  }
}
