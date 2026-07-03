import 'package:intl/intl.dart';

class DateFormatter {

  static String format(String date) {

    final parsed =
    DateTime.parse(date);

    return DateFormat(
      "dd/MM/yyyy",
    ).format(parsed);

  }

  static String formatDateTime(
      String date) {

    final parsed =
    DateTime.parse(date);

    return DateFormat(
      "dd/MM/yyyy HH:mm",
    ).format(parsed);

  }

}