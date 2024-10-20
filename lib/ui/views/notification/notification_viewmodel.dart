import 'package:easy_power/app/app.locator.dart';
import 'package:easy_power/app/app.logger.dart';
import 'package:easy_power/core/data/repositories/repository.dart';
import 'package:easy_power/core/network/api_response.dart';
import 'package:stacked/stacked.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../state.dart';
import 'notification_view.dart';

class NotificationViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("NotificationViewModel");
  String loadingId = "";

  int? _selectedIndex; // Stores the index of the selected service
  ServiceMethod? _selectedMethod; // Stores the selected service method

  // Getter for selected index
  int? get selectedIndex => _selectedIndex;

  // Getter for selected method
  ServiceMethod? get selectedMethod => _selectedMethod;

  // Method to set the selected index and update the selected method
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    _selectedMethod = ServiceMethod.values[index]; // Assuming index matches enum order
    notifyListeners(); // Triggers UI update when the index changes
  }


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
