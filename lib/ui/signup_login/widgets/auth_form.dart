import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/ui/widgets/async_btn.dart';
import 'package:cash_pump/ui/widgets/textarea.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:supercharged/supercharged.dart';

abstract class AuthFormState<T extends StatefulWidget> extends State<T> {
  final AutoSizeGroup fieldLabelGroup;

  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  final proceedNode = FocusNode();

  AuthFormState({required this.fieldLabelGroup});

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    passwordController = TextEditingController();

    usernameNode.requestFocus();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    usernameNode.dispose();
    passwordNode.dispose();
    proceedNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusScopeNode = FocusScope.of(context);

    final extra = extraBuilder(context, focusScopeNode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720.0),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Padding(
              padding: EdgeInsets.all(0.35 * context.layout.gutter),
              child: TextArea(
                focusNode: usernameNode,
                controller: usernameController,
                label: 'Username',
                labelGroup: fieldLabelGroup,
                onEditingComplete: () => focusScopeNode.nextFocus(),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720.0),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Padding(
              padding: EdgeInsets.all(0.35 * context.layout.gutter),
              child: TextArea(
                focusNode: passwordNode,
                controller: passwordController,
                label: 'Password',
                placeholder: '********',
                labelGroup: fieldLabelGroup,
                obscure: true,
                action: TextInputAction.next,
                inputType: TextInputType.text,
                onSubmitted: (val) {},
                onEditingComplete: () => focusScopeNode.nextFocus(),
              ),
            ),
          ),
        ),
        ...{},
        if (extra != null)
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 720.0),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: EdgeInsets.all(0.35 * context.layout.gutter),
                child: extra,
              ),
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720.0),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(0.35 * context.layout.gutter),
                  child: AsyncBtn(
                    focusNode: proceedNode,
                    callback: proceedCallback,
                    idleText: 'Proceed',
                    loadingText: 'Processing',
                    successText: 'Success',
                    errorText: 'Failed',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? extraBuilder(BuildContext context, FocusScopeNode foscusScopeNode);

  Future<void> proceedCallback() async => await Future.delayed(3.seconds);
}
