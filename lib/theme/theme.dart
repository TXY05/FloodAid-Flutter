import 'package:floodaid_flutter/theme/colors.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.purple40,
    onPrimary: Colors.black,

    secondary: AppColors.purpleGrey40,
    onSecondary: Colors.black,

    tertiary: AppColors.pink40,

    surface: AppColors.blue40,
    onSurface: Colors.black,

  ),
  scaffoldBackgroundColor: AppColors.blueGrey40,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: AppColors.purple80,
    onPrimary: Colors.black,

    secondary: AppColors.purpleGrey80,
    onSecondary: AppColors.grey80,

    tertiary: AppColors.darkBlue80,

    surface: AppColors.blue80,
    onSurface: AppColors.grey80,
  ),
  scaffoldBackgroundColor: AppColors.blueGrey80,
);
