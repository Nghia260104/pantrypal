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

  final Color pantrypalTitle;
  final Color notiAlertColor;

  final Color textPrimaryColor;
  final Color hintTextColor;
  final Color goodStatusColor;
  final Color badStatusColor;
  final Color warningStatusColor;

  final Color excellentMatchColor;
  final Color goodMatchColor;
  final Color mediumMatchColor;
  final Color badMatchColor;

  final Color selectedNavColor;
  final Color unselectedNavColor;

  final Color progressColor;
  final Color proteinDisplayColor;
  final Color carbsDisplayColor;
  final Color fatDisplayColor;

  final Color expiredAlertColor;
  final Color expiredAlertOutlineColor;
  final Color expiredAlertIconColor;
  final Color mealPrepAlertColor;
  final Color mealPrepAlertOutlineColor;
  final Color mealPrepAlertIconColor;

  final Color quickAccessIngredientOutlineColor;
  final Color quickAccessIngredientColor;
  final Color quickAccessMealOutlineColor;
  final Color quickAccessMealColor;
  final Color quickAccessPlanOutlineColor;
  final Color quickAccessPlanColor;

  final Color selectedSecondaryTabColor;
  final Color selectedSecondaryTabTextColor;
  final Color unselectedSecondaryTabColor;
  final Color unselectedSecondaryTabTextColor;

  final Color selectedPrimaryTabColor;
  final Color selectedPrimaryTabTextColor;
  final Color unselectedPrimaryTabColor;
  final Color unselectedPrimaryTabTextColor;

  final Color normalIconColor;

  final Color completedColor;
  final Color completedTextColor;
  final Color currentColor;
  final Color currentTextColor;
  final Color upcomingColor;
  final Color upcomingTextColor;

  final Color favoriteColor;

  final Color buttonColor;
  final Color buttonContentColor;
  final Color secondaryButtonColor;
  final Color secondaryButtonContentColor;
  final Color dangerButtonColor;
  final Color dangerButtonContentColor;

  final Color highlightedContainerColor;
  final Color highlightedTextColor;
  final Color highlightedContentColor;

  final Color backgroundColor;
  final Color appbarColor;

  final Color mainContainerColor;
  final Color imagePickerColor;

  const ThemeColors({
    required this.customPrimary,
    required this.customBackground,
    required this.errorCard,
    required this.testTextColor,
    required this.testBackgroundColor,
    required this.testButtonColor,
    required this.pantrypalTitle,
    required this.notiAlertColor,
    required this.textPrimaryColor,
    required this.hintTextColor,
    required this.goodStatusColor,
    required this.badStatusColor,
    required this.warningStatusColor,
    required this.excellentMatchColor,
    required this.goodMatchColor,
    required this.mediumMatchColor,
    required this.badMatchColor,
    required this.selectedNavColor,
    required this.unselectedNavColor,
    required this.progressColor,
    required this.proteinDisplayColor,
    required this.carbsDisplayColor,
    required this.fatDisplayColor,
    required this.expiredAlertColor,
    required this.expiredAlertOutlineColor,
    required this.expiredAlertIconColor,
    required this.mealPrepAlertColor,
    required this.mealPrepAlertOutlineColor,
    required this.mealPrepAlertIconColor,
    required this.quickAccessIngredientOutlineColor,
    required this.quickAccessIngredientColor,
    required this.quickAccessMealOutlineColor,
    required this.quickAccessMealColor,
    required this.quickAccessPlanOutlineColor,
    required this.quickAccessPlanColor,
    required this.selectedSecondaryTabColor,
    required this.selectedSecondaryTabTextColor,
    required this.unselectedSecondaryTabColor,
    required this.unselectedSecondaryTabTextColor,
    required this.selectedPrimaryTabColor,
    required this.selectedPrimaryTabTextColor,
    required this.unselectedPrimaryTabColor,
    required this.unselectedPrimaryTabTextColor,
    required this.normalIconColor,
    required this.completedColor,
    required this.completedTextColor,
    required this.currentColor,
    required this.currentTextColor,
    required this.upcomingColor,
    required this.upcomingTextColor,
    required this.favoriteColor,
    required this.buttonColor,
    required this.buttonContentColor,
    required this.secondaryButtonColor,
    required this.secondaryButtonContentColor,
    required this.dangerButtonColor,
    required this.dangerButtonContentColor,
    required this.highlightedContainerColor,
    required this.highlightedTextColor,
    required this.highlightedContentColor,
    required this.backgroundColor,
    required this.appbarColor,
    required this.mainContainerColor,
    required this.imagePickerColor,
  });

  @override
  ThemeColors copyWith({
    Color? customPrimary,
    Color? customBackground,
    Color? errorCard,
    Color? testTextColor,
    Color? testBackgroundColor,
    Color? testButtonColor,
    Color? pantrypalTitle,
    Color? notiAlertColor,
    Color? textPrimaryColor,
    Color? hintTextColor,
    Color? goodStatusColor,
    Color? badStatusColor,
    Color? warningStatusColor,
    Color? excellentMatchColor,
    Color? goodMatchColor,
    Color? mediumMatchColor,
    Color? badMatchColor,
    Color? selectedNavColor,
    Color? unselectedNavColor,
    Color? progressColor,
    Color? proteinDisplayColor,
    Color? carbsDisplayColor,
    Color? fatDisplayColor,
    Color? expiredAlertColor,
    Color? expiredAlertOutlineColor,
    Color? expiredAlertIconColor,
    Color? mealPrepAlertColor,
    Color? mealPrepAlertOutlineColor,
    Color? mealPrepAlertIconColor,
    Color? quickAccessIngredientOutlineColor,
    Color? quickAccessIngredientColor,
    Color? quickAccessMealOutlineColor,
    Color? quickAccessMealColor,
    Color? quickAccessPlanOutlineColor,
    Color? quickAccessPlanColor,
    Color? selectedSecondaryTabColor,
    Color? selectedSecondaryTabTextColor,
    Color? unselectedSecondaryTabColor,
    Color? unselectedSecondaryTabTextColor,
    Color? selectedPrimaryTabColor,
    Color? selectedPrimaryTabTextColor,
    Color? unselectedPrimaryTabColor,
    Color? unselectedPrimaryTabTextColor,
    Color? normalIconColor,
    Color? completedColor,
    Color? completedTextColor,
    Color? currentColor,
    Color? currentTextColor,
    Color? upcomingColor,
    Color? upcomingTextColor,
    Color? favoriteColor,
    Color? buttonColor,
    Color? buttonContentColor,
    Color? secondaryButtonColor,
    Color? secondaryButtonContentColor,
    Color? dangerButtonColor,
    Color? dangerButtonContentColor,
    Color? highlightedContainerColor,
    Color? highlightedTextColor,
    Color? highlightedContentColor,
    Color? backgroundColor,
    Color? appbarColor,
    Color? mainContainerColor,
    Color? imagePickerColor,
  }) {
    return ThemeColors(
      customPrimary: customPrimary ?? this.customPrimary,
      customBackground: customBackground ?? this.customBackground,
      errorCard: errorCard ?? this.errorCard,
      testTextColor: testTextColor ?? this.testTextColor,
      testBackgroundColor: testBackgroundColor ?? this.testBackgroundColor,
      testButtonColor: testButtonColor ?? this.testButtonColor,
      pantrypalTitle: pantrypalTitle ?? this.pantrypalTitle,
      notiAlertColor: notiAlertColor ?? this.notiAlertColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      goodStatusColor: goodStatusColor ?? this.goodStatusColor,
      badStatusColor: badStatusColor ?? this.badStatusColor,
      warningStatusColor: warningStatusColor ?? this.warningStatusColor,
      excellentMatchColor: excellentMatchColor ?? this.excellentMatchColor,
      goodMatchColor: goodMatchColor ?? this.goodMatchColor,
      mediumMatchColor: mediumMatchColor ?? this.mediumMatchColor,
      badMatchColor: badMatchColor ?? this.badMatchColor,
      selectedNavColor: selectedNavColor ?? this.selectedNavColor,
      unselectedNavColor: unselectedNavColor ?? this.unselectedNavColor,
      progressColor: progressColor ?? this.progressColor,
      proteinDisplayColor: proteinDisplayColor ?? this.proteinDisplayColor,
      carbsDisplayColor: carbsDisplayColor ?? this.carbsDisplayColor,
      fatDisplayColor: fatDisplayColor ?? this.fatDisplayColor,
      expiredAlertColor: expiredAlertColor ?? this.expiredAlertColor,
      expiredAlertOutlineColor: expiredAlertOutlineColor ?? this.expiredAlertOutlineColor,
      expiredAlertIconColor: expiredAlertIconColor ?? this.expiredAlertIconColor,
      mealPrepAlertColor: mealPrepAlertColor ?? this.mealPrepAlertColor,
      mealPrepAlertOutlineColor: mealPrepAlertOutlineColor ?? this.mealPrepAlertOutlineColor,
      mealPrepAlertIconColor: mealPrepAlertIconColor ?? this.mealPrepAlertIconColor,
      quickAccessIngredientOutlineColor: quickAccessIngredientOutlineColor ?? this.quickAccessIngredientOutlineColor,
      quickAccessIngredientColor: quickAccessIngredientColor ?? this.quickAccessIngredientColor,
      quickAccessMealOutlineColor: quickAccessMealOutlineColor ?? this.quickAccessMealOutlineColor,
      quickAccessMealColor: quickAccessMealColor ?? this.quickAccessMealColor,
      quickAccessPlanOutlineColor: quickAccessPlanOutlineColor ?? this.quickAccessPlanOutlineColor,
      quickAccessPlanColor: quickAccessPlanColor ?? this.quickAccessPlanColor,
      selectedSecondaryTabColor: selectedSecondaryTabColor ?? this.selectedSecondaryTabColor,
      selectedSecondaryTabTextColor: selectedSecondaryTabTextColor ?? this.selectedSecondaryTabTextColor,
      unselectedSecondaryTabColor: unselectedSecondaryTabColor ?? this.unselectedSecondaryTabColor,
      unselectedSecondaryTabTextColor: unselectedSecondaryTabTextColor ?? this.unselectedSecondaryTabTextColor,
      selectedPrimaryTabColor: selectedPrimaryTabColor ?? this.selectedPrimaryTabColor,
      selectedPrimaryTabTextColor: selectedPrimaryTabTextColor ?? this.selectedPrimaryTabTextColor,
      unselectedPrimaryTabColor: unselectedPrimaryTabColor ?? this.unselectedPrimaryTabColor,
      unselectedPrimaryTabTextColor: unselectedPrimaryTabTextColor ?? this.unselectedPrimaryTabTextColor,
      normalIconColor: normalIconColor ?? this.normalIconColor,
      completedColor: completedColor ?? this.completedColor,
      completedTextColor: completedTextColor ?? this.completedTextColor,
      currentColor: currentColor ?? this.currentColor,
      currentTextColor: currentTextColor ?? this.currentTextColor,
      upcomingColor: upcomingColor ?? this.upcomingColor,
      upcomingTextColor: upcomingTextColor ?? this.upcomingTextColor,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonContentColor: buttonContentColor ?? this.buttonContentColor,
      secondaryButtonColor: secondaryButtonColor ?? this.secondaryButtonColor,
      secondaryButtonContentColor: secondaryButtonContentColor ?? this.secondaryButtonContentColor,
      dangerButtonColor: dangerButtonColor ?? this.dangerButtonColor,
      dangerButtonContentColor: dangerButtonContentColor ?? this.dangerButtonContentColor,
      highlightedContainerColor: highlightedContainerColor ?? this.highlightedContainerColor,
      highlightedTextColor: highlightedTextColor ?? this.highlightedTextColor,
      highlightedContentColor: highlightedContentColor ?? this.highlightedContentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      appbarColor: appbarColor ?? this.appbarColor,
      mainContainerColor: mainContainerColor ?? this.mainContainerColor,
      imagePickerColor: imagePickerColor ?? this.imagePickerColor,
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
      pantrypalTitle: Color.lerp(pantrypalTitle, other.pantrypalTitle, t)!,
      notiAlertColor: Color.lerp(notiAlertColor, other.notiAlertColor, t)!,
      textPrimaryColor: Color.lerp(textPrimaryColor, other.textPrimaryColor, t)!,
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t)!,
      goodStatusColor: Color.lerp(goodStatusColor, other.goodStatusColor, t)!,
      badStatusColor: Color.lerp(badStatusColor, other.badStatusColor, t)!,
      warningStatusColor: Color.lerp(warningStatusColor, other.warningStatusColor, t)!,
      excellentMatchColor: Color.lerp(excellentMatchColor, other.excellentMatchColor, t)!,
      goodMatchColor: Color.lerp(goodMatchColor, other.goodMatchColor, t)!,
      mediumMatchColor: Color.lerp(mediumMatchColor, other.mediumMatchColor, t)!,
      badMatchColor: Color.lerp(badMatchColor, other.badMatchColor, t)!,
      selectedNavColor: Color.lerp(selectedNavColor, other.selectedNavColor, t)!,
      unselectedNavColor: Color.lerp(unselectedNavColor, other.unselectedNavColor, t)!,
      progressColor: Color.lerp(progressColor, other.progressColor, t)!,
      proteinDisplayColor: Color.lerp(proteinDisplayColor, other.proteinDisplayColor, t)!,
      carbsDisplayColor: Color.lerp(carbsDisplayColor, other.carbsDisplayColor, t)!,
      fatDisplayColor: Color.lerp(fatDisplayColor, other.fatDisplayColor, t)!,
      expiredAlertColor: Color.lerp(expiredAlertColor, other.expiredAlertColor, t)!,
      expiredAlertOutlineColor: Color.lerp(expiredAlertOutlineColor, other.expiredAlertOutlineColor, t)!,
      expiredAlertIconColor: Color.lerp(expiredAlertIconColor, other.expiredAlertIconColor, t)!,
      mealPrepAlertColor: Color.lerp(mealPrepAlertColor, other.mealPrepAlertColor, t)!,
      mealPrepAlertOutlineColor: Color.lerp(mealPrepAlertOutlineColor, other.mealPrepAlertOutlineColor, t)!,
      mealPrepAlertIconColor: Color.lerp(mealPrepAlertIconColor, other.mealPrepAlertIconColor, t)!,
      quickAccessIngredientOutlineColor: Color.lerp(quickAccessIngredientOutlineColor, other.quickAccessIngredientOutlineColor, t)!,
      quickAccessIngredientColor: Color.lerp(quickAccessIngredientColor, other.quickAccessIngredientColor, t)!,
      quickAccessMealOutlineColor: Color.lerp(quickAccessMealOutlineColor, other.quickAccessMealOutlineColor, t)!,
      quickAccessMealColor: Color.lerp(quickAccessMealColor, other.quickAccessMealColor, t)!,
      quickAccessPlanOutlineColor: Color.lerp(quickAccessPlanOutlineColor, other.quickAccessPlanOutlineColor, t)!,
      quickAccessPlanColor: Color.lerp(quickAccessPlanColor, other.quickAccessPlanColor, t)!,
      selectedSecondaryTabColor: Color.lerp(selectedSecondaryTabColor, other.selectedSecondaryTabColor, t)!,
      selectedSecondaryTabTextColor: Color.lerp(selectedSecondaryTabTextColor, other.selectedSecondaryTabTextColor, t)!,
      unselectedSecondaryTabColor: Color.lerp(unselectedSecondaryTabColor, other.unselectedSecondaryTabColor, t)!,
      unselectedSecondaryTabTextColor: Color.lerp(unselectedSecondaryTabTextColor, other.unselectedSecondaryTabTextColor, t)!,
      selectedPrimaryTabColor: Color.lerp(selectedPrimaryTabColor, other.selectedPrimaryTabColor, t)!,
      selectedPrimaryTabTextColor: Color.lerp(selectedPrimaryTabTextColor, other.selectedPrimaryTabTextColor, t)!,
      unselectedPrimaryTabColor: Color.lerp(unselectedPrimaryTabColor, other.unselectedPrimaryTabColor, t)!,
      unselectedPrimaryTabTextColor: Color.lerp(unselectedPrimaryTabTextColor, other.unselectedPrimaryTabTextColor, t)!,
      normalIconColor: Color.lerp(normalIconColor, other.normalIconColor, t)!,
      completedColor: Color.lerp(completedColor, other.completedColor, t)!,
      completedTextColor: Color.lerp(completedTextColor, other.completedTextColor, t)!,
      currentColor: Color.lerp(currentColor, other.currentColor, t)!,
      currentTextColor: Color.lerp(currentTextColor, other.currentTextColor, t)!,
      upcomingColor: Color.lerp(upcomingColor, other.upcomingColor, t)!,
      upcomingTextColor: Color.lerp(upcomingTextColor, other.upcomingTextColor, t)!,
      favoriteColor: Color.lerp(favoriteColor, other.favoriteColor, t)!,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t)!,
      buttonContentColor: Color.lerp(buttonContentColor, other.buttonContentColor, t)!,
      secondaryButtonColor: Color.lerp(secondaryButtonColor, other.secondaryButtonColor, t)!,
      secondaryButtonContentColor: Color.lerp(secondaryButtonContentColor, other.secondaryButtonContentColor, t)!,
      dangerButtonColor: Color.lerp(dangerButtonColor, other.dangerButtonColor, t)!,
      dangerButtonContentColor: Color.lerp(dangerButtonContentColor, other.dangerButtonContentColor, t)!,
      highlightedContainerColor: Color.lerp(highlightedContainerColor, other.highlightedContainerColor, t)!,
      highlightedTextColor: Color.lerp(highlightedTextColor, other.highlightedTextColor, t)!,
      highlightedContentColor: Color.lerp(highlightedContentColor, other.highlightedContentColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      appbarColor: Color.lerp(appbarColor, other.appbarColor, t)!,
      mainContainerColor: Color.lerp(mainContainerColor, other.mainContainerColor, t)!,
      imagePickerColor: Color.lerp(imagePickerColor, other.imagePickerColor, t)!,
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

    pantrypalTitle: CustomColors.primary600,
    notiAlertColor: CustomColors.primary600,
    textPrimaryColor: CustomColors.neutral950,
    hintTextColor: CustomColors.neutral500,
    goodStatusColor: CustomColors.primary500,
    badStatusColor: CustomColors.error,
    warningStatusColor: CustomColors.warning,
    excellentMatchColor: CustomColors.success,
    goodMatchColor: CustomColors.primary400,
    mediumMatchColor: CustomColors.warning,
    badMatchColor: CustomColors.error,
    selectedNavColor: CustomColors.primary700,
    unselectedNavColor: CustomColors.neutral950,
    progressColor: CustomColors.primary500,
    proteinDisplayColor: CustomColors.secondary100,
    carbsDisplayColor: CustomColors.accent100,
    fatDisplayColor: CustomColors.primary100,
    expiredAlertColor: CustomColors.accent100,
    expiredAlertOutlineColor: CustomColors.accent300,
    expiredAlertIconColor: CustomColors.accent600,
    mealPrepAlertColor: CustomColors.primary100,
    mealPrepAlertOutlineColor: CustomColors.primary200,
    mealPrepAlertIconColor: CustomColors.primary500,
    quickAccessIngredientOutlineColor: CustomColors.secondary100,
    quickAccessIngredientColor: CustomColors.secondary500,
    quickAccessMealOutlineColor: CustomColors.lightPurple,
    quickAccessMealColor: CustomColors.darkPurple,
    quickAccessPlanOutlineColor: CustomColors.primary100,
    quickAccessPlanColor: CustomColors.primary500,
    selectedSecondaryTabColor: CustomColors.neutral50,
    selectedSecondaryTabTextColor: CustomColors.neutral900,
    unselectedSecondaryTabColor: CustomColors.neutral200,
    unselectedSecondaryTabTextColor: CustomColors.neutral500,
    selectedPrimaryTabColor: CustomColors.neutral50,
    selectedPrimaryTabTextColor: CustomColors.primary500,
    unselectedPrimaryTabColor: CustomColors.neutral300,
    unselectedPrimaryTabTextColor: CustomColors.neutral500,
    normalIconColor: CustomColors.neutral950,
    completedColor: CustomColors.primary100,
    completedTextColor: CustomColors.primary500,
    currentColor: CustomColors.secondary200,
    currentTextColor: CustomColors.secondary600,
    upcomingColor: CustomColors.neutral200,
    upcomingTextColor: CustomColors.neutral900,
    favoriteColor: CustomColors.yellow,
    buttonColor: CustomColors.primary500,
    buttonContentColor: CustomColors.neutral50,
    secondaryButtonColor: CustomColors.neutral0,
    secondaryButtonContentColor: CustomColors.neutral950,
    dangerButtonColor: CustomColors.error,
    dangerButtonContentColor: CustomColors.neutral50,
    highlightedContainerColor: CustomColors.primary500,
    highlightedTextColor: CustomColors.primary500,
    highlightedContentColor: CustomColors.neutral50,
    backgroundColor: CustomColors.neutral100,
    appbarColor: CustomColors.neutral0,
    mainContainerColor: CustomColors.neutral0,
    imagePickerColor: CustomColors.neutral200,
  );

  static const dark = ThemeColors(
    customPrimary: Colors.deepPurple,
    customBackground: Colors.black,
    errorCard: Colors.red,
    testTextColor: Colors.white,
    testBackgroundColor: Colors.black,
    testButtonColor: Colors.deepPurple,

    pantrypalTitle: Colors.black,
    notiAlertColor: Colors.black,
    textPrimaryColor: Colors.black,
    hintTextColor: Colors.black,
    goodStatusColor: Colors.black,
    badStatusColor: Colors.black,
    warningStatusColor: Colors.black,
    excellentMatchColor: Colors.black,
    goodMatchColor: Colors.black,
    mediumMatchColor: Colors.black,
    badMatchColor: Colors.black,
    selectedNavColor: Colors.black,
    unselectedNavColor: Colors.black,
    progressColor: Colors.black,
    proteinDisplayColor: Colors.black,
    carbsDisplayColor: Colors.black,
    fatDisplayColor: Colors.black,
    expiredAlertColor: Colors.black,
    expiredAlertOutlineColor: Colors.black,
    expiredAlertIconColor: Colors.black,
    mealPrepAlertColor: Colors.black,
    mealPrepAlertOutlineColor: Colors.black,
    mealPrepAlertIconColor: Colors.black,
    quickAccessIngredientOutlineColor: Colors.black,
    quickAccessIngredientColor: Colors.black,
    quickAccessMealOutlineColor: Colors.black,
    quickAccessMealColor: Colors.black,
    quickAccessPlanOutlineColor: Colors.black,
    quickAccessPlanColor: Colors.black,
    selectedSecondaryTabColor: Colors.black,
    selectedSecondaryTabTextColor: Colors.black,
    unselectedSecondaryTabColor: Colors.black,
    unselectedSecondaryTabTextColor: Colors.black,
    selectedPrimaryTabColor: Colors.black,
    selectedPrimaryTabTextColor: Colors.black,
    unselectedPrimaryTabColor: Colors.black,
    unselectedPrimaryTabTextColor: Colors.black,
    normalIconColor: Colors.black,
    completedColor: Colors.black,
    completedTextColor: Colors.black,
    currentColor: Colors.black,
    currentTextColor: Colors.black,
    upcomingColor: Colors.black,
    upcomingTextColor: Colors.black,
    favoriteColor: Colors.black,
    buttonColor: Colors.black,
    buttonContentColor: Colors.black,
    secondaryButtonColor: Colors.black,
    secondaryButtonContentColor: Colors.black,
    dangerButtonColor: Colors.black,
    dangerButtonContentColor: Colors.black,
    highlightedContainerColor: Colors.black,
    highlightedTextColor: Colors.black,
    highlightedContentColor: Colors.black,
    backgroundColor: Colors.black,
    appbarColor: Colors.black,
    mainContainerColor: Colors.black,
    imagePickerColor: Colors.black,
  );
}
