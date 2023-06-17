import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/profile.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "profile",
          style: TextStyle(
            color: kcBlackColor,
          ),
        ),
      ),
      body: profile.value.id == null || viewModel.isBusy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        viewModel.toggleShowChangePP();
                      },
                      child: const ProfilePicture(
                        size: 100,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${profile.value.firstname} ${profile.value.lastname}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kcMediumGrey),
                        ),
                        Text(profile.value.country ?? "")
                      ],
                    ),
                  ],
                ),
                viewModel.showChangePP
                    ? Column(
                        children: [
                          verticalSpaceMedium,
                          InkWell(
                            onTap: () {
                              viewModel.updateProfilePicture();
                            },
                            child: const Text(
                              "Change Profile Picture",
                              style: TextStyle(
                                color: kcSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                verticalSpaceLarge,
                const Text("User admin"),
                verticalSpaceMedium,
                ListTile(
                  onTap: () {
                    locator<NavigationService>()
                        .navigateToWallet(
                            wallet: profile.value.wallet ?? Wallet())
                        .whenComplete(() => viewModel.getProfile());
                  },
                  leading: const Icon(
                    Icons.wallet,
                    color: kcSecondaryColor,
                  ),
                  title: const Text("Wallet"),
                ),
                ListTile(
                  onTap: () {
                    locator<NavigationService>().navigateToTrack();
                  },
                  leading: const Icon(
                    Icons.wallet,
                    color: kcSecondaryColor,
                  ),
                  title: const Text("My orders"),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.support_agent,
                    color: kcSecondaryColor,
                  ),
                  title: Text("Support"),
                ),
                ListTile(
                  onTap: () async {
                    final res = await locator<DialogService>()
                        .showConfirmationDialog(
                            title: "Are you sure?",
                            cancelTitle: "No",
                            confirmationTitle: "Yes");
                    if (res!.confirmed) {
                      await locator<LocalStorage>()
                          .delete(LocalStorageDir.authToken);
                      locator<NavigationService>().replaceWithAuthView();
                    }
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: kcSecondaryColor,
                  ),
                  title: const Text("Signout"),
                ),
                ListTile(
                  onTap: () {
                    locator<NavigationService>().navigateToChangePasswordView();
                  },
                  leading: const Icon(
                    Icons.lock_outlined,
                    color: kcSecondaryColor,
                  ),
                  title: const Text("Change password"),
                ),
                ListTile(
                  onTap: () {
                    locator<NavigationService>().navigateToDeleteAccountView();
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text("Delete my account"),
                ),
              ],
            ),
    );
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    viewModel.getProfile();
    super.onViewModelReady(viewModel);
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
