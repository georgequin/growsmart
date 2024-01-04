import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String daySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  var day = DateFormat('d').format(date); // Day without leading zero
  var dayWithSuffix = '$day${daySuffix(int.parse(day))}';
  var formattedDate = DateFormat('EEEE, ').format(date); // Day of week
  formattedDate += '$dayWithSuffix ';
  formattedDate += DateFormat('MMMM').format(date); // Month

  return formattedDate;
}
