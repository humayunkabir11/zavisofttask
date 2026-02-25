  import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // PRIMARY COLOR - Blue (0xFF3F80AE)
  // ============================================================================
  static const primaryColor = Color(0xFF3F80AE);

  static const blue25 = Color(0xFFF6FAFC);
  static const blue50 = Color(0xFFECF4F9);
  static const blue100 = Color(0xFFD5E8F2);
  static const blue200 = Color(0xFFABD1E6);
  static const blue300 = Color(0xFF81BAD9);
  static const blue400 = Color(0xFF57A3CC);
  static const blue500 = Color(0xFF3F8CB6);
  static const blue600 = Color(0xFF3F80AE);
  static const blue700 = Color(0xFF356D95);
  static const blue800 = Color(0xFF2B5A7C);
  static const blue900 = Color(0xFF214763);

  static const MaterialColor kPrimaryColorx = MaterialColor(
    0xFF3F80AE,
    <int, Color>{
      25: Color(0xFFF6FAFC),
      50: Color(0xFFECF4F9),
      100: Color(0xFFD5E8F2),
      200: Color(0xFFABD1E6),
      300: Color(0xFF81BAD9),
      400: Color(0xFF57A3CC),
      500: Color(0xFF3F8CB6),
      600: Color(0xFF3F80AE),
      700: Color(0xFF356D95),
      800: Color(0xFF2B5A7C),
      900: Color(0xFF214763),
    },
  );

  // ============================================================================
  // NEUTRAL COLORS
  // ============================================================================
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const primaryBackground = Color(0xFFFFFFFF);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const containerColor = Color(0xFFFFFFFF);

  // ============================================================================
  // SLATE COLORS
  // ============================================================================
  static const slate25 = Color(0xFFF9FAFB);
  static const slate50 = Color(0xFFF0F3F9);
  static const slate100 = Color(0xFFE9EFF6);
  static const slate200 = Color(0xFFD7DFE9);
  static const slate300 = Color(0xFFAFBACA);
  static const slate400 = Color(0xFF8897AE);
  static const slate500 = Color(0xFF5E718D);
  static const slate600 = Color(0xFF455468);
  static const slate700 = Color(0xFF3D4A5C);
  static const slate800 = Color(0xFF2D3643);
  static const slate900 = Color(0xFF1A1F28);

  // Aliases for compatibility
  static const primarySlate25 = slate25;
  static const primarySlate50 = slate50;
  static const primarySlate100 = slate100;
  static const primarySlate200 = slate200;
  static const primarySlate300 = slate300;
  static const primarySlate400 = slate400;
  static const primarySlate500 = slate500;
  static const primarySlate600 = slate600;
  static const primarySlate700 = slate700;
  static const primarySlate800 = slate800;

  // ============================================================================
  // GREY COLORS
  // ============================================================================
  static const grey50 = Color(0xFFEFEFEF);
  static const grey100 = Color(0xFFCCCCCC);
  static const grey200 = Color(0xFFB4B4B4);
  static const grey300 = Color(0xFF929292);
  static const grey400 = Color(0xFF7D7D7D);
  static const grey500 = Color(0xFF5C5C5C);
  static const grey600 = Color(0xFF545454);
  static const grey700 = Color(0xFF414141);
  static const grey800 = Color(0xFF333333);
  static const grey900 = Color(0xFF272727);

  // ============================================================================
  // LIGHT GREY COLORS
  // ============================================================================
  static const lightGrey50 = Color(0xFFFDFDFD);
  static const lightGrey100 = Color(0xFFF9F9F9);
  static const lightGrey200 = Color(0xFFF6F6F6);
  static const lightGrey300 = Color(0xFFF2F2F2);
  static const lightGrey400 = Color(0xFFF0F0F0);
  static const lightGrey500 = Color(0xFFECECEC);
  static const lightGrey600 = Color(0xFFD7D7D7);
  static const lightGrey700 = Color(0xFFA8A8A8);
  static const lightGrey800 = Color(0xFF828282);
  static const lightGrey900 = Color(0xFF636363);

  // ============================================================================
  // SUCCESS / GREEN COLORS
  // ============================================================================
  static const green25 = Color(0xFFF0FDF4);
  static const green50 = Color(0xFFDCFCE7);
  static const green100 = Color(0xFFBBF7D0);
  static const green200 = Color(0xFF86EFAC);
  static const green300 = Color(0xFF4EDE80);
  static const green400 = Color(0xFF22C55E);
  static const green500 = Color(0xFF16A34A);
  static const green600 = Color(0xFF0A9952);
  static const green700 = Color(0xFF047857);
  static const green800 = Color(0xFF065F46);
  static const green900 = Color(0xFF064E3B);

  static const greenColor400 = green400;
  static const emerald500 = Color(0xFF16A077);

  // ============================================================================
  // ERROR / RED COLORS
  // ============================================================================
  static const red25 = Color(0xFFFFF5F4);
  static const red50 = Color(0xFFFAE6E6);
  static const red100 = Color(0xFFEEB0B2);
  static const red200 = Color(0xFFE68A8D);
  static const red300 = Color(0xFFDB5559);
  static const red400 = Color(0xFFD43439);
  static const red500 = Color(0xFFC90107);
  static const red600 = Color(0xFFB70106);
  static const red700 = Color(0xFF8F0105);
  static const red800 = Color(0xFF6F0104);
  static const red900 = Color(0xFF540003);

  static const primaryError200 = red200;
  static const primaryError400 = red400;
  static const primaryErrorColor = red25;

  // ============================================================================
  // WARNING / YELLOW COLORS
  // ============================================================================
  static const yellow25 = Color(0xFFFFFBED);
  static const yellow50 = Color(0xFFFEF3C7);
  static const yellow100 = Color(0xFFFDE68A);
  static const yellow200 = Color(0xFFFCD34D);
  static const yellow300 = Color(0xFFFBBF24);
  static const yellow400 = Color(0xFFF59E0B);
  static const yellow500 = Color(0xFFEAB308);
  static const yellow600 = Color(0xFFC92A2A);
  static const yellow700 = Color(0xFFB18A00);
  static const yellow800 = Color(0xFF92400E);
  static const yellow900 = Color(0xFF78350F);

  static const warning500 = Color(0xFFD8A800);
  static const primaryYellow300 = yellow300;

  // ============================================================================
  // SECONDARY COLORS
  // ============================================================================
  // Indigo
  static const indigo25 = Color(0xFFF4F5FF);
  static const indigo100 = Color(0xFFDFE1FF);
  static const indigo200 = Color(0xFFBFC3FF);
  static const indigo300 = Color(0xFF9FA4FF);
  static const indigo400 = Color(0xFF7D88F4);
  static const indigo500 = Color(0xFF636DD3);
  static const indigo600 = Color(0xFF5457B3);
  static const indigo700 = Color(0xFF453F93);
  static const indigo800 = Color(0xFF362B73);
  static const indigo900 = Color(0xFF271753);

  // Violet
  static const violet200 = Color(0xFF9B7BF9);
  static const violet400 = Color(0xFF7C3AED);
  static const violet500 = Color(0xFF6D28D9);

  // Fuchsia
  static const fuchsia400 = Color(0xFFD638EE);
  static const fuchsia500 = Color(0xFFD61F69);

  // Cyan
  static const cyan400 = Color(0xFF38D6EF);
  static const cyan500 = Color(0xFF06B6D4);

  // Orange
  static const orange400 = Color(0xFFFC8E28);
  static const orange500 = Color(0xFFFC8415);

  // Sky
  static const sky400 = Color(0xFF3CAAFA);

  // ============================================================================
  // TERTIARY / ACCENT COLORS
  // ============================================================================
  // Navy Blue
  static const navyBlue50 = Color(0xFFE7EEFE);
  static const navyBlue100 = Color(0xFFB3CBFD);
  static const navyBlue200 = Color(0xFF8EB1FB);
  static const navyBlue300 = Color(0xFF5B8EFA);
  static const navyBlue400 = Color(0xFF3B78F9);
  static const navyBlue500 = Color(0xFF0A56F7);
  static const navyBlue600 = Color(0xFF094EE1);
  static const navyBlue700 = Color(0xFF073DAF);
  static const navyBlue800 = Color(0xFF062F88);
  static const navyBlue900 = Color(0xFF042468);

  static const primaryTextButtonColor = Color(0xFF4A72FF);
  static const emerald300 = Color(0xFF10B981);

  // ============================================================================
  // UTILITY COLORS
  // ============================================================================
  static const transparent = Color(0x00000000);
  static const shadow = Color(0x14000000);
}