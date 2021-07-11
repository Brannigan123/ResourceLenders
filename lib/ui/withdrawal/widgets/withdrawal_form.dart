import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/ui/widgets/async_btn.dart';
import 'package:cash_pump/ui/widgets/textarea.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:number_display/number_display.dart';
import 'package:supercharged/supercharged.dart';

final moneiteryDisplay = createDisplay(
  length: 5,
  decimal: 2,
  placeholder: '--',
  separator: ',',
  decimalPoint: '.',
  units: ['K', 'M', 'B', 'T'],
);

abstract class WithdrawalFormState<T extends StatefulWidget> extends State<T> {
  final AutoSizeGroup fieldLabelGroup;

  late final ValueNotifier<double> currentBalance;

  late final TextEditingController balanceController;
  late final TextEditingController amountController;
  late final TextEditingController balanceAfterController;
  late final TextEditingController passwordController;

  final amountNode = FocusNode();
  final passwordNode = FocusNode();
  final transferNode = FocusNode();

  WithdrawalFormState({required this.fieldLabelGroup});

  @override
  void initState() {
    super.initState();
    currentBalance = ValueNotifier<double>(6764.0);

    balanceController = TextEditingController();
    amountController = TextEditingController();
    balanceAfterController = TextEditingController();
    passwordController = TextEditingController();

    currentBalance.addListener(_onUpdateBalance);
    amountController.addListener(_onUpdateAmount);

    _onUpdateBalance();
  }

  @override
  void dispose() {
    currentBalance.removeListener(_onUpdateBalance);
    amountController.removeListener(_onUpdateAmount);

    currentBalance.dispose();

    balanceController.dispose();
    amountController.dispose();
    balanceAfterController.dispose();
    passwordController.dispose();

    amountNode.dispose();
    passwordNode.dispose();
    transferNode.dispose();

    super.dispose();
  }

  void _onUpdateBalance() {
    final bal = moneiteryDisplay(currentBalance.value);
    balanceController.text = '\$ $bal';
    _updateBalanceAfter();
  }

  void _onUpdateAmount() {
    _updateBalanceAfter();
  }

  void _updateBalanceAfter() {
    final bal = moneiteryDisplay(
        currentBalance.value - (double.tryParse(amountController.text) ?? 0.0));
    balanceAfterController.text = '\$ $bal';
  }

  @override
  Widget build(BuildContext context) {
    final focusScopeNode = FocusScope.of(context);

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
                controller: balanceController,
                label: 'Balance',
                labelGroup: fieldLabelGroup,
                editable: false,
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
              child: recepientBuilder(context, focusScopeNode),
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
                focusNode: amountNode,
                controller: amountController,
                label: 'Amount',
                labelGroup: fieldLabelGroup,
                action: TextInputAction.next,
                inputType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (val) {},
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
                controller: balanceAfterController,
                label: 'Balance after',
                labelGroup: fieldLabelGroup,
                editable: false,
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
                    focusNode: transferNode,
                    callback: transferCallback,
                    idleText: 'Transfer',
                    loadingText: 'Pending',
                    successText: 'Sent',
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

  Widget recepientBuilder(BuildContext context, FocusScopeNode focusScopeNode);

  Future<void> transferCallback() async => await Future.delayed(3.seconds);
}
