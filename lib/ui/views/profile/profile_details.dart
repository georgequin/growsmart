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
    setState(() {
      isUpdating = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // Check if an image is selected
    if (image == null) {
      setState(() {
        isUpdating = false;
      });
      print('No image selected.');
      return;
    }

    print('Selected image path: ${image.path}');
    print('Selected image length: ${await File(image.path).length()} bytes');

    try {
      // Compress the image and convert to .png
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.path, // original file path
        '${path.withoutExtension(image.path)}.png', // output path
        format: CompressFormat.png, // compress to PNG format
        quality: 85, // adjust compression quality (1-100)
      );

      if (compressedImage == null) {
        throw Exception('Image compression failed');
      }

      print('Compressed image path: ${compressedImage.path}');
      print('Compressed image size: ${await compressedImage.length()} bytes');

      // Now upload the compressed image
      ApiResponse res = await locator<Repository>().updateMedia({
        "file": await MultipartFile.fromFile(compressedImage.path),
      });

      print('Media upload response: ${res.statusCode}');

      if (res.statusCode == 201) {
        String mediaId = res.data["media_id"];
        print('Media ID received: $mediaId');

        // Now update the profile picture with the media_id
        ApiResponse updateProfileRes = await locator<Repository>().updateProfilePicture({
          "media_id": mediaId,
        });

        print('Profile update response: ${updateProfileRes.statusCode}');

        if (updateProfileRes.statusCode == 200) {
          snackBar.showSnackbar(message: "Profile picture updated successfully!");
          getProfile();
        } else {
          snackBar.showSnackbar(message: "Failed to update profile picture.");
        }
      } else {
        snackBar.showSnackbar(message: "Failed to upload media.");
      }
    } catch (e) {
      print('Error during upload or update: $e');
      snackBar.showSnackbar(message: "An error occurred: $e");
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
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
      backgroundColor: uiMode.value == AppUiModes.dark
          ? kcDarkGreyColor
          : kcWhiteColor,
      appBar: AppBar(
        toolbarHeight: 100.0,
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
            color: uiMode.value == AppUiModes.dark
                ? kcDarkGreyColor
                : kcWhiteColor,
            shadowColor: Colors.transparent,
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
                                  url: profile.value.profilePic?.url,
                                  ),
                              GestureDetector(
                                onTap: () {
                                  updateProfilePicture();
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                      ],
                    ),
                  ),
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
