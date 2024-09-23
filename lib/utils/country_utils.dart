

import '../app/app.locator.dart';
import '../core/data/models/country.dart';
import '../core/data/repositories/repository.dart';
import '../core/network/api_response.dart';

class CountryUtils {

  Future<List<Country>> getSupportedCountries() async {
    try {
      print('making get country call');
      ApiResponse res = await locator<Repository>().supportCountries();
      if (res.statusCode == 200 && res.data != null) {
        List<dynamic> countriesData = res.data['data'];

        // Map the extracted list to a List of Country objects
        List<Country> countries = countriesData.map((country) => Country.fromJson(country)).toList();
        return countries;
      } else {
        throw Exception('Failed to load supported countries');
      }
    } catch (e) {
      throw Exception('Error fetching supported countries: $e');
    }
  }
}
