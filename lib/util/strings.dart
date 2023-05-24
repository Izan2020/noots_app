import 'package:date_formatter/date_formatter.dart';
import 'package:intl/intl.dart';

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String timestampToHour(String? timestamp, String? formatParse) {
  if (timestamp == null) {
    return 'Timestamp Empty';
  } else {
    var parser = DateFormat('yyyy-MM-dd HH:mm:ss.mmmmmm');
    var format = DateFormat(formatParse);
    var result = format.format(parser.parse(timestamp));

    return result;
  }
}
