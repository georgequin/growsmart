import 'package:afriprize/core/network/api_response.dart';

abstract class IRepository{
  Future<ApiResponse> login(Map<String,dynamic> req);
}