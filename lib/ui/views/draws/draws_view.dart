import 'package:afriprize/core/data/models/raffle_ticket.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'draws_viewmodel.dart';

class DrawsView extends StackedView<DrawsViewModel> {
  const DrawsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DrawsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Draws",
        ),
      ),
      body: viewModel.busy(viewModel.raffle)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : viewModel.raffle.isEmpty
              ? const EmptyState(
                  animation: "casino.json",
                  label: "You're yet to participate in a draw")
              : Stack(
                  children: [
                    PageView.builder(
                        itemCount: viewModel.raffle.length,
                        onPageChanged: viewModel.onPageChanged,
                        itemBuilder: (context, index) {
                          RaffleTicket ticket = viewModel.raffle[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 20),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/raffle.png",
                                ),
                                verticalSpaceMedium,
                                Container(
                                  height: 210,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: kcPrimaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Prize:",
                                          style: TextStyle(
                                              color: kcWhiteColor,
                                              fontSize: 18),
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                          ticket.ticketName ?? "",
                                          style: const TextStyle(
                                              color: kcWhiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        verticalSpaceMedium,
                                        Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                image: (ticket.pictures ==
                                                            null ||
                                                        ticket
                                                            .pictures!.isEmpty)
                                                    ? null
                                                    : DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            ticket.pictures![0]
                                                                .location!)),
                                                color: kcWhiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            horizontalSpaceMedium,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Ticket No.",
                                                  style: TextStyle(
                                                      color: kcWhiteColor,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  ticket.ticketTracking ?? "",
                                                  style: const TextStyle(
                                                      color: kcWhiteColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                verticalSpaceLarge,
                                const Text(
                                  "Start time:",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat("d MMM y").format(
                                      DateTime.parse(ticket.startDate!)),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                verticalSpaceLarge,
                                const Text(
                                  "End time:",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat("d MMM y")
                                      .format(DateTime.parse(ticket.endDate!)),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              viewModel.raffle.length,
                              (index) =>
                                  _indicator(viewModel.selectedIndex == index)),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _indicator(bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? kcPrimaryColor : kcLightGrey,
      ),
    );
  }

  @override
  void onViewModelReady(DrawsViewModel viewModel) {
    viewModel.listRaffle();
    super.onViewModelReady(viewModel);
  }

  @override
  DrawsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DrawsViewModel();
}
