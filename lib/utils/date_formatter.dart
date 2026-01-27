import 'package:valdeiglesias/constants/app_constants.dart';

class DateFormatter {
  static String format(DateTime dateTime) {
    String month = AppConstants.months[dateTime.month]!;
    String minute =
        (dateTime.minute <= 9) ? '0${dateTime.minute}' : '${dateTime.minute}';

    return '${dateTime.day} de $month ${dateTime.year} ${dateTime.hour}:$minute';
  }
}
