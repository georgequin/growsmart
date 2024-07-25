import 'package:intl_phone_field/countries.dart';


class CountryPickerUtils {
  static Country getCountryByIsoCode(String isoCode) {
    return countries.firstWhere((country) => country.code == isoCode);
  }
}