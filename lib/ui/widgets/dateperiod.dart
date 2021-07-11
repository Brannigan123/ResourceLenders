import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:sizer/sizer.dart';

class DatePeriodeView extends StatelessWidget {
  const DatePeriodeView({Key? key, required this.period, this.style})
      : super(key: key);

  final DatePeriod period;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final sameYear = period.start.year == period.end.year;
    if (sameYear) {
      final sameMonth = period.start.month == period.end.month;
      if (sameMonth) {
        final sameDay = period.start.day == period.end.day;
        if (sameDay) {
          return AutoSizeText(
            '${period.end.day}/${period.end.month}/${period.end.year}',
            maxLines: 1,
            minFontSize: 4.0.sp.ceilToDouble(),
            style: style,
          );
        } else {
          return AutoSizeText(
            '${period.start.day} to ${period.end.day}  ${period.start.month}/${period.end.year}',
            maxLines: 1,
            minFontSize: 4.0.sp.ceilToDouble(),
            style: style,
          );
        }
      } else {
        return AutoSizeText(
          '${period.start.day}/${period.start.month} to ${period.end.day}/${period.end.month}  ${period.end.year}',
          maxLines: 1,
          minFontSize: 4.0.sp.ceilToDouble(),
          style: style,
        );
      }
    } else {
      return AutoSizeText(
        '${period.start.day}/${period.start.month}/${period.start.year} to ${period.end.day}/${period.end.month}/${period.end.year}',
        maxLines: 1,
        minFontSize: 4.0.sp.ceilToDouble(),
        style: style,
      );
    }
  }
}
