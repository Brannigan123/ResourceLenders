import 'package:cash_pump/ui/signup_login/widgets/type_writer.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:sizer/sizer.dart';

enum SignupLoginView { Signup, Login }

const SignupHighlight = 'Are you new here ?';
const LoginHighlight = 'Already registered with us ?';

class SignupLoginSwitchCover extends StatelessWidget {
  SignupLoginSwitchCover({
    Key? key,
    required this.activeView,
    required this.viewToggle,
    required this.animationProgress,
  }) : super(key: key);

  final SignupLoginView activeView;
  final VoidCallback viewToggle;
  final double animationProgress;

  @override
  Widget build(BuildContext context) {
    final isSignupView = activeView == SignupLoginView.Signup;
    final animationStopped =
        animationProgress == 0.0 || animationProgress == 1.0;

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSignupView ? Color(0xff163458) : Color(0xff242b5c),
        borderRadius: isSignupView
            ? BorderRadius.only(
                topLeft: Radius.circular(24.0),
                bottomLeft: Radius.circular(24.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 0.75,
            child: Padding(
              padding: EdgeInsets.all(0.35 * context.layout.gutter),
              child: TypeWriter(
                isSignupView ? LoginHighlight : SignupHighlight,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  color: Color(0xffd7d7d7),
                ),
                cursorColor: Color(0xffffffff),
                cursorWidth: 0.35 * context.layout.gutter,
                cursorHeight: 2.0 * context.layout.gutter,
                progress: isSignupView
                    ? (1.0 - animationProgress).abs()
                    : animationProgress,
              ),
            ),
          ),
          SizedBox(height: context.layout.gutter),
          FractionallySizedBox(
            widthFactor: 0.55,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.0),
              child: Padding(
                padding: EdgeInsets.all(0.5 * context.layout.gutter),
                child: AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  decoration: BoxDecoration(
                    border: animationStopped
                        ? Border.all(
                            color: Color(0xffd7d7d7),
                            width: 1.0,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(context.layout.gutter),
                    color: Colors.black12,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(context.layout.gutter),
                    onTap: animationStopped ? viewToggle : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.layout.gutter / 4.0,
                        horizontal: context.layout.gutter / 3.0,
                      ),
                      child: TypeWriter(
                        isSignupView ? 'Login' : 'Signup',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xffd7d7d7),
                        ),
                        cursorColor: Color(0xffffffff),
                        cursorWidth: 0.35 * context.layout.gutter,
                        cursorHeight: 2.0 * context.layout.gutter,
                        progress: isSignupView
                            ? (1.0 - animationProgress).abs()
                            : animationProgress,
                        showCursor: false,
                      ),
                    ),
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
