import 'dart:io';

import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as path;

class ProfileViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log = getLogger("ProfileViewModel");
  bool showChangePP = false;

  void toggleShowChangePP() {
    showChangePP = !showChangePP;
    rebuildUi();
  }

  void updateProfilePicture() async {
    setBusy(true);
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

    log.i(result!.path);

    try {
      ApiResponse res = await locator<Repository>().updateProfilePicture({
        "picture": await MultipartFile.fromFile(File(result!.path).path),
      });
      if (res.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
    setBusy(false);
  }

  void getProfile() async {
    setBusy(true);

    try {
      ApiResponse res = await repo.getProfile();
      if (res.statusCode == 200) {
        profile.value =
            Profile.fromJson(Map<String, dynamic>.from(res.data["user"]));
        rebuildUi();
      }
    } catch (e) {
      log.e(e);
    }

    setBusy(false);
  }
}
