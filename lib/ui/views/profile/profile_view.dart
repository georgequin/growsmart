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
import 'package:afriprize/ui/views/profile/refferal.dart';
import 'package:afriprize/ui/views/profile/support.dart';
import 'package:afriprize/ui/views/profile/ticket_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    // barrierColor: Colors.black.withAlpha(50),
                                    // backgroundColor: Colors.transparent,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.7),
                                    builder: (BuildContext context) {
                                      return const FractionallySizedBox(
                                        heightFactor:
                                            1.0, // 70% of the screen's height
                                        child: ProfileScreen(),
                                      );
                                    },
                                  );
                                  // viewModel.updateProfilePicture();
                                },
                                child: ProfilePicture(
                                    size: 100,
                                      url: profile.value.profilePic?.url,
                                    ),
                              ),
                              // horizontalSpaceLarge,
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    // barrierColor: Colors.black.withAlpha(50),
                                    // backgroundColor: Colors.transparent,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.7),
                                    builder: (BuildContext context) {
                                      return const FractionallySizedBox(
                                        heightFactor:
                                            1.0, // 70% of the screen's height
                                        child: ProfileScreen(),
                                      );
                                    },
                                  );
                                  // viewModel.updateProfilePicture();
                                },
                                child: Container(
                                  width: 30, // Width and height of the circle
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        kcPrimaryColor, // Background color of the circle
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          kcWhiteColor, // Border color of the circle
                                      width: 2, // Border width
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: kcWhiteColor, // Icon color
                                    size: 18, // Icon size
                                  ),
                                ),
                              ),
                            ],
                          ),
                          horizontalSpaceMedium,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${profile.value.firstname} ${profile.value.lastname}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(profile.value.username ?? "")
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
                      verticalSpaceMedium,
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                // barrierColor: Colors.black.withAlpha(50),
                                // backgroundColor: Colors.transparent,
                                backgroundColor: Colors.black.withOpacity(0.7),
                                builder: (BuildContext context) {
                                  return const FractionallySizedBox(
                                    heightFactor:
                                        1.0, // 70% of the screen's height
                                    child: ProfileScreen(),
                                  );
                                },
                              );
                            },
                            leading: SvgPicture.asset(
                              'assets/images/person.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
                            ),
                            title: const Text("Profile"),
                          ),
                          ListTile(
                            onTap: () {
                              locator<NavigationService>()
                                  .navigateToWallet()
                                  .whenComplete(() => viewModel.getProfile());
                            },
                            leading: SvgPicture.asset(
                              'assets/images/wallet.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
                            ),
                            title: const Text("My wallet"),
                          ),
                          // ListTile(
                          //   onTap: () {
                          //     // locator<NavigationService>().navigateToTrack();
                          //     Navigator.of(context)
                          //         .push(MaterialPageRoute(builder: (c) {
                          //       return const OrderList();
                          //     }));
                          //   },
                          //   leading: const Icon(
                          //     Icons.wallet,
                          //     color: kcSecondaryColor,
                          //   ),
                          //   title: const Text("My orders"),
                          // ),
                          ListTile(
                            onTap: () {
                              // locator<NavigationService>().navigateToTrack();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return const TicketList();
                              }));
                            },
                            leading: SvgPicture.asset(
                              'assets/images/ticket.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,
                              height: 17,
                              width: 17,
                            ),
                            title: const Text("My tickets"),
                          ),
                          ListTile(
                            onTap: () {
                              // locator<NavigationService>().navigateToTrack();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return const Referral();
                              }));
                            },
                            leading: SvgPicture.asset(
                              'assets/images/gift.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
                            ),
                            title: const Text("Referrals"),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return const Support();
                              }));
                            },
                            leading: SvgPicture.asset(
                              'assets/images/phone-outgoing.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
                            ),
                            title: const Text("Support"),
                          ),
                          ListTile(
                            onTap: () {
                              locator<NavigationService>()
                                  .navigateToChangePasswordView();
                            },
                            leading: SvgPicture.asset(
                              'assets/images/lock-closed.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
                            ),
                            title: const Text("Change password"),
                          ),
                          ListTile(
                            onTap: () {},
                            leading: SvgPicture.asset(
                              'assets/images/sun.svg', // Replace with your SVG file path
                              color: kcSecondaryColor,        // Set the color for the icon
                              height: 24,
                              width: 24,
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
                                  userLoggedIn.value = false;
                                  await locator<LocalStorage>()
                                      .delete(LocalStorageDir.authToken);
                                  await locator<LocalStorage>()
                                      .delete(LocalStorageDir.authUser);
                                  await locator<LocalStorage>()
                                      .delete(LocalStorageDir.cart);
                                  await locator<LocalStorage>()
                                      .delete(LocalStorageDir.authRefreshToken);
                                  raffleCart.value.clear();
                                  raffleCart.notifyListeners();
                                  locator<NavigationService>()
                                      .clearStackAndShow(Routes.authView);
                                }
                              },
                              leading: Icon(
                                Icons.logout,
                                color: kcSecondaryColor,
                              ),
                              title: Text("Signout")),
                        ],
                      ),
                      verticalSpaceMedium,
                      Center(
                        child: Opacity(
                          opacity: 0.4,
                          child: GestureDetector(
                            onTap: () async {
                              locator<NavigationService>()
                                  .navigateToDeleteAccountView();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensures the Row takes only the space of its children
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                    width:
                                        8), // Spacing between the icon and text
                                Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
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
