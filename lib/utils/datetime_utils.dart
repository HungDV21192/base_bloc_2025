import 'package:base_code/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String convertDateTimeToStringWithFormat(
      DateTime? dateTime, String format) {
    try {
      if (dateTime != null) {
        String dateT = DateFormat(format).format(dateTime);
        return (dateT != '01/01/3000') ? dateT : '';
      } else {
        return '';
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  static DateTime convertStringToDateTime(
      {required String date, required String format}) {
    try {
      if (date != '') {
        var dateTime = DateFormat(format).parse(date);
        if (DateTime(2100).isBefore(dateTime)) {
          return DateTime.now();
        }
        return dateTime;
      } else {
        return DateTime.now();
      }
    } catch (e) {
      // FlushBarServices.showError('Không thể chuyển đổi ngày tháng $e');
      return DateTime.now();
    }
  }

  static String convertStrDateToStrDate({
    required String strDate,
    required String formatDate,
    String? formatStrDate,
  }) {
    try {
      if (strDate != '') {
        if (formatStrDate != null) {
          var dateTime = DateFormat(formatStrDate).parse(strDate);
          var formater = DateFormat(formatDate);
          String formattedDate = formater.format(dateTime);
          return formattedDate;
        }
        var dateTime = DateTime.parse(strDate);
        var formater = DateFormat(formatDate);
        String formattedDate = formater.format(dateTime);
        return formattedDate;
      } else {
        return 'N/A';
      }
    } catch (e) {
      FlushBarServices.showError('Không thể chuyển đổi ngày tháng $e');
      return 'N/A';
    }
  }

  static bool isDateBetweenTwoDays(
      DateTime date, DateTime start, DateTime end) {
    DateTime endDate = DateTime(end.year, end.month, end.day, 23, 59);
    DateTime startDate =
        DateTime(start.year, start.month, start.day - 1, 23, 59);
    return endDate.isAfter(date) && startDate.isBefore(date);
  }

  static String getDateTimeNow({
    bool? isTime,
  }) {
    return DateFormat((isTime == true) ? 'dd/MM/yyyy HH:ss' : 'dd/MM/yyyy')
        .format(DateTime.now());
  }

  static String formatDateTimeddMMyyyy({required String oldDate}) {
    try {
      if (oldDate != '') {
        List<String> parts = oldDate.split("/");
        String newDateString =
            "${parts[0].padLeft(2, "0")}/${parts[1].padLeft(2, "0")}/${parts[2]}";
        return newDateString;
      } else {
        return 'N/A';
      }
    } catch (e) {
      FlushBarServices.showError('Không thể chuyển đổi ngày tháng $e');
      return 'N/A';
    }
  }

  static DateTime? convertStrToDateDefault({
    required String date,
    String? format,
  }) {
    try {
      if (date != '') {
        var dateTime =
            DateFormat((format != null) ? format : 'dd/MM/yyyy').parse(date);
        return dateTime;
      } else {
        return null;
      }
    } catch (e) {
      FlushBarServices.showError('Không thể chuyển đổi ngày tháng $e');
      return null;
    }
  }

  static bool checkDateIsBeforeDate(
      {required DateTime date1, required DateTime date2}) {
    DateTime nDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime nDate2 = DateTime(date2.year, date2.month, date2.day);
    return (nDate1.isAtSameMomentAs(nDate2) || nDate1.isBefore(nDate2));
  }

  static bool checkDateIsAfterDate(
      {required DateTime date1, required DateTime date2}) {
    DateTime nDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime nDate2 = DateTime(date2.year, date2.month, date2.day);
    return (nDate1.isAtSameMomentAs(nDate2) || nDate1.isAfter(nDate2));
  }
}
