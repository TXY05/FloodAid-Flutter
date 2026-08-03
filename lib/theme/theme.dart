import 'package:floodaid_flutter/theme/colors.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.purple40,
    onPrimary: Colors.white,

    secondary: AppColors.purpleGrey40,
    onSecondary: Colors.white,

    tertiary: AppColors.pink40,

    surface: AppColors.blue40,
    onSurface: AppColors.darkBlue40,
  ),
  scaffoldBackgroundColor: AppColors.blueGrey40,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: AppColors.purple80,
    onPrimary: Colors.black,

    secondary: AppColors.purpleGrey80,
    onSecondary: Colors.black,

    tertiary: AppColors.pink80,

    surface: AppColors.blue80,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.blueGrey80,
);
