import 'package:flutter/material.dart';
import 'package:pantrypal/core/colors/colors.dart';

/// This class defines custom colors for the app's theme.
/// Define attributes for custom colors here.
/// Define theme color for light and dark mode in the static const light and dark variables.
/// Define color as color from colors.dart.
@immutable
class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color customPrimary;
  final Color customBackground;
  final Color errorCard;
  final Color testTextColor;
  final Color testBackgroundColor;
  final Color testButtonColor;

  const ThemeColors({
    required this.customPrimary,
    required this.customBackground,
    required this.errorCard,
    required this.testTextColor,
    required this.testBackgroundColor,
    required this.testButtonColor,
  });

  @override
  ThemeColors copyWith({
    Color? customPrimary,
    Color? customBackground,
    Color? errorCard,
    Color? testTextColor,
    Color? testBackgroundColor,
    Color? testButtonColor,
  }) {
    return ThemeColors(
      customPrimary: customPrimary ?? this.customPrimary,
      customBackground: customBackground ?? this.customBackground,
      errorCard: errorCard ?? this.errorCard,
      testTextColor: testTextColor ?? this.testTextColor,
      testBackgroundColor: testBackgroundColor ?? this.testBackgroundColor,
      testButtonColor: testButtonColor ?? this.testButtonColor,
    );
  }

  @override
  ThemeColors lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) return this;
    return ThemeColors(
      customPrimary: Color.lerp(customPrimary, other.customPrimary, t)!,
      customBackground: Color.lerp(customBackground, other.customBackground, t)!,
      errorCard: Color.lerp(errorCard, other.errorCard, t)!,
      testTextColor: Color.lerp(testTextColor, other.testTextColor, t)!,
      testBackgroundColor: Color.lerp(testBackgroundColor, other.testBackgroundColor, t)!,
      testButtonColor: Color.lerp(testButtonColor, other.testButtonColor, t)!,
    );
  }

  // Define your default themes (light and dark)
  static const light = ThemeColors(
    customPrimary: Colors.blue,
    customBackground: Colors.white,
    errorCard: Colors.redAccent,
    testTextColor: Colors.black,
    testBackgroundColor: Colors.white,
    testButtonColor: Colors.blue,
  );

  static const dark = ThemeColors(
    customPrimary: Colors.deepPurple,
    customBackground: Colors.black,
    errorCard: Colors.red,
    testTextColor: Colors.white,
    testBackgroundColor: Colors.black,
    testButtonColor: Colors.deepPurple,
  );
}
