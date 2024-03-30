import 'package:flutter/material.dart';

enum ScreenType { SMALL, MEDIUM, LARGE }

class Utils {
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;
  }

  bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  ScreenType getScreenType(BuildContext context) {
    if (isLargeScreen(context)) {
      return ScreenType.LARGE;
    } else if (isMediumScreen(context)) {
      return ScreenType.MEDIUM;
    } else {
      return ScreenType.SMALL;
    }
  }


  
}
