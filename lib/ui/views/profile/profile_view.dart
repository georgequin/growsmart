import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProfilePicture(
                size: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Anthonio Liuz",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kcMediumGrey),
                  ),
                  Text("United kingdom")
                ],
              ),
            ],
          ),
          verticalSpaceLarge,
          const Text("User admin"),
          verticalSpaceMedium,
          const ListTile(
            leading: Icon(
              Icons.wallet,
              color: kcSecondaryColor,
            ),
            title: Text("Wallet"),
          ),
          const ListTile(
            leading: Icon(
              Icons.wallet,
              color: kcSecondaryColor,
            ),
            title: Text("My orders"),
          ),
          const ListTile(
            leading: Icon(
              Icons.support_agent,
              color: kcSecondaryColor,
            ),
            title: Text("Support"),
          ),
          const ListTile(
            leading: Icon(
              Icons.logout,
              color: kcSecondaryColor,
            ),
            title: Text("Signout"),
          ),
          const ListTile(
            leading: Icon(
              Icons.lock_outlined,
              color: kcSecondaryColor,
            ),
            title: Text("Change password"),
          ),
          const ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text("Delete my account"),
          ),
        ],
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
