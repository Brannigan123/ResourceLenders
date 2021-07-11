import 'package:async_button_builder/async_button_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:layout/layout.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sizer/sizer.dart';

class AsyncBtn extends StatelessWidget {
  const AsyncBtn({
    Key? key,
    this.focusNode,
    required this.callback,
    required this.idleText,
    required this.loadingText,
    required this.successText,
    required this.errorText,
    this.state = const ButtonState.idle(),
  }) : super(key: key);

  final FocusNode? focusNode;
  final Future<void> Function() callback;
  final String idleText;
  final String loadingText;
  final String successText;
  final String errorText;
  final ButtonState state;

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      buttonState: state,
      successDuration: 1300.milliseconds,
      errorDuration: 1300.milliseconds,
      child: AutoSizeText(
        idleText,
        maxLines: 1,
        minFontSize: 4.0.sp.ceilToDouble(),
        style: TextStyle(
          color: Color(0xffd7d7d7),
          fontSize: 6.0.sp,
        ),
      ),
      loadingWidget: AutoSizeText(
        loadingText,
        maxLines: 1,
        minFontSize: 4.0.sp.ceilToDouble(),
        style: TextStyle(
          color: Color(0xffd7d7d7),
          fontSize: 6.0.sp,
        ),
      ),
      successWidget: AutoSizeText(
        successText,
        maxLines: 1,
        minFontSize: 4.0.sp.ceilToDouble(),
        style: TextStyle(
          color: Color(0xffd7d7d7),
          fontSize: 6.0.sp,
        ),
      ),
      errorWidget: AutoSizeText(
        errorText,
        maxLines: 1,
        minFontSize: 4.0.sp.ceilToDouble(),
        style: TextStyle(
          color: Color(0xffd7d7d7),
          fontSize: 6.0.sp,
        ),
      ),
      onPressed: callback,
      builder: (context, child, callback, buttonState) {
        final btnColor = buttonState.when(
          idle: () => Color(0xff008CF0),
          loading: () => Color(0xff76A9EA),
          success: () => Color(0xff2765FF),
          error: () => Color(0xffF34A38),
        );

        final suffix = buttonState.when(
          idle: () => Icon(
            Entypo.upload,
            color: Color(0xffd7d7d7),
            size: 0.65 * context.layout.gutter,
          ),
          loading: () => SpinKitThreeBounce(
            color: Color(0xffd7d7d7),
            size: 0.35 * context.layout.gutter,
          ),
          success: () => Icon(
            Entypo.check,
            color: Color(0xffd7d7d7),
            size: 0.65 * context.layout.gutter,
          ),
          error: () => Icon(
            Entypo.attention,
            color: Color(0xffd7d7d7),
            size: 0.65 * context.layout.gutter,
          ),
        );

        final activateCallback = buttonState.maybeWhen(
          idle: () => true,
          orElse: () => false,
        );

        return TextButton(
          focusNode: focusNode,
          onPressed: activateCallback ? callback : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.layout.gutter * 7.0,
            ),
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.layout.gutter,
                  vertical: 0.5 * context.layout.gutter,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    child,
                    SizedBox(
                      width: 0.5 * context.layout.gutter,
                    ),
                    suffix,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
