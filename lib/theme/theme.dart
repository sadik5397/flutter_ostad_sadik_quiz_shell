import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AppTheme {
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Rubik',
    fontFamilyFallback: ['NotoSansBengali'],
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Rubik', fontFamilyFallback: ['NotoSansBengali']),
    useMaterial3: true,
    colorScheme: // LIGHT MODE COLOR SCHEME
    ColorScheme(
      brightness: Brightness.light,

      // Primary Colors (FIXED)
      primary: Color(0xff0866ff),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdae2ff),
      onPrimaryContainer: Color(0xff001849),
      inversePrimary: Color(0xffb0c6ff),

      // Primary Fixed Colors (FIXED)
      primaryFixed: Color(0xff0866ff),
      primaryFixedDim: Color(0xff0554d9),
      onPrimaryFixed: Color(0xffffffff),
      onPrimaryFixedVariant: Color(0xff003d99),

      // Secondary Colors (FIXED)
      secondary: Color(0xff83b2ff),
      onSecondary: Color(0xff0047bb),
      secondaryContainer: Color(0xffcde0ff),
      onSecondaryContainer: Color(0xff0866FF),

      // Secondary Fixed Colors (FIXED)
      secondaryFixed: Color(0xff83b2ff),
      secondaryFixedDim: Color(0xff0047bb),
      onSecondaryFixed: Color(0xffcde0ff),
      onSecondaryFixedVariant: Color(0xff0866FF),

      // Tertiary Colors (FIXED)
      tertiary: Color(0xff705575),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffbd7fc),
      onTertiaryContainer: Color(0xff28132e),

      // Tertiary Fixed Colors (FIXED)
      tertiaryFixed: Color(0xff705575),
      tertiaryFixedDim: Color(0xff5d4661),
      onTertiaryFixed: Color(0xffffffff),
      onTertiaryFixedVariant: Color(0xff4a374d),

      // Error Colors
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),

      // Surface Colors
      surface: Color(0xfffbf8ff),
      surfaceDim: Color(0xffdbd9e0),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2fa),
      surfaceContainer: Color(0xffefecf4),
      surfaceContainerHigh: Color(0xffe9e7ee),
      surfaceContainerHighest: Color(0xffe4e1e9),
      onSurface: Color(0xff1a1b20),
      surfaceTint: Color(0xff0866ff),
      onSurfaceVariant: Color(0xff44474e),
      inverseSurface: Color(0xff2f3036),

      // Outline Colors
      outline: Color(0xff75777f),
      outlineVariant: Color(0xffc5c6d0),

      // Utility Colors
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Rubik',
    fontFamilyFallback: ['NotoSansBengali'],
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Rubik', fontFamilyFallback: ['NotoSansBengali']),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,

      // Primary Colors (FIXED)
      primary: Color(0xff0866ff),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00419d),
      onPrimaryContainer: Color(0xffdae2ff),
      inversePrimary: Color(0xffb0c6ff),

      // Primary Fixed Colors (FIXED)
      primaryFixed: Color(0xff0866ff),
      primaryFixedDim: Color(0xff0554d9),
      onPrimaryFixed: Color(0xffffffff),
      onPrimaryFixedVariant: Color(0xff003d99),

      // Secondary Colors (FIXED)
      secondary: Color(0xff83b2ff),
      onSecondary: Color(0xff0047bb),
      secondaryContainer: Color(0xff0866ff),
      onSecondaryContainer: Color(0xffffffff),

      // Secondary Fixed Colors (FIXED)
      secondaryFixed: Color(0xff83b2ff),
      secondaryFixedDim: Color(0xff0047bb),
      onSecondaryFixed: Color(0xffcde0ff),
      onSecondaryFixedVariant: Color(0xff0866FF),

      // Tertiary Colors (FIXED)
      tertiary: Color(0xff705575),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4a374d),
      onTertiaryContainer: Color(0xfffbd7fc),

      // Tertiary Fixed Colors (FIXED)
      tertiaryFixed: Color(0xff705575),
      tertiaryFixedDim: Color(0xff5d4661),
      onTertiaryFixed: Color(0xffffffff),
      onTertiaryFixedVariant: Color(0xff4a374d),

      // Error Colors
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),

      // Surface Colors
      surface: Color(0xff121318),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393e),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
      onSurface: Color(0xffe4e1e9),
      surfaceTint: Color(0xff0866ff),
      onSurfaceVariant: Color(0xffc5c6d0),
      inverseSurface: Color(0xffe4e1e9),

      // Outline Colors
      outline: Color(0xff8f9099),
      outlineVariant: Color(0xff44474e),

      // Utility Colors
      shadow: Color(0xffffffff),
      scrim: Color(0xff000000),
    ),
  );

  static void updateSystemUI(BuildContext context) => SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Theme.of(context).brightness),
  );
}

// static ThemeData light = ThemeData(
//   brightness: Brightness.light,
//   fontFamily: 'Rubik',
//   fontFamilyFallback: ['NotoSans'],
//   textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Rubik', fontFamilyFallback: ['NotoSans']),
//   useMaterial3: true,
//   colorScheme: ColorScheme(
//     brightness: Brightness.light,
//
//     //----
//     primary: Color(0xff0866ff),
//     onPrimary: Color(0xffffffff),
//     primaryContainer: Color(0xffe8ddff),
//     onPrimaryContainer: Color(0xff1d0051),
//     inversePrimary: Color(0xffc9aaff),
//
//     //----
//     primaryFixed: Color(0xff0866ff),
//     primaryFixedDim: Color(0xffc9aaff),
//     onPrimaryFixed: Color(0xffffffff),
//     onPrimaryFixedVariant: Color(0xff3f009e),
//
//     //----
//     secondary: Color(0xff0063E6),
//     onSecondary: Color(0xffffffff),
//     secondaryContainer: Color(0xffd7e5ff),
//     onSecondaryContainer: Color(0xff001c3d),
//
//     //----
//     secondaryFixed: Color(0xffd7e5ff),
//     secondaryFixedDim: Color(0xffaac7ff),
//     onSecondaryFixed: Color(0xff001c3d),
//     onSecondaryFixedVariant: Color(0xff004bb5),
//
//     //----
//     tertiary: Color(0xff7e4fb3),
//     onTertiary: Color(0xffffffff),
//     tertiaryContainer: Color(0xfff3ddff),
//     onTertiaryContainer: Color(0xff2f004d),
//
//     //----
//     tertiaryFixed: Color(0xfff3ddff),
//     tertiaryFixedDim: Color(0xffe0b8ff),
//     onTertiaryFixed: Color(0xff2f004d),
//     onTertiaryFixedVariant: Color(0xff643799),
//
//     //----
//     error: Color(0xffC0392B),
//     onError: Color(0xffffffff),
//     errorContainer: Color(0xffffdad5),
//     onErrorContainer: Color(0xff410002),
//
//     //----
//     surface: Color(0xfffafafa),
//     surfaceDim: Color(0xffd6dbd5),
//     surfaceBright: Color(0xfff6fbf4),
//     surfaceContainerLowest: Color(0xffffffff),
//     surfaceContainerLow: Color(0xfff0f5ee),
//     surfaceContainer: Color(0xffeaefe9),
//     surfaceContainerHigh: Color(0xffe4eae3),
//     surfaceContainerHighest: Color(0xffdfe4dd),
//     onSurface: Color(0xff171d19),
//     surfaceTint: Color(0xff5500cc),
//     onSurfaceVariant: Color(0xff48454e),
//     inverseSurface: Color(0xff2f3033),
//
//     //----
//     outline: Color(0xff707972),
//     outlineVariant: Color(0xffc0c9c1),
//
//     //----
//     shadow: Color(0xff000000),
//     scrim: Color(0xff000000),
//   ),
// );
//
// static ThemeData dark = ThemeData(
//   brightness: Brightness.dark,
//   useMaterial3: true,
//   fontFamily: 'Rubik',
//   fontFamilyFallback: ['NotoSans'],
//   textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Rubik', fontFamilyFallback: ['NotoSans']),
//   colorScheme: ColorScheme(
//     brightness: Brightness.dark,
//
//     //----
//     primary: Color(0xffc9aaff),
//     onPrimary: Color(0xff330085),
//     primaryContainer: Color(0xff3f009e),
//     onPrimaryContainer: Color(0xffe8ddff),
//
//     //----
//     primaryFixed: Color(0xff5500cc),
//     primaryFixedDim: Color(0xffc9aaff),
//     onPrimaryFixed: Color(0xffffffff),
//     onPrimaryFixedVariant: Color(0xff3f009e),
//     inversePrimary: Color(0xff5500cc),
//
//     //----
//     secondary: Color(0xffaac7ff),
//     onSecondary: Color(0xff003063),
//     secondaryContainer: Color(0xff004bb5),
//     onSecondaryContainer: Color(0xffd7e5ff),
//
//     //----
//     secondaryFixed: Color(0xffd7e5ff),
//     secondaryFixedDim: Color(0xffaac7ff),
//     onSecondaryFixed: Color(0xff001c3d),
//     onSecondaryFixedVariant: Color(0xff004bb5),
//
//     //----
//     tertiary: Color(0xffe0b8ff),
//     onTertiary: Color(0xff49167a),
//     tertiaryContainer: Color(0xff643799),
//     onTertiaryContainer: Color(0xfff3ddff),
//
//     //----
//     tertiaryFixed: Color(0xfff3ddff),
//     tertiaryFixedDim: Color(0xffe0b8ff),
//     onTertiaryFixed: Color(0xff2f004d),
//     onTertiaryFixedVariant: Color(0xff643799),
//
//     //----
//     error: Color(0xffE74C3C),
//     onError: Color(0xff690005),
//     errorContainer: Color(0xff93000a),
//     onErrorContainer: Color(0xffffdad5),
//
//     //----
//     surface: Color(0xff121212),
//     surfaceDim: Color(0xff121212),
//     surfaceBright: Color(0xff383838),
//     surfaceContainerLowest: Color(0xff0d0d0d),
//     surfaceContainerLow: Color(0xff1a1a1a),
//     surfaceContainer: Color(0xff1e1e1e),
//     surfaceContainerHigh: Color(0xff292929),
//     surfaceContainerHighest: Color(0xff333333),
//     onSurface: Color(0xffe3e3e3),
//     surfaceTint: Color(0xffc9aaff),
//     onSurfaceVariant: Color(0xffc7c5cf),
//     inverseSurface: Color(0xffe3e3e3),
//
//     //----
//     outline: Color(0xff8a938b),
//     outlineVariant: Color(0xff48454e),
//
//     //----
//     shadow: Color(0xff000000),
//     scrim: Color(0xff000000),
//   ),
// );
