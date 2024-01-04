import 'package:intl/intl.dart';

String formatSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

String formatDecimal(num value, {int decimalDigits = 0}) {
  final formatter = NumberFormat.decimalPatternDigits(
    locale: 'id_ID',
    decimalDigits: decimalDigits,
  );
  return formatter.format(value);
}

String formatSeconds(int milliseconds) {
  return formatDecimal(milliseconds / 1000, decimalDigits: 1);
}
