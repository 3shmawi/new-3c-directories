import 'package:timeago/timeago.dart' as timeago;

String formatTimeAgo(DateTime dateTime) {
  return timeago.format(dateTime);
}
