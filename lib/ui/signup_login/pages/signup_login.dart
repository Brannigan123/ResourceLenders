import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/ui/signup_login/pages/login.dart';
import 'package:cash_pump/ui/signup_login/pages/signup.dart';
import 'package:cash_pump/ui/signup_login/pages/switch_cover.dart';
import 'package:layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class SignupLoginToggle extends StatefulWidget {
  SignupLoginToggle({Key? key}) : super(key: key);

  @override
  _SignupLoginToggleState createState() => _SignupLoginToggleState();
}

class _SignupLoginToggleState extends State<SignupLoginToggle> {
  late final ValueNotifier<SignupLoginView> activeView;
  final AutoSizeGroup fieldLabelGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    activeView = ValueNotifier(SignupLoginView.Login);
  }

  @override
  void dispose() {
    activeView.dispose();
    super.dispose();
  }

  void _toggleView() {
    if (activeView.value == SignupLoginView.Login)
      activeView.value = SignupLoginView.Signup;
    else
      activeView.value = SignupLoginView.Login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff000422), Color(0xff151935)],
          ),
        ),
        child: context.layout.value(xs: false, sm: true)
            ? SameView(
                activeView: activeView,
                fieldLabelGroup: fieldLabelGroup,
                viewToggle: _toggleView,
              )
            : SeperateView(
                activeView: activeView,
                fieldLabelGroup: fieldLabelGroup,
                viewToggle: _toggleView,
              ),
      ),
    );
  }
}

class SameView extends StatelessWidget {
  const SameView({
    Key? key,
    required this.activeView,
    required this.fieldLabelGroup,
    required this.viewToggle,
  }) : super(key: key);

  final ValueNotifier<SignupLoginView> activeView;
  final AutoSizeGroup fieldLabelGroup;
  final VoidCallback viewToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SignupLoginView>(
      valueListenable: activeView,
      builder: (context, view, child) => CustomAnimation<double>(
        duration: 450.milliseconds,
        control: view == SignupLoginView.Login
            ? CustomAnimationControl.PLAY
            : CustomAnimationControl.PLAY_REVERSE,
        tween: 0.0.tweenTo(1.0),
        builder: (context, child, animationProgress) {
          return Stack(
            children: [
              Align(
                alignment: Alignment(animationProgress - 1.0, 0.0),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Opacity(
                    opacity: (1.0 - animationProgress).abs(),
                    child: IgnorePointer(
                      ignoring: view != SignupLoginView.Signup,
                      child: SignupPage(fieldLabelGroup: fieldLabelGroup),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(animationProgress, 0.0),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Opacity(
                    opacity: animationProgress,
                    child: IgnorePointer(
                      ignoring: view != SignupLoginView.Login,
                      child: LoginPage(fieldLabelGroup: fieldLabelGroup),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(2.0 * (0.5 - animationProgress), 0.0),
                child: FractionallySizedBox(
                  widthFactor:
                      0.5 + 0.4 * (0.5 - (0.5 - animationProgress).abs()),
                  child: SignupLoginSwitchCover(
                    activeView: view,
                    animationProgress: animationProgress,
                    viewToggle: viewToggle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SeperateView extends StatelessWidget {
  const SeperateView({
    Key? key,
    required this.activeView,
    required this.fieldLabelGroup,
    required this.viewToggle,
  }) : super(key: key);

  final ValueNotifier<SignupLoginView> activeView;
  final AutoSizeGroup fieldLabelGroup;
  final VoidCallback viewToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SignupLoginView>(
      valueListenable: activeView,
      builder: (context, view, child) => CustomAnimation<double>(
        duration: 450.milliseconds,
        control: view == SignupLoginView.Login
            ? CustomAnimationControl.PLAY
            : CustomAnimationControl.PLAY_REVERSE,
        tween: 0.0.tweenTo(1.0),
        builder: (context, child, animationProgress) {
          return Stack(
            children: [
              Align(
                alignment: Alignment(0.0, animationProgress - 1.0),
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Opacity(
                    opacity: (1.0 - animationProgress).abs(),
                    child: IgnorePointer(
                      ignoring: view != SignupLoginView.Signup,
                      child: SignupPage(fieldLabelGroup: fieldLabelGroup),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, animationProgress),
                child: FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Opacity(
                    opacity: animationProgress,
                    child: IgnorePointer(
                      ignoring: view != SignupLoginView.Login,
                      child: LoginPage(fieldLabelGroup: fieldLabelGroup),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 2.0 * (0.5 - animationProgress)),
                child: FractionallySizedBox(
                  heightFactor:
                      0.3 + 0.4 * (0.5 - (0.5 - animationProgress).abs()),
                  child: SignupLoginSwitchCover(
                    activeView: view,
                    animationProgress: animationProgress,
                    viewToggle: viewToggle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
