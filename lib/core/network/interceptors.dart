import 'package:afriprize/app/app.dialogs.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';

final nav = locator<NavigationService>();

final logInterceptor = PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
  maxWidth: 90,
);

final requestInterceptors = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  },
  onError: (DioError dioError, ErrorInterceptorHandler handler) async {
    if (dioError.type == DioErrorType.connectTimeout) {
      locator<DialogService>().showCustomDialog(
        variant: DialogType.infoAlert,
        title: "Connection Timed Out",
      );
    } else if (dioError.type == DioErrorType.other) {
      locator<DialogService>().showCustomDialog(
        variant: DialogType.infoAlert,
        title: "Network is unreachable",
      );
    } else if (dioError.type == DioErrorType.receiveTimeout) {
      locator<DialogService>().showCustomDialog(
        variant: DialogType.infoAlert,
        title: "Receive Timed Out",
      );
    } else {
      if (dioError.response?.statusCode == 401) {
        final res = await locator<DialogService>().showCustomDialog(
            variant: DialogType.infoAlert,
            title: "Session Expired",
            description: "Login again to continue");
        if (res!.confirmed) {

          locator<NavigationService>().clearStackAndShow(Routes.authView);
        }
      }
    }
    handler.next(dioError);
  },
);
