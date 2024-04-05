import 'package:afriprize/core/data/models/app_notification.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import 'notification_viewmodel.dart';

class NotificationView extends StackedView<NotificationViewModel> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notification",
        ),
      ),
      body: ValueListenableBuilder<List<AppNotification>>(
        valueListenable: notifications,
        builder: (context, value, child) => value.isEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  viewModel.getNotifications();
                },
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const EmptyState(
                        animation: "empty_notifications.json",
                        label: "No Notifications Yet",
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  AppNotification notification = value[index];
                  return Card(
                    child: ListTile(
                      onTap: () => viewModel.readNotification(notification),
                      title: Row(
                        children: [
                          (viewModel.isBusy &&
                                  viewModel.loadingId == notification.id)
                              ? const SizedBox(
                                  height: 8,
                                  width: 8,
                                  child: CircularProgressIndicator())
                              : notification.status == 1
                                  ? const SizedBox.shrink()
                                  : (notification.eventName!.contains('Payment')
                                    ? const Icon(
                                        Icons.payment_outlined,
                                        color: kcSecondaryColor,
                                        size: 40,
                                      )
                                  : notification.eventName!.contains('sent')
                                    ? const Icon(
                                        Icons.local_shipping_outlined,
                                        color: kcSecondaryColor,
                                        size: 40,
                                      )
                                  : notification.eventName!.contains('congrats')
                                    ? const Icon(
                                        Icons.celebration_outlined,
                                        color: kcSecondaryColor,
                                        size: 40,
                                   )
                                  : const Icon(
                                      Icons.notification_important_outlined,
                                      color: kcSecondaryColor,
                                      size: 40,
                                    )
                                    ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.eventName ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  notification.eventDescription ?? "",
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(DateFormat("d MMM y")
                          .format(DateTime.parse(notification.created!))),
                    ),
                  );
                }),
      ),
    );
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();
}
