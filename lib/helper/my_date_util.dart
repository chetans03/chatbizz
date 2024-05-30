import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormatedTime(
      {required BuildContext context, required String time}) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(datetime).format(context).toString();
  }
}
