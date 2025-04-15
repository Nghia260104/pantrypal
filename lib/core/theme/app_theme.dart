import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.light,
    ],
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.dark,
    ],
  );
}