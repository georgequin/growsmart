import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/profile_picture.dart';
import 'package:afriprize/ui/views/profile/order_list.dart';
import 'package:afriprize/ui/views/profile/profile_details.dart';
import 'package:afriprize/ui/views/profile/support.dart';
import 'package:afriprize/ui/views/profile/ticket_list.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/profile.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget{
  const ProfileView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
        // Make API call to get profile data when the ViewModel is ready
        viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Profile"),
          ),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        // barrierColor: Colors.black.withAlpha(50),
                        // backgroundColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        builder: (BuildContext context) {
                          return const FractionallySizedBox(
                            heightFactor: 1.0, // 70% of the screen's height
                            child: ProfileScreen(),
                          );
                        },
                      );
                      // viewModel.updateProfilePicture();
                    },
                    child: ProfilePicture(
                      size: 100,
                      url: profile.value.pictures!.isEmpty
                          ? null
                          : profile.value.pictures?[0].location,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${profile.value.firstname} ${profile.value.lastname}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(profile.value.country?.name ?? "")
                    ],
                  ),
                  horizontalSpaceLarge,
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          // barrierColor: Colors.black.withAlpha(50),
                          // backgroundColor: Colors.transparent,
                          backgroundColor: Colors.black.withOpacity(0.7),
                          builder: (BuildContext context) {
                            return const FractionallySizedBox(
                              heightFactor: 1.0, // 70% of the screen's height
                              child: ProfileScreen(),
                            );
                          },
                        );
                        // viewModel.updateProfilePicture();
                      },
                      child: const Icon(Icons.edit, color: kcPrimaryColor,)
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
              ListTile(
                onTap: () {
                  locator<NavigationService>()
                      .navigateToWallet()
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
                  // locator<NavigationService>().navigateToTrack();
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const OrderList();
                  }));
                },
                leading: const Icon(
                  Icons.wallet,
                  color: kcSecondaryColor,
                ),
                title: const Text("My orders"),
              ),
              ListTile(
                onTap: () {
                  // locator<NavigationService>().navigateToTrack();
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const TicketList();
                  }));
                },
                leading: const Icon(
                  Icons.wallet,
                  color: kcSecondaryColor,
                ),
                title: const Text("My tickets"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return const Support();
                  }));
                },
                leading: const Icon(
                  Icons.support_agent,
                  color: kcSecondaryColor,
                ),
                title: const Text("Support"),
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
                onTap: () {},
                leading: const Icon(
                  Icons.color_lens,
                  color: kcSecondaryColor,
                ),
                title: const Text("Dark Theme"),
                trailing: ValueListenableBuilder<AppUiModes>(
                  valueListenable: uiMode,
                  builder: (context, value, child) => Switch(
                    value: value == AppUiModes.dark ? true : false,
                    onChanged: (val) async {
                      if (value == AppUiModes.light) {
                        uiMode.value = AppUiModes.dark;
                        await locator<LocalStorage>()
                            .save(LocalStorageDir.uiMode, "dark");
                      } else {
                        uiMode.value = AppUiModes.light;
                        await locator<LocalStorage>()
                            .save(LocalStorageDir.uiMode, "light");
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  final res = await locator<DialogService>()
                      .showConfirmationDialog(
                      title: "Are you sure?",
                      cancelTitle: "No",
                      confirmationTitle: "Yes");
                  if (res!.confirmed) {


                    ApiResponse res = await repo.logOut();
                    if (res.statusCode == 200) {
                      userLoggedIn.value = false;
                      await locator<LocalStorage>().delete(LocalStorageDir.authToken);
                      await locator<LocalStorage>().delete(LocalStorageDir.authUser);
                      await locator<LocalStorage>().delete(LocalStorageDir.cart);
                      await locator<LocalStorage>().delete(LocalStorageDir.authRefreshToken);
                      raffleCart.value.clear();
                      raffleCart.notifyListeners();
                      return locator<NavigationService>().clearStackAndShow(Routes.authView);
                    }

                  }
                },
                leading: const Icon(
                  Icons.logout,
                  color: kcSecondaryColor,
                ),
                title: const Text("Signout"),
              ),
              verticalSpaceLarge,
              Opacity(
                opacity: 0.4, // Set the opacity to 0.7 (70% opacity)
                child: ListTile(
                  onTap: () async{
                    locator<NavigationService>().navigateToDeleteAccountView();
                  },
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text("delete account"),
                ),
              )
            ],
          )
        );
      },
    );
  }


  // @override
  // void onViewModelReady(ProfileViewModel viewModel) {
  //    viewModel.getProfile();
  //   super.onViewModelReady(viewModel);
  // }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
