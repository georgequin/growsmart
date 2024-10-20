import 'package:easy_power/app/app.locator.dart';
import 'package:easy_power/app/app.router.dart';
import 'package:easy_power/core/utils/local_store_dir.dart';
import 'package:easy_power/core/utils/local_stotage.dart';
import 'package:easy_power/state.dart';
import 'package:easy_power/ui/common/app_colors.dart';
import 'package:easy_power/ui/common/ui_helpers.dart';
import 'package:easy_power/ui/components/profile_picture.dart';
import 'package:easy_power/ui/views/profile/profile_details.dart';
import 'package:easy_power/ui/views/profile/support.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/interceptors.dart';
import 'Shipping_adresses.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StatelessWidget{
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
        // Make API call to get profile data when the ViewModel is ready
        //viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("My Profile"),
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
                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   backgroundColor: Colors.black.withOpacity(0.7),
                      //   builder: (BuildContext context) {
                      //     return const FractionallySizedBox(
                      //       heightFactor: 1.0, // 70% of the screen's height
                      //       child: ProfileScreen(),
                      //     );
                      //   },
                      // );
                      // viewModel.updateProfilePicture();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfoPage(),
                          ),
                        );
                    },
                    child: ProfilePicture(
                      size: 100,
                      url: (profile.value?.pictures?.isEmpty ?? true)
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
                      Text(
                        "matildabrown@example.com",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),                    ],
                  ),

                ],
              ),
              viewModel.showChangePP
                  ? Column(
                children: [
                  verticalSpaceMedium,
                  InkWell(
                    onTap: () {
                      //viewModel.updateProfilePicture();
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("My orders"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "Already have 12 orders", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios, size: 16,// Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Wallet"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "current Balance \$500 ", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,size: 16, // Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Shipping addresses"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "3 addresses", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressListPage(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios, size: 16, // Next icon
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Payment methods"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "Visa  **34", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios, size: 16,// Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Payment methods"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "You have special promocodes", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios, size: 16, // Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("My reviews"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "Reviews for 4 items", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios, size: 16,// Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceSmall,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Settings"),
                              SizedBox(height: 6), // Add some space between title and subtitle
                              Text(
                                "Notifications, password", // Subtitle
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey, // Subtitle color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios, size: 16,// Next icon
                      ),
                    ],
                  ),
                  Divider(),
                  verticalSpaceMedium,

                ],
              ),
            ],
          )
        );
      },
    );
  }


  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
