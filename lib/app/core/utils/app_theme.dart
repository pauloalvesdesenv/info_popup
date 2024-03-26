import 'package:programacao/app/core/utils/app_colors.dart';
import 'package:programacao/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      fontFamily: 'WorkSans',
      colorSchemeSeed: AppColors.primaryMain,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xFFBFD0D0),
        selectionColor: const Color(0xFFBFD0D0).withOpacity(0.3),
        selectionHandleColor: const Color(0xFFBFD0D0),
      ),
      datePickerTheme: DatePickerThemeData(
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryMain;
          }
          return null;
        }),
        backgroundColor: AppColors.neutralMedium,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.disabled)
                    ? AppColors.neutralMedium
                    : AppColors.primaryMain),
            textStyle: MaterialStatePropertyAll(
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
                    .setColor(AppColors.neutralLightest)),
            foregroundColor: MaterialStatePropertyAll(AppColors.white),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: AppCss.radius8))),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            AppColors.primaryMain,
          ),
          foregroundColor: MaterialStatePropertyAll(AppColors.white),
          iconSize: const MaterialStatePropertyAll(24),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: AppCss.radius8)),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.neutralMedium, width: 1),
            borderRadius: AppCss.radius8,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryMain, width: 2),
            borderRadius: AppCss.radius8,
          ),
          hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.neutralMedium)),
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryMain,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: AppColors.primaryMain,
          shadowColor: Colors.transparent));
}
