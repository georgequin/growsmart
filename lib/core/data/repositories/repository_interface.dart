import 'package:afriprize/core/network/api_response.dart';

abstract class IRepository {
  Future<ApiResponse> login(Map<String, dynamic> req);

  Future<ApiResponse> register(Map<String, dynamic> req);

  Future<ApiResponse> verify(Map<String, dynamic> req);

  Future<ApiResponse> getProducts();

  Future<ApiResponse> getSellingFast();

  Future<ApiResponse> getProfile();

  Future<ApiResponse> initTransaction(Map<String, dynamic> req);

  Future<ApiResponse> saveOrder(Map<String, dynamic> req);

  Future<ApiResponse> verifyTransaction(String ref);

  Future<ApiResponse> payForOrder(Map<String, dynamic> req);

  Future<ApiResponse> resetPasswordRequest(String email);

  Future<ApiResponse> updatePassword(Map<String, dynamic> req, String email);

  Future<ApiResponse> requestDelete(Map<String, dynamic> req);

  Future<ApiResponse> deleteAccount(Map<String, dynamic> req);
}
