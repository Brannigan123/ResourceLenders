import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/constants/routes.dart';
import 'package:cash_pump/ui/signup_login/widgets/auth_form.dart';
import 'package:cash_pump/ui/widgets/textarea.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sizer/sizer.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key, required this.fieldLabelGroup}) : super(key: key);

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
            SignupTopRegion(),
            FocusScope(
              child: SignupDetailsRegion(fieldLabelGroup: fieldLabelGroup),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupTopRegion extends StatelessWidget {
  const SignupTopRegion({Key? key}) : super(key: key);

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
                  child: Icon(Icons.person_add, color: Color(0xffd7d7d7)),
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
                  'Sign up',
                  maxLines: 1,
                  minFontSize: 9.0.sp.ceilToDouble(),
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

class SignupDetailsRegion extends StatefulWidget {
  const SignupDetailsRegion({Key? key, required this.fieldLabelGroup})
      : super(key: key);

  final AutoSizeGroup fieldLabelGroup;

  @override
  _SignupDetailsRegionState createState() =>
      _SignupDetailsRegionState(fieldLabelGroup: fieldLabelGroup);
}

class _SignupDetailsRegionState extends AuthFormState<SignupDetailsRegion> {
  _SignupDetailsRegionState({required AutoSizeGroup fieldLabelGroup})
      : super(fieldLabelGroup: fieldLabelGroup);

  late final TextEditingController confirmPasswordController;

  final confirmPasswordNode = FocusNode();

  @override
  void initState() {
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    confirmPasswordController.dispose();
    confirmPasswordNode.dispose();
  }

  @override
  Widget? extraBuilder(BuildContext context, FocusScopeNode focusScopeNode) =>
      TextArea(
        focusNode: confirmPasswordNode,
        controller: confirmPasswordController,
        label: 'Confirm Password',
        placeholder: '********',
        labelGroup: fieldLabelGroup,
        obscure: true,
        action: TextInputAction.next,
        inputType: TextInputType.text,
        onSubmitted: (val) {},
        onEditingComplete: () => focusScopeNode.nextFocus(),
      );

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
