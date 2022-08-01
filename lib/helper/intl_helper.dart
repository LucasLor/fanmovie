import 'package:intl/intl.dart';


String getCurrency(num value, [String locale = 'pt-BR]']) {
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: locale);
  return formatter.format(value);
}

String formatDAtetiem(String date) {
  var now =  DateTime.parse(date);
  var formatter =  DateFormat.yMd();
  String formatted = formatter.format(now);
  return formatted.toString();

}
