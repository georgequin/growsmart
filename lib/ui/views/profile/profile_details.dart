import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:path/path.dart' as path;
import '../../../app/app.locator.dart';
import '../../../core/data/models/profile.dart';
import '../../../core/data/repositories/repository.dart';
import '../../../core/network/api_response.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/profile_picture.dart';
import '../cart/add_shipping.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  bool loading = false;
  final repo = locator<Repository>();
  String shippingId = "";
  bool makingDefault = false;
  bool isUpdating = false;
  final snackBar = locator<SnackbarService>();

  void updateProfilePicture() async {
    // pick photo
    setState(() {
      isUpdating = true;
    });
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // Handle null (user didn't pick an image)

    String oldPath = image.path;
    String newPath = '${path.withoutExtension(oldPath)}.png';
    File inputFile = File(oldPath);
    File outputFile = File(newPath);

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      inputFile.path,
      outputFile.path,
      format: CompressFormat.png,
    );

    if (result == null) return;

    // Check file size
    final fileSize = await outputFile.length();
    if (fileSize > 5 * 1024 * 1024) {
      // 5 MB size limit
      snackBar.showSnackbar(message: "Please pick an image smaller than 5MB");
      setState(() {
        isUpdating = false;
      });
      return;
    }

    try {
      ApiResponse res = await locator<Repository>().updateProfilePicture({
        "picture": await MultipartFile.fromFile(outputFile.path),
      });
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: res.data["message"]);
        getProfile();
      }
    } catch (e) {
      throw Exception(e);
    }

    setState(() {
      isUpdating = false;
    });
  }

  void getProfile() async {
    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );

    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(24.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  isUpdating
                      ? const CircularProgressIndicator() // Show loader when updating
                      : GestureDetector(
                          onTap: () {
                            updateProfilePicture();
                          },
                          // This stack is just for the profile picture and the edit icon
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ProfilePicture(
                                  size: 100,
                                  url: 'https://via.placeholder.com/150'
                                  // url: profile.value.pictures!.isEmpty
                                  //     ? null
                                  //     : profile.value.pictures?[0].location,
                                  ),
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
                                  width: 25, // Width and height of the circle
                                  height: 25,
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
                                    Icons.add,
                                    color: kcWhiteColor, // Icon color
                                    size: 18, // Icon size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ListTile(
                                title: const Text(
                                  'Full Name',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                subtitle: Text(
                                  "${profile.value.firstname} ${profile.value.lastname}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: uiMode.value == AppUiModes.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              // This will give bounded constraints to the ListTile.
                              child: ListTile(
                                title: const Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                subtitle: Text(
                                  '${profile.value.email}',
                                  style: TextStyle(
                                      color: uiMode.value == AppUiModes.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                subtitle: Text(
                                  "${profile.value.phone}",
                                  style: TextStyle(
                                      color: uiMode.value == AppUiModes.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ... Other widgets can go here
                      ],
                    ),
                  ),
                  horizontalSpaceLarge,
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Optional padding for spacing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items properly
                            children: [
                              Text(
                                "Create Afritag",
                                style: TextStyle(
                                  color: uiMode.value == AppUiModes.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Text(
                            "Create a unique username to transfer shopping credits with family to purchase or donate.",
                            style: TextStyle(
                              color: uiMode.value == AppUiModes.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          verticalSpaceSmall,

                          Row(
                            children: [
                             Container(
                                width: 25, // Width and height of the circle
                                height: 25,
                                decoration: BoxDecoration(
                                  color:
                                  kcSecondaryColor, // Background color of the circle
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                    kcWhiteColor, // Border color of the circle
                                    width: 2, // Border width
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: kcWhiteColor, // Icon color
                                  size: 12, // Icon size
                                ),
                              ),
                              SizedBox(width: 8), // Adds spacing between the icon and text
                              Text(
                                "Create Afri Tag",
                                style: TextStyle(
                                  color: uiMode.value == AppUiModes.dark
                                      ? Colors.white
                                      : kcSecondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  horizontalSpaceMedium,

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Column(
                      children: [
                        // ...List.generate(
                        //   profile.value.shipping!.length,
                        //       (index) {
                        //     Shipping shipping =
                        //     profile.value.shipping![index];
                        //     return Container(
                        //       padding: const EdgeInsets.all(10),
                        //       margin: const EdgeInsets.only(bottom: 10),
                        //       child: Card(
                        //         shadowColor: Colors.grey,
                        //         child: Padding(
                        //         padding: const EdgeInsets.all(6.0), // This adds horizontal padding
                        //         child: Column(
                        //             mainAxisAlignment:MainAxisAlignment.start,
                        //             children: [
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 children: [
                        //                   const Icon(
                        //                     Icons.location_on_outlined,
                        //                     size: 20,
                        //                   ),
                        //                   Expanded(
                        //                     child: Text(
                        //                       '${shipping.shippingAddress} ${shipping.shippingCity} ${shipping.shippingState}' ?? "",
                        //                       overflow: TextOverflow.ellipsis,
                        //                       maxLines: 3,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               verticalSpaceSmall,
                        //               Row(
                        //                 mainAxisAlignment:MainAxisAlignment.start,
                        //                 children: [
                        //                   const Icon(
                        //                     Icons.phone,
                        //                     size: 20,
                        //                   ),
                        //                   Text('${shipping.shippingPhone}' ?? ""),
                        //
                        //                 ],
                        //               ),
                        //               Row(
                        //                 mainAxisAlignment:MainAxisAlignment.start,
                        //                 children: [
                        //                   horizontalSpaceSmall,
                        //                   const Text('Set as default', style: TextStyle(
                        //                       fontSize: 10,
                        //                       fontWeight: FontWeight.normal
                        //                   ),),
                        //                   horizontalSpaceTiny,
                        //                   SizedBox(
                        //                     height: 20.0,
                        //                     child: Switch(
                        //                       // This bool value toggles the switch.
                        //                       value: shipping.isDefault!,
                        //                       overlayColor: overlayColor,
                        //                       trackColor: trackColor,
                        //                       thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                        //                       onChanged: (bool value) {
                        //                         // This is called when the user toggles the switch.
                        //                         setState(() async {
                        //                           if(value){
                        //                             setState(() {
                        //                               shippingId = shipping.id!;
                        //                               makingDefault = value;
                        //                             });
                        //
                        //                             try {
                        //                               ApiResponse res =
                        //                                   await locator<
                        //                                   Repository>()
                        //                                   .setDefaultShipping(
                        //                                   {},
                        //                                   shipping.id!);
                        //                               if (res.statusCode == 200) {
                        //                                 ApiResponse pRes =
                        //                                     await locator<
                        //                                     Repository>()
                        //                                     .getProfile();
                        //                                 if (pRes.statusCode ==
                        //                                     200) {
                        //                                   profile.value = Profile
                        //                                       .fromJson(Map<
                        //                                       String,
                        //                                       dynamic>.from(
                        //                                       pRes.data[
                        //                                       "user"]));
                        //
                        //                                   profile
                        //                                       .notifyListeners();
                        //                                 }
                        //                               }
                        //                             } catch (e) {
                        //                               throw Exception(e);
                        //                             }
                        //
                        //                             setState(() {
                        //                               shippingId = "";
                        //                               makingDefault = value;
                        //                             });
                        //
                        //                           }
                        //                         });
                        //                       },
                        //                     )
                        //                   ),
                        //                   horizontalSpaceTiny,
                        //                   InkWell(
                        //                     onTap: () async {
                        //
                        //                         if (shipping.isDefault!) {
                        //                         Fluttertoast.showToast(msg: 'Can\'t delete default address.');
                        //                         } else {
                        //                           try {
                        //                             final res = await locator<DialogService>()
                        //                                 .showConfirmationDialog(
                        //                                 title: "Are you sure?",
                        //                                 cancelTitle: "No",
                        //                                 confirmationTitle: "Yes");
                        //
                        //                             if (res!.confirmed) {
                        //                               ApiResponse res = await locator<Repository>().deleteDefaultShipping(
                        //                                   shipping.id!);
                        //                               if (res.statusCode == 200) {
                        //                                 ApiResponse pRes = await locator<Repository>().getProfile();
                        //                                 if (pRes.statusCode == 200) {
                        //                                   setState(() {
                        //                                     // Update your state here
                        //                                     profile.value = Profile.fromJson(
                        //                                         Map<String, dynamic>.from(pRes.data["user"]));
                        //                                     profile.notifyListeners();
                        //                                   });
                        //                                 }
                        //                               }
                        //                             }
                        //                           } catch (e) {
                        //                             Fluttertoast.showToast(msg: 'can\'t delete..');
                        //                           }
                        //                         }
                        //                     },
                        //                     child: const Icon(Icons.delete),
                        //                   ),
                        //
                        //
                        //                 ],
                        //               ),
                        //             ]
                        //         )
                        //         )
                        //
                        //       )
                        //
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   style: ButtonStyle(
                  //       backgroundColor:
                  //           MaterialStateProperty.all(kcPrimaryColor)),
                  //   child: const Text(
                  //     "Add new shipping address",
                  //     style: TextStyle(color: kcWhiteColor),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context)
                  //         .push(
                  //           MaterialPageRoute(
                  //             builder: (context) => const AddShipping(),
                  //           ),
                  //         )
                  //         .whenComplete(() => setState(() {}));
                  //   },
                  // ),
                  horizontalSpaceLarge,
                ]),
          ),
        ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final String address;
  final String phone;

  const AddressTile({super.key, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Address'),
      subtitle: Text(address),
      trailing: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.edit),
          SizedBox(height: 4),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}
