import 'package:cash_pump/constants/routes.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'dart:io' show Platform;

import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupWindow();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      format: MaterialLayoutFormat(),
      child: Sizer(
        builder: (context, orientation, screenType) => MaterialApp(
          title: 'cash_pump',
          debugShowCheckedModeBanner: false,
          initialRoute: SignupAndLoginPath,
          onGenerateRoute: router,
        ),
      ),
    );
  }
}

_setupWindow() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    try {
      await DesktopWindow.setMinWindowSize(Size(550, 700));
    } catch (e) {}
  }
}
