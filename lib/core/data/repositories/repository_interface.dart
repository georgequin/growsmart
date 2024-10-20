import 'package:easy_power/core/network/api_response.dart';

abstract class IRepository {
  Future<ApiResponse> login(Map<String, dynamic> req);

  Future<ApiResponse> requestOtp(Map<String, dynamic> req);

  Future<ApiResponse> submitOtp(Map<String, dynamic> req);

  Future<ApiResponse> logOut();

  Future<ApiResponse> refresh();

  Future<ApiResponse> register(Map<String, dynamic> req);

  Future<ApiResponse> verify(Map<String, dynamic> req);

  Future<ApiResponse> getProducts();

  Future<ApiResponse> getRaffle();

  Future<ApiResponse> getSoldOutRaffle();

  Future<ApiResponse> getRaffleResult();

  Future<ApiResponse> getSellingFast();

  Future<ApiResponse> getProfile();

  Future<ApiResponse> initTransaction(Map<String, dynamic> req);

  Future<ApiResponse> saveOrder(Map<String, dynamic> req);

  Future<ApiResponse> verifyTransaction(String ref);

  Future<ApiResponse> payForOrder(Map<String, dynamic> req);

  Future<ApiResponse> resetPasswordRequest(String email);

  Future<ApiResponse> convertToNaira(String amount);

  Future<ApiResponse> updatePassword(Map<String, dynamic> req, String email);

  Future<ApiResponse> resetPassword(Map<String, dynamic> req, String email);

  Future<ApiResponse> requestDelete(Map<String, dynamic> req);

  Future<ApiResponse> deleteAccount(Map<String, dynamic> req);

  Future<ApiResponse> updateProfilePicture(Map<String, dynamic> req);

  Future<ApiResponse> getBanks();

  Future<ApiResponse> withdraw(Map<String, dynamic> req);

  Future<ApiResponse> getOrderList();

  Future<ApiResponse> getOrdersStatus(Map<String, dynamic> req);

  Future<ApiResponse> raffleList();

  Future<ApiResponse> verifyName(Map<String, dynamic> req);

  Future<ApiResponse> getTransactions();

  Future<ApiResponse> recommendedProducts(String productId);

  Future<ApiResponse> getResourceList();

  Future<ApiResponse> getNotifications(String userId);

  Future<ApiResponse> updateNotification(String eventId);

  Future<ApiResponse> saveShipping(Map<String, dynamic> req);

  Future<ApiResponse> setDefaultShipping(Map<String, dynamic> req, String id);

  Future<ApiResponse> deleteDefaultShipping(String productId);

  Future<ApiResponse> reviewOrder(Map<String, dynamic> req);

  Future<ApiResponse> getExchangeRate({required double amount,
    required String destinationCurrency,
    required String sourceCurrency,
  });
}
