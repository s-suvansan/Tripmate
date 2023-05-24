import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tripmate/common/brand_color.dart';

showRestrictPopLoading(BuildContext context, {Color? circularColor, bool ableToPop = false}) {
  WillPopScope pop = WillPopScope(
      onWillPop: () async => ableToPop,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: SimpleDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            contentPadding: const EdgeInsets.all(24.0),
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(circularColor ?? BrandColors.brandColor),
                ),
              )
            ]),
      ));
  showDialog(
    barrierColor: Colors.white.withOpacity(0.3),
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return pop;
    },
  );
}

shopRestrictPopLoading(BuildContext context) {
  Navigator.pop(context);
}

showToast({String? msg}) {
  Fluttertoast.showToast(
      msg: msg ?? "",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<dynamic> showCommonPopup(BuildContext context, Widget widget, {boolbarrierDismissible = true}) async {
  dynamic value;
  value = await showDialog(
      barrierDismissible: boolbarrierDismissible,
      context: context,
      builder: (BuildContext bc) {
        return widget;
      });
  return value;
}

String timeFormat(DateTime? dt, {bool toLocal = false}) {
  String value = "";
  try {
    if (dt != null) {
      DateTime dateTime = !toLocal ? dt : dt.toLocal();
      String hr = _makeTwoDigit(dateTime.hour == 0
          ? 12
          : dateTime.hour > 12
              ? dateTime.hour - 12
              : dateTime.hour);
      String minutes = _makeTwoDigit(dateTime.minute);
      String amPm = dateTime.hour >= 12 ? "PM" : "AM";
      value = "$hr:$minutes $amPm";
    }
  } catch (e) {
    value = "";
  }
  return value;
}

// make a digit digit as two digit text Ex:- 1 => 01
// and make text with supertext and related with above function
String _makeTwoDigit(int digit, {bool needSupText = false}) {
  String value = "";
  try {
    value = digit.toString().length == 1 ? "0$digit" : digit.toString();
    if (needSupText) {
      if (digit == 1) {
        value = "$value st"; //1st \u02e2\u1d57
      } else if (digit == 2) {
        value = "$value nd"; //2nd \u207f\u1d48
      } else if (digit == 3) {
        value = "$value rd"; //3rd \u02b3\u1d48
      } else {
        value = "$value th"; //nth \u1d57\u02b0
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return value;
}
