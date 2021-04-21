import 'package:flutter/material.dart';

double maxWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1200) {
    return 1024;
  } else if (width >= 768 && width < 1200) {
    return 720;
  } else if (width >= 480 && width < 768) {
    return 460;
  }
  return 320;
}
