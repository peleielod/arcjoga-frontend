import 'package:flutter/material.dart';

class Style {
  // COLORS
  static const int primaryLight = 0xFFFB2CFF;
  static const int primaryDark = 0xFF5A086F;

  static const int secondaryLight = 0xFFB75DCD;
  static const int secondaryDark = 0xFFB914BC;

  static const int borderLight = 0xFFF8DEFF;

  static const int buttonDark = 0xFF66269A;
  static const int drawerDark = 0xFF6D0B86;
  static const int white = 0xFFFFFFFF;

  // TEXT STYLES
  static const TextStyle primaryDarkText = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle primaryDarkTextXsmall = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 12,
  );

  static const TextStyle primaryDarkTextSmall = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 14,
  );

  static const TextStyle primaryDarkTextMid = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 16,
  );

  static const TextStyle primaryDarkTextBold = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle primaryDarkTitleSmall = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    fontSize: 20,
  );

  static const TextStyle primaryDarkTitle = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 28,
  );

  static const TextStyle titleWhite = TextStyle(
    color: Color(white),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 24,
  );

  static const TextStyle textWhite = TextStyle(
    color: Color(white),
    fontWeight: FontWeight.w300,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle textWhiteBold = TextStyle(
    color: Color(white),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle textWhiteSmall = TextStyle(
    color: Color(white),
    fontWeight: FontWeight.w300,
    fontFamily: 'Montserrat',
    fontSize: 14,
  );

  static const TextStyle secondaryLightText = TextStyle(
    color: Color(secondaryLight),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 16,
  );
}
