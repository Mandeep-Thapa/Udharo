import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  // colors
  Color backgroundColor = const Color(0xff0F1717);
  Color primaryColor = const Color(0xff2F3833);
  Color secondaryColor = const Color(0xff03CC87);
  Color navigationbarColor = const Color(0xff1C2924);

  Color textColorWhite = const Color(0xff8E9994);
  Color textColorBlack = const Color(0xff0F1717);
  Color headingColor = const Color(0xffFFFFFF);
  Color errorColor = const Color(0xffD70040);

  // default theme
  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.primaryColor,
      secondary: _themeClass.secondaryColor,
    ),
    fontFamily: GoogleFonts.inter().fontFamily,

    // buttons theme
    elevatedButtonTheme: _themeClass._elevatedButtonThemeData(),
    textButtonTheme: _themeClass._textButtonThemeData(),

    // input decoration theme
    inputDecorationTheme: _themeClass._inputDecorationTheme(),

    // text selection theme
    textSelectionTheme: _themeClass._textSelectionThemeData(),

    // snackbar theme
    snackBarTheme: _themeClass._snackBarThemeData(),

    // bottom app bar theme
    bottomAppBarTheme: _themeClass._bottomAppBarTheme(),

    dividerColor: _themeClass.primaryColor,
  );

  // functions:

  // elevated button theme
  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 16.0)),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            // background color for disabled state
            return _themeClass.navigationbarColor;
          }
          // return color for enabled state
          return _themeClass.secondaryColor;
        }),
        minimumSize:
            const WidgetStatePropertyAll<Size>(Size(double.infinity, 50.0)),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  // text button theme
  TextButtonThemeData _textButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            WidgetStatePropertyAll<Color>(_themeClass.textColorWhite),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      ),
    );
  }

  // input decoration theme
  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: _themeClass.primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _themeClass.errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _themeClass.errorColor,
        ),
      ),
      labelStyle: TextStyle(
        color: _themeClass.textColorWhite,
      ),
      hintStyle: TextStyle(
        color: _themeClass.textColorWhite,
      ),
    );
  }

  // text selecion theme
  TextSelectionThemeData _textSelectionThemeData() {
    return TextSelectionThemeData(
      cursorColor: _themeClass.secondaryColor,
      selectionColor: _themeClass.secondaryColor,
      selectionHandleColor: _themeClass.secondaryColor,
    );
  }

  //snackbar theme
  SnackBarThemeData _snackBarThemeData() {
    return SnackBarThemeData(
      insetPadding: const EdgeInsets.symmetric(),
      behavior: SnackBarBehavior.floating,
      backgroundColor: _themeClass.primaryColor,
      contentTextStyle: TextStyle(
        color: _themeClass.textColorWhite,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  BottomAppBarTheme _bottomAppBarTheme() {
    return BottomAppBarTheme(
      color: _themeClass.navigationbarColor,
      shape: const CircularNotchedRectangle(),
    );
  }
}

// global instance of ThemeClass
ThemeClass _themeClass = ThemeClass();
