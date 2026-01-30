import 'package:flutter/material.dart';

class CustomStyles {
  final TextStyle smallNormal;
  final TextStyle smallBold;
  final TextStyle mediumNormal;
  final TextStyle mediumBold;
  final TextStyle largeNormal;
  final TextStyle largeBold;

  CustomStyles({
    required Color textColor,
    required double smallSize,
    required double mediumSize,
    required double largeSize,
  })  : smallNormal = TextStyle(
          fontSize: smallSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        smallBold = TextStyle(
          fontSize: smallSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        mediumNormal = TextStyle(
          fontSize: mediumSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        mediumBold = TextStyle(
          fontSize: mediumSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        largeNormal = TextStyle(
          fontSize: largeSize,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        largeBold = TextStyle(
          fontSize: largeSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        );
}

class CustomColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color borderColorPrimary;
  final Color borderColorSecondary;
  final Color cardColorPrimary;
  final Color cardColorSecondary;
  final Color bullishColor;
  final Color bearishColor;
  final Color selectedItemColor;
  final Color axisColor;
  final Color sipColor;
  final Color lumpSumColor;
  final Color cardBasicBackground;
  final Color buttonColor;
  final Color sliderColor;
  final Color textColorSecondary;
  final Color disabledContainer;
  final Color supportItemColor;
  final Color primaryButtonColor;
  final Color eduCornerV2ContainerBg1;
  final Color eduCornerV2ContainerBg2;
  final Color eduCornerImageBg;
  final Color optionChainBgColor;
  final Color optionChainStrokeColor;
  final Color optionChainChartIconColor;
  final Color headerColumnColor;
  final Color strikePriceHeaderColor;
  final Color selectedRowColor;
  final Color correctRowColor;
  final Color incorrectRowColor;
  final Color tableBorderColor;
  final Color tableHeaderRowColor;
  final Color tableHeaderRowColorAlt;
  final Color tableAltRowColor;
  final Color tableSelectedRowColor;
  final Color containerColor;
  final Color dynamicChartInstructionBG;
  final Color dynamicChartActiveTabColor;
  final Color dynamicChartInactiveTabColor;
  final Color dynamicChartTabBorderColor;
  final Color dynamicChartActiveTextColor;
  final Color dynamicChartInactiveTextColor;
  final Color feedbackWidgetBG;
  final Color feedbackWidgetIconBorder;
  final Color dynamicChartBlurBg;
  final Color optionChainBg;
  final Color optionChainTickerBg;
  final Color strikePriceCellColor;
  final Color marketDepthFooterValue;
  final Color customTableHeaderColor;
  final Color customTableBackground;
  final Color customTableHeaderFontColor;
  final Color customTableCellFontColor;
  final Color chartSeparatorColor;
  final Color chartArrowLayerColor;

  CustomColors(
      {required this.primary,
      required this.secondary,
      required this.background,
      required this.borderColorPrimary,
      required this.borderColorSecondary,
      required this.cardColorPrimary,
      required this.cardColorSecondary,
      required this.bullishColor,
      required this.bearishColor,
      required this.selectedItemColor,
      required this.axisColor,
      required this.sipColor,
      required this.lumpSumColor,
      required this.cardBasicBackground,
      required this.buttonColor,
      required this.sliderColor,
      required this.textColorSecondary,
      required this.disabledContainer,
      required this.supportItemColor,
      required this.primaryButtonColor,
      required this.eduCornerV2ContainerBg1,
      required this.eduCornerV2ContainerBg2,
      required this.eduCornerImageBg,
      required this.optionChainBgColor,
      required this.optionChainStrokeColor,
      required this.optionChainChartIconColor,
      required this.headerColumnColor,
      required this.strikePriceHeaderColor,
      required this.selectedRowColor,
      required this.correctRowColor,
      required this.incorrectRowColor,
      required this.tableBorderColor,
      required this.tableHeaderRowColor,
      required this.tableHeaderRowColorAlt,
      required this.tableAltRowColor,
      required this.tableSelectedRowColor,
      required this.containerColor,
      required this.dynamicChartInstructionBG,
      required this.dynamicChartActiveTabColor,
      required this.dynamicChartInactiveTabColor,
      required this.dynamicChartTabBorderColor,
      required this.dynamicChartActiveTextColor,
      required this.dynamicChartInactiveTextColor,
      required this.feedbackWidgetBG,
      required this.feedbackWidgetIconBorder,
      required this.dynamicChartBlurBg,
      required this.optionChainBg,
      required this.optionChainTickerBg,
      required this.strikePriceCellColor,
      required this.marketDepthFooterValue,
      required this.customTableHeaderColor,
      required this.customTableBackground,
      required this.customTableHeaderFontColor,
      required this.customTableCellFontColor,
      required this.chartSeparatorColor,
      required this.chartArrowLayerColor});
}

extension ThemeDataExtension on ThemeData {
  CustomColors get customColors {
    if (brightness == Brightness.light) {
      return CustomColors(
          primary: const Color(0xff97144D),
          secondary: const Color(0xffB4B4B4),
          background: Colors.transparent,
          borderColorPrimary: const Color(0xffF14687),
          borderColorSecondary: const Color(0xffB4B4B4),
          cardColorPrimary: const Color(0xffF9EBEF),
          cardColorSecondary: const Color(0xffe2e2e2),
          bullishColor: const Color(0xff278829),
          bearishColor: Colors.red,
          selectedItemColor: const Color(0xffF9B0CC),
          axisColor: Colors.black,
          sipColor: Colors.orangeAccent,
          lumpSumColor: Colors.blueAccent,
          cardBasicBackground: Colors.white,
          buttonColor: const Color(0xffF9F9F9),
          sliderColor: const Color(0xffED1164),
          textColorSecondary: const Color(0xff6E6E6E),
          disabledContainer: const Color(0xffB3BCB9),
          supportItemColor: const Color(0xff165964),
          primaryButtonColor: const Color(0xff97144D),
          eduCornerV2ContainerBg1: const Color(0xffF1F4F7),
          eduCornerV2ContainerBg2: const Color(0xff404040),
          eduCornerImageBg: Colors.white,
          optionChainBgColor: const Color(0xffF1F4F7),
          optionChainStrokeColor: const Color(0xffe2e2e2),
          optionChainChartIconColor: const Color(0xff12877F),
          headerColumnColor: const Color(0xffEEF9F8),
          strikePriceHeaderColor: const Color(0x14F14687),
          selectedRowColor: const Color(0x1A007BFF),
          correctRowColor: const Color(0xff28A745),
          incorrectRowColor: const Color(0xffF9F6EB),
          tableBorderColor: const Color(0xFF404040),
          tableHeaderRowColor: const Color(0xFFF1F4F7),
          tableHeaderRowColorAlt: const Color(0xFFB8DDDB),
          tableAltRowColor: const Color(0xFFEBF9F8),
          tableSelectedRowColor: const Color(0xffF9B0CC),
          containerColor: const Color(0xffF1F4F7),
          dynamicChartInstructionBG: Colors.white,
          dynamicChartActiveTabColor: const Color(0xffF14687),
          dynamicChartInactiveTabColor: Colors.white,
          dynamicChartTabBorderColor: const Color(0xffB4B4B4),
          dynamicChartActiveTextColor: const Color(0xffF9EBEF),
          dynamicChartInactiveTextColor: Colors.black,
          feedbackWidgetBG: const Color(0xffF1F4F7),
          feedbackWidgetIconBorder: Colors.white,
          dynamicChartBlurBg: Colors.transparent,
          optionChainBg: Colors.white,
          optionChainTickerBg: const Color(0xffF1F4F7),
          strikePriceCellColor: const Color(0xffEBE4F0),
          marketDepthFooterValue: Colors.black,
          customTableHeaderColor: Colors.white,
          customTableBackground: const Color(0xffF9F9F9),
          customTableHeaderFontColor: Colors.black54,
          customTableCellFontColor: Colors.black87,
          chartSeparatorColor: Colors.grey.shade400,
          chartArrowLayerColor: Colors.black);
    } else {
      return CustomColors(
          primary: const Color(0xff38EB54),
          secondary: const Color(0xffB4B4B4),
          // background: const Color(0xFF161A26),
          background: Colors.transparent,
          borderColorPrimary: const Color(0xff5E6FA5),
          borderColorSecondary: const Color(0xff303030),
          cardColorPrimary: const Color(0xff222838),
          cardColorSecondary: const Color(0xFF463B32),
          bullishColor: Colors.green,
          bearishColor: Colors.red,
          selectedItemColor: Colors.purple,
          axisColor: Colors.white,
          sipColor: Colors.orangeAccent,
          lumpSumColor: Colors.blueAccent,
          cardBasicBackground: Colors.black,
          buttonColor: const Color(0xff404040),
          sliderColor: const Color(0xffED1164),
          textColorSecondary: Colors.white,
          disabledContainer: const Color(0xffB3BCB9),
          supportItemColor: const Color(0xff165964),
          primaryButtonColor: const Color(0xff97144D),
          eduCornerV2ContainerBg1: const Color(0xff313030),
          eduCornerV2ContainerBg2: const Color(0xff1D1D1D),
          eduCornerImageBg: const Color(0xff1D1D1D),
          optionChainBgColor: const Color(0xff313030),
          optionChainStrokeColor: const Color(0xff1D1D1D),
          optionChainChartIconColor: const Color(0xff12877F),
          headerColumnColor: const Color(0xff0F322F),
          strikePriceHeaderColor: Color.fromRGBO(70, 38, 72, 1),
          selectedRowColor: const Color(0xFF0F1B32),
          correctRowColor: const Color(0xff28A745),
          incorrectRowColor: const Color.fromARGB(255, 59, 15, 15),
          tableBorderColor: const Color(0xFF404040),
          tableHeaderRowColor: const Color(0xFFF1F4F7),
          tableHeaderRowColorAlt: const Color(0xFFB8DDDB),
          tableAltRowColor: const Color(0xFFEBF9F8),
          tableSelectedRowColor: const Color(0xffF9B0CC),
          containerColor: const Color(0xffF1F4F7),
          dynamicChartInstructionBG: const Color(0xFF404040),
          dynamicChartActiveTabColor: const Color(0xffED1164),
          dynamicChartInactiveTabColor: const Color(0xFF000000),
          dynamicChartTabBorderColor: const Color(0xff6e6e6e),
          dynamicChartActiveTextColor: Colors.white,
          dynamicChartInactiveTextColor: Colors.white,
          feedbackWidgetBG: const Color(0xff0F322F),
          feedbackWidgetIconBorder: const Color(0xff404040),
          dynamicChartBlurBg: const Color(0xFF404040),
          optionChainBg: const Color(0xFF404040),
          optionChainTickerBg: const Color(0xFF0C1015),
          strikePriceCellColor: const Color(0xFF594B52),
          marketDepthFooterValue: Colors.white,
          customTableHeaderColor: Colors.black,
          customTableBackground: const Color(0xFF404040),
          customTableHeaderFontColor: Colors.white54,
          customTableCellFontColor: Colors.white70,
          chartSeparatorColor: Colors.grey.shade700,
          chartArrowLayerColor: Colors.white);
    }
  }

  CustomStyles get customTextStyles {
    final textColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return CustomStyles(
      textColor: textColor,
      smallSize: 14.0,
      mediumSize: 18.0,
      largeSize: 24.0,
    );
  }
}
