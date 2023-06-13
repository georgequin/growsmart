import 'package:afriprize/core/network/api_response.dart';

abstract class IRepository{
  Future<ApiResponse> login(Map<String,dynamic> req);

  Future<ApiResponse> register(Map<String,dynamic> req);

  Future<ApiResponse> verify(Map<String,dynamic> req);


}