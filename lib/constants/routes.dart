import 'package:cash_pump/ui/dashboard/page/dashboard.dart';
import 'package:cash_pump/ui/signup_login/pages/signup_login.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supercharged/supercharged.dart';

const SignupAndLoginPath = '/signup_login';
const DashboardPath = '/dashboard';

Route<dynamic>? router(RouteSettings settings) {
  switch (settings.name) {
    case SignupAndLoginPath:
      return PageTransition(
        child: SignupLoginToggle(),
        duration: 450.milliseconds,
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        settings: settings,
      );
    case DashboardPath:
      return PageTransition(
        child: Dashboard(),
        duration: 450.milliseconds,
        type: PageTransitionType.rotate,
        alignment: Alignment.center,
        settings: settings,
      );
  }
}
