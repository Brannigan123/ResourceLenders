import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TypeWriter extends StatelessWidget {
  const TypeWriter(
    this.text, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 12,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.progress = 1.0,
    required this.cursorColor,
    this.cursorWidth = 4.0,
    this.cursorHeight = 12.0,
    this.showCursor = true,
  })  : assert(0.0 <= progress && progress <= 1.0),
        super(key: key);

  final Key? textKey;
  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final AutoSizeGroup? group;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final bool wrapWords;
  final TextOverflow? overflow;
  final Widget? overflowReplacement;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final double progress;
  final Color cursorColor;
  final double cursorWidth;
  final double cursorHeight;
  final bool showCursor;

  @override
  Widget build(BuildContext context) {
    late WrapAlignment wrapAlignment;
    switch (textAlign) {
      case TextAlign.left:
        wrapAlignment = WrapAlignment.start;
        break;
      case TextAlign.right:
        wrapAlignment = WrapAlignment.end;
        break;
      case TextAlign.center:
        wrapAlignment = WrapAlignment.center;
        break;
      case TextAlign.justify:
        wrapAlignment = WrapAlignment.spaceEvenly;
        break;
      case TextAlign.start:
        wrapAlignment = WrapAlignment.start; //isLTR
        break;
      case TextAlign.end:
        wrapAlignment = WrapAlignment.end; //isLTR
        break;
      default:
        wrapAlignment = WrapAlignment.start; //isLTR
    }

    return Wrap(
      alignment: wrapAlignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AutoSizeText(
          text.substring(0, (progress * text.length).ceil()),
          textKey: textKey,
          style: style,
          strutStyle: strutStyle,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
          stepGranularity: stepGranularity,
          presetFontSizes: presetFontSizes,
          group: group,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          wrapWords: wrapWords,
          overflow: overflow,
          overflowReplacement: overflowReplacement,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        ),
        if (showCursor && progress < 1.0) ...[
          SizedBox(width: 3.0 * cursorWidth),
          Container(
            color: cursorColor.withOpacity(progress),
            width: cursorWidth,
            height: cursorHeight,
          ),
        ]
      ],
    );
  }
}
