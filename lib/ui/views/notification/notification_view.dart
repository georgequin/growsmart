import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/app_notification.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
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
                                  : Container(
                                      height: 5,
                                      width: 5,
                                      decoration: const BoxDecoration(
                                          color: Colors.red),
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
      // body: ListView(
      //   padding: const EdgeInsets.all(20),
      //   children: [
      //     const Text(
      //       "Yesterday",
      //       style: TextStyle(
      //         color: kcSecondaryColor,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     verticalSpaceMedium,
      //     ListView.builder(
      //         shrinkWrap: true,
      //         itemCount: 3,
      //         itemBuilder: (context, index) {
      //           return Container(
      //             margin: const EdgeInsets.symmetric(vertical: 10),
      //             color: kcWhiteColor,
      //             child: const ListTile(
      //               title: Text("Your order has been sent out"),
      //               subtitle: Text("Delivery in progress"),
      //             ),
      //           );
      //         })
      //   ],
      // ),
    );
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();
}
