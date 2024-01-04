

import '../app/app.locator.dart';
import '../core/data/models/country.dart';
import '../core/data/repositories/repository.dart';
import '../core/network/api_response.dart';

class CountryUtils {

  Future<List<Country>> getSupportedCountries() async {
    try {
      ApiResponse res = await locator<Repository>().supportCountries();
      if (res.statusCode == 200 && res.data["countries"] != null) {
        List<Country> countries = (res.data["countries"] as List).map((e) => Country.fromJson(Map<String, dynamic>.from(e))).toList();
        return countries; // Return the list of countries
      } else {
        throw Exception('Failed to load supported countries');
      }
    } catch (e) {
      throw Exception('Error fetching supported countries: $e');
    }
  }
}
