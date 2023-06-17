import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("ProfileViewModel");

  void getProfile() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value = Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }
}
