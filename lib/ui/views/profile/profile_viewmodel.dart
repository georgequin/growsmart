import 'dart:io';

import 'package:easy_power/app/app.locator.dart';
import 'package:easy_power/app/app.logger.dart';
import 'package:easy_power/core/data/models/profile.dart';
import 'package:easy_power/core/data/repositories/repository.dart';
import 'package:easy_power/core/network/api_response.dart';
import 'package:easy_power/state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as path;
import 'package:stacked_services/stacked_services.dart';

import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';

class ProfileViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("ProfileViewModel");
  bool showChangePP = false;
  final snackBar = locator<SnackbarService>();

  void toggleShowChangePP() {
    showChangePP = !showChangePP;
    rebuildUi();
  }

  // void updateProfilePicture() async {
  //   setBusy(false);
  //   //pick photo
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //
  //   String oldPath = image!.path;
  //   String newPath = '${path.withoutExtension(oldPath)}.png';
  //   File inputFile = File(oldPath);
  //   File outputFile = File(newPath);
  //
  //   XFile? result = await FlutterImageCompress.compressAndGetFile(
  //     inputFile.path,
  //     outputFile.path,
  //     format: CompressFormat.png,
  //   );
  //
  //   log.i(result!.path);
  //
  //   try {
  //     ApiResponse res = await locator<Repository>().updateProfilePicture({
  //       "picture": await MultipartFile.fromFile(File(result.path).path),
  //     });
  //     if (res.statusCode == 200) {
  //       snackBar.showSnackbar(message: res.data["message"]);
  //       getProfile();
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  //   setBusy(false);
  // }
  //
  // void getProfile() async {
  //   setBusy(true);
  //
  //   final localProfileJson = await locator<LocalStorage>().fetch(LocalStorageDir.profileView);
  //   if (localProfileJson != null) {
  //     profile.value = Profile.fromJson(localProfileJson);
  //     rebuildUi();
  //   }
  //
  //   try {
  //     ApiResponse res = await repo.getProfile();
  //     if (res.statusCode == 200) {
  //       profile.value = Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
  //       await locator<LocalStorage>().save(LocalStorageDir.profileView, res.data["user"]); // Cache updated profile
  //       rebuildUi(); // Update UI with fresh data
  //     }
  //   } catch (e) {
  //     log.e(e);
  //   }
  //
  //   setBusy(false);
  // }


  // void getProfile() async {
  //   setBusy(true);
  //   try {
  //     ApiResponse res = await repo.getProfile();
  //     if (res.statusCode == 200) {
  //       profile.value =
  //           Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
  //       rebuildUi();
  //     }
  //   } catch (e) {
  //     log.e(e);
  //   }
  //   setBusy(false);
  // }


}
