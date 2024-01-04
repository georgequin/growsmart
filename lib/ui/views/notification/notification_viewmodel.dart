import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:stacked/stacked.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../state.dart';

class NotificationViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("NotificationViewModel");
  String loadingId = "";

  void readNotification(notification) async {
    loadingId = notification.id;
    rebuildUi();
    setBusy(true);
    await locator<Repository>().updateNotification(notification.id!)
        .whenComplete(() async {
      await getNotifications();
    });
    setBusy(false);
  }

  Future<void> getNotifications() async {
    try {
      ApiResponse res = await repo.getNotifications(profile.value.id!);
      if (res.statusCode == 200) {
        notifications.value = (res.data["events"] as List)
            .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      log.e(e);
    }
  }
}
