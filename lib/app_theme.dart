import 'package:flutter/material.dart';

import 'constants.dart';

final lightThemeDate = ThemeData(
  fontFamily: 'Cairo',
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,//Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,//Colors.grey.shade200,
  appBarTheme: AppBarTheme(
    // backgroundColor: Colors.white,
    foregroundColor: AppColors.primary,
    // elevation: 1,
    iconTheme: IconThemeData(color: AppColors.primary),
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

);
final darkThemeDate = ThemeData(
  fontFamily: 'Cairo',
  brightness: Brightness.dark,
  primaryColor: AppColors.secondary,
  colorScheme: ColorScheme.dark(
      primary: AppColors.secondary,
      secondary: AppColors.secondary,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(
      color: Colors.white
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.white
      )
    ),
    menuStyle: MenuStyle(

    )
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: AppColors.secondary,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.secondary),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

);


// ThemeData(
// fontFamily: 'Cairo',
// brightness: Brightness.light,
// colorScheme: ColorScheme.light(
// primary: AppColors.primary,
// secondary: AppColors.secondary,
// onPrimary: Colors.white,
// onSecondary: Colors.white,
// surface: AppColors.background,
// ),
// scaffoldBackgroundColor: Colors.white,//Colors.black,
// // canvasColor: Colors.white12,
// appBarTheme: AppBarTheme(
// backgroundColor: AppColors.primary,
// foregroundColor: Colors.white,
// ),
// ),