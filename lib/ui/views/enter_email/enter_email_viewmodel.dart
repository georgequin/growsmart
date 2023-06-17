import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.logger.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EnterEmailViewModel extends BaseViewModel {
  final repo = locator<Repository>();
  final log= getLogger("EnterEmailViewModel");
  final email = TextEditingController();
  final snackBar =  locator<SnackbarService>();

  void sendCode() async{
    setBusy(true);

    try{
      ApiResponse res=  await repo.resetPasswordRequest(email.text);
      if(res.statusCode == 200){
        snackBar.showSnackbar(message: "Code sent to email");
      }
    }catch(e){

    }

    setBusy(false);


  }
}
