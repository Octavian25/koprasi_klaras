import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';

class R {
  static final colors = _Colors();
  static final images = _Images();
  static final textStyle = _TextStyle();
  static final helper = _helper();
  static final cons = _constant();
}

class _Colors {
  final green = "ADD09F".toColor();
  final grenLight = "D2EAA2".toColor();
  final greenDark = "104733".toColor();
  final red = "CC3C3C".toColor();
}

class _Images {
  final success = "assets/Success.png";
  final failed = "assets/failed.png";
  final onboard = "assets/onboard.png";
}

class _TextStyle {
  final bold24 = TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold);
  final semibold16 = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);
  final regular12 = TextStyle(fontSize: 12.sp, color: Colors.black);
  final regular13 = TextStyle(fontSize: 13.sp, color: Colors.black);
  final regular10 = TextStyle(fontSize: 10.sp, color: Colors.black);
  final bold12 = TextStyle(
      fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold);
  final extrabold32 = TextStyle(
      fontSize: 32.sp, color: R.colors.greenDark, fontWeight: FontWeight.bold);
}

class _helper {
  void showToast(context, title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }
}

class _constant {
  final channelKey = "klaras_channel";
  final channelName = "Koperasi Klaras Notification Channel";
  final channelDesc = "Notification Channel for Koperasi Klaras Application";
  final channelGroupKey = "octa_tech";
  final channelGroupName = "Octa Tech Group";
}
