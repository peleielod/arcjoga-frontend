import 'package:flutter/material.dart';

class Style {
  // COLORS
  static const int primaryLight = 0xFFCAB47C;
  static const int primaryDark = 0xFF2A2F6A;

  static const int secondaryLight = 0xFFB75DCD;
  static const int secondaryDark = 0xFFB914BC;

  static const int textDark = 0xFF302F2F;

  static const int borderLight = 0xFFE0E3FF;

  static const int buttonDark = 0xFFCAB47C;
  static const int drawerDark = 0xFF6D0B86;
  static const int white = 0xFFFFFFFF;

  // TEXT STYLES
  static const TextStyle primaryDarkText = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle primaryLightText = TextStyle(
    color: Color(primaryLight),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle primaryLightTextSmall = TextStyle(
    color: Color(primaryLight),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 16,
  );

  static const TextStyle primaryDarkTextXsmall = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 12,
  );

  static const TextStyle primaryDarkTextSmall = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 14,
  );

  static const TextStyle primaryDarkTextMid = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 16,
  );

  static const TextStyle primaryDarkTextBold = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle primaryDarkTitleSmall = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    fontSize: 20,
  );

  static const TextStyle primaryDarkTitle = TextStyle(
    color: Color(textDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 28,
  );

  static const TextStyle titleDark = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontSize: 18,
  );

  static const TextStyle textDarkBlue = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    fontSize: 16,
  );

  static const TextStyle textDarkBlueBold = TextStyle(
    color: Color(primaryDark),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontSize: 16,
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
