import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/repositories/repository_interface.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/core/network/api_service.dart';

class Repository extends IRepository {
  final api = locator<ApiService>();

  @override
  Future<ApiResponse> login(Map<String, dynamic> req) async {
    ApiResponse response = await api.call(
      method: HttpMethod.post,
      endpoint: "auth/login",
    );

    return response;
  }
}
