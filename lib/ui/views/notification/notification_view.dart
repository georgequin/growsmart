import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:flutter/material.dart';
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
      body: const EmptyState(
        animation: "empty_notifications.json",
        label: "No Notifications Yet",
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
  void onViewModelReady(NotificationViewModel viewModel) {
    viewModel.getNotifications();
    super.onViewModelReady(viewModel);
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();
}
