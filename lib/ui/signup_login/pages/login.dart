import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/constants/routes.dart';
import 'package:cash_pump/ui/signup_login/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.fieldLabelGroup}) : super(key: key);

  final AutoSizeGroup fieldLabelGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.5 * context.layout.gutter),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoginTopRegion(),
            FocusScope(
              child: LoginDetailsRegion(fieldLabelGroup: fieldLabelGroup),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTopRegion extends StatelessWidget {
  const LoginTopRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(0.5 * context.layout.gutter),
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              width: 4.0 * context.layout.gutter,
              height: 4.0 * context.layout.gutter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff000422),
                border: Border.all(
                  color: Color(0xff3cf7ff),
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(0.65 * context.layout.gutter),
                child: FittedBox(
                  child: Icon(Icons.person, color: Color(0xffd7d7d7)),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.65,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(0.5 * context.layout.gutter),
                child: AutoSizeText(
                  'Login',
                  maxLines: 1,
                  minFontSize: 9.sp.ceilToDouble(),
                  style: TextStyle(
                    color: Color(0xff76A9EA),
                    fontSize: 18.0.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginDetailsRegion extends StatefulWidget {
  const LoginDetailsRegion({Key? key, required this.fieldLabelGroup})
      : super(key: key);

  final AutoSizeGroup fieldLabelGroup;

  @override
  _LoginDetailsRegionState createState() =>
      _LoginDetailsRegionState(fieldLabelGroup: fieldLabelGroup);
}

class _LoginDetailsRegionState extends AuthFormState<LoginDetailsRegion> {
  _LoginDetailsRegionState({required AutoSizeGroup fieldLabelGroup})
      : super(fieldLabelGroup: fieldLabelGroup);

  @override
  Widget? extraBuilder(BuildContext context, FocusScopeNode focusScopeNode) =>
      null;

  @override
  Future<void> proceedCallback() {
    final process = Future.delayed(1200.milliseconds);
    process.then((value) async {
      Future.delayed(1.seconds).then((value) => _openDashboard());
    }).onError(_handleLoginError);
    return process;
  }

  void _openDashboard() => Navigator.pushNamed(context, DashboardPath);

  FutureOr<Null> _handleLoginError(Object error, StackTrace stackTrace) {}
}
