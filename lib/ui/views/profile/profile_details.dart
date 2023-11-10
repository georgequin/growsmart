import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  final snackBar = locator<SnackbarService>();

  void updateProfilePicture() async {

    //pick photo
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    String oldPath = image!.path;
    String newPath = '${path.withoutExtension(oldPath)}.png';
    File inputFile = File(oldPath);
    File outputFile = File(newPath);

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      inputFile.path,
      outputFile.path,
      format: CompressFormat.png,
    );

    try {
      ApiResponse res = await locator<Repository>().updateProfilePicture({
        "picture": await MultipartFile.fromFile(File(result!.path).path),
      });
      if (res.statusCode == 200) {
        snackBar.showSnackbar(message: res.data["message"]);
        getProfile();
      }
    } catch (e) {
      print(e);
    }
  }

  void getProfile() async {
    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ));
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      updateProfilePicture();
                    },
                    child: ProfilePicture(
                      size: 80,
                      url: profile.value.pictures!.isEmpty
                          ? null
                          : profile.value.pictures?[0].location,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        updateProfilePicture();
                      },
                      child: Icon(
                        Icons.edit,
                        color: kcPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Card(
            margin: EdgeInsets.all(8.0), // Adjust the margin as needed
            child: Padding(
              padding: EdgeInsets.all(16.0), // Add padding inside the card
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Details",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                 Card(
                  margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  // This will give bounded constraints to the ListTile.
                                  child: ListTile(
                                    title: Text('Full Name',style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    subtitle: Text("${profile.value.firstname} ${profile.value.lastname}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  // This will give bounded constraints to the ListTile.
                                  child: ListTile(
                                    title: Text('Email Address',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    subtitle: Text('${profile.value.email}',
                                        style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text('Phone Number',style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    subtitle: Text("${profile.value.phone}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                ),
                              ],
                            ),
                            // ... Other widgets can go here
                          ],
                        ),
                      ),
                    ),
                  horizontalSpaceMedium,

                  const Text(
                    "Personal Details",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.all(8.0),
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ...List.generate(
                            profile.value.shipping!.length,
                                (index) {
                              Shipping shipping =
                              profile.value.shipping![index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                // decoration: BoxDecoration(
                                //     border: Border.all(
                                //         color: kcBlackColor, width: 0.5)),
                                child: Column(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                          ),
                                          Text('${shipping.shippingAddress} ${shipping.shippingCity} ${shipping.shippingState} ' ?? ""),

                                          // (shipping.isDefault ?? false)
                                          //     ? const Text("Default")
                                          //     : (shippingId == shipping.id &&
                                          //     makingDefault)
                                          //     ? const Center(
                                          //   child:
                                          //   CircularProgressIndicator(),
                                          // )
                                          //     : TextButton(
                                          //   style: ButtonStyle(
                                          //       backgroundColor:
                                          //       MaterialStateProperty
                                          //           .all(
                                          //           kcPrimaryColor)),
                                          //   onPressed: () async {
                                          //     setState(() {
                                          //       shippingId = shipping.id!;
                                          //       makingDefault = true;
                                          //     });
                                          //
                                          //     try {
                                          //       ApiResponse res =
                                          //       await locator<
                                          //           Repository>()
                                          //           .setDefaultShipping(
                                          //           {},
                                          //           shipping.id!);
                                          //       if (res.statusCode == 200) {
                                          //         ApiResponse pRes =
                                          //         await locator<
                                          //             Repository>()
                                          //             .getProfile();
                                          //         if (pRes.statusCode ==
                                          //             200) {
                                          //           profile.value = Profile
                                          //               .fromJson(Map<
                                          //               String,
                                          //               dynamic>.from(
                                          //               pRes.data[
                                          //               "user"]));
                                          //
                                          //           profile
                                          //               .notifyListeners();
                                          //         }
                                          //       }
                                          //     } catch (e) {
                                          //       print(e);
                                          //     }
                                          //
                                          //     setState(() {
                                          //       shippingId = "";
                                          //       makingDefault = false;
                                          //     });
                                          //   },
                                          //   child: const Text(
                                          //     "Make default",
                                          //     style: TextStyle(
                                          //         color: kcWhiteColor),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            size: 20,
                                          ),
                                          Text('${shipping.shippingPhone}' ?? ""),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          horizontalSpaceSmall,
                                          const Text('Set as default', style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal
                                          ),),
                                          horizontalSpaceTiny,
                                          SizedBox(
                                            height: 20.0, // Set your desired height constraint
                                            child:
                                                ToggleSwitch(
                                                  initialLabelIndex: shipping.isDefault! ? 1 : 0,
                                                  customWidths: const [30.0, 20.0], // Width for each side
                                                  cornerRadius: 20.0,
                                                  customHeights: const [10.0],
                                                  activeBgColors: const [
                                                    [Colors.grey], // Color for the left side when it's active
                                                    [kcSecondaryColor] // Color for the right side when it's active
                                                  ],
                                                  activeFgColor: Colors.white, // Text/icon color for the active state
                                                  inactiveBgColor: Colors.grey, // Background color for the inactive state
                                                  inactiveFgColor: Colors.black, // Text/icon color for the inactive state
                                                  totalSwitches: 2,
                                                  labels: const ['', ''], // Labels for the switches
                                                  onToggle: (index) async {
                                                    print('switched to: $index');
                                                    if(index == 1){
                                                      setState(() {
                                                        shippingId = shipping.id!;
                                                        makingDefault = true;
                                                      });

                                                      try {
                                                        ApiResponse res =
                                                        await locator<
                                                            Repository>()
                                                            .setDefaultShipping(
                                                            {},
                                                            shipping.id!);
                                                        if (res.statusCode == 200) {
                                                          ApiResponse pRes =
                                                          await locator<
                                                              Repository>()
                                                              .getProfile();
                                                          if (pRes.statusCode ==
                                                              200) {
                                                            profile.value = Profile
                                                                .fromJson(Map<
                                                                String,
                                                                dynamic>.from(
                                                                pRes.data[
                                                                "user"]));

                                                            profile
                                                                .notifyListeners();
                                                          }
                                                        }
                                                      } catch (e) {
                                                        print(e);
                                                      }

                                                      setState(() {
                                                        shippingId = "";
                                                        makingDefault = false;
                                                      });

                                                    }

                                                  },
                                                )
                                          ),
                                          // horizontalSpaceTiny,
                                          // Icon(Icons.edit_note_outlined),
                                          horizontalSpaceTiny,
                                          InkWell(
                                            onTap: () async {
                                              // Put your click action here
                                              // try {
                                              //   ApiResponse res =
                                              //       await locator<
                                              //       Repository>()
                                              //       .setDefaultShipping(
                                              //       {},
                                              //       shipping.id!);
                                              //   if (res.statusCode == 200) {
                                              //     ApiResponse pRes =
                                              //         await locator<
                                              //         Repository>()
                                              //         .getProfile();
                                              //     if (pRes.statusCode ==
                                              //         200) {
                                              //       profile.value = Profile
                                              //           .fromJson(Map<
                                              //           String,
                                              //           dynamic>.from(
                                              //           pRes.data[
                                              //           "user"]));
                                              //
                                              //       profile
                                              //           .notifyListeners();
                                              //     }
                                              //   }
                                              // } catch (e) {
                                              //   print(e);
                                              // }
                                              Fluttertoast.showToast(msg: 'cant delete..');
                                            },
                                            child: Icon(Icons.delete),
                                          ),


                                        ],
                                      ),
                                    ]
                                )


                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  ),

                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(kcPrimaryColor)),
                    child: const Text(
                      "Add new shipping address",
                      style: TextStyle(color: kcWhiteColor),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => const AddShipping(),
                        ),
                      )
                          .whenComplete(() => setState(() {}));
                    },
                  ),
                  horizontalSpaceMedium,
                ]
              ),
            ),
          ),


           ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final String address;
  final String phone;

  AddressTile({required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Address'),
      subtitle: Text(address),
      trailing: Column(
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
