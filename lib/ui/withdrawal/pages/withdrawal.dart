import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/models/withdrawal.dart';
import 'package:cash_pump/ui/widgets/tabbar.dart';
import 'package:cash_pump/ui/widgets/textarea.dart';
import 'package:cash_pump/ui/withdrawal/widgets/withdrawal_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';
import 'package:sizer/sizer.dart';

class WithdrawalPage extends StatefulWidget {
  WithdrawalPage({Key? key}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage>
    with AutomaticKeepAliveClientMixin<WithdrawalPage> {
  final fieldLabelGroup = AutoSizeGroup();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final methods = WithdrawalMethod.values;
    return Padding(
      padding: EdgeInsets.all(0.35 * context.layout.gutter),
      child: DefaultTabController(
        // initialIndex: WithdrawalMethod.Paypal.index,
        length: methods.length,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ButtonsTabBar(
                physics: PageScrollPhysics(),
                backgroundColor: Color(0xff76A9EA),
                unselectedBackgroundColor: Color(0xffA8B3Bd),
                radius: 10.0,
                height: 2.5 * context.layout.gutter,
                tabs: methods
                    .map((m) => Tab(
                          icon: Padding(
                            padding:
                                EdgeInsets.all(0.3 * context.layout.gutter),
                            child: m.logo.svg(
                              fit: BoxFit.contain,
                              width: 7.0 * context.layout.gutter,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              FractionallySizedBox(
                widthFactor: 0.65,
                child: Padding(
                  padding: EdgeInsets.all(0.25 * context.layout.gutter),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AutoSizeText(
                      'Withdrawal',
                      maxLines: 1,
                      minFontSize: 6.0.sp.ceilToDouble(),
                      style: TextStyle(
                        color: Color(0xff76A9EA),
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(0.25 * context.layout.gutter),
                  child: TabBarView(
                    children: methods
                        .map((m) => FocusScope(
                              child: MethodView(
                                method: m,
                                fieldLabelGroup: fieldLabelGroup,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 1.1 * context.layout.gutter),
            ],
          ),
        ),
      ),
    );
  }
}

class MethodView extends StatelessWidget {
  const MethodView(
      {Key? key, required this.method, required this.fieldLabelGroup})
      : super(key: key);

  final WithdrawalMethod method;
  final AutoSizeGroup fieldLabelGroup;

  @override
  Widget build(BuildContext context) {
    switch (method) {
      case WithdrawalMethod.Payoneer:
        return PayoneerWithdrawal(fieldLabelGroup: fieldLabelGroup);
      case WithdrawalMethod.Paypal:
        return PaypalWithdrawal(fieldLabelGroup: fieldLabelGroup);
      case WithdrawalMethod.Paytm:
        break;
      case WithdrawalMethod.WebMoney:
        break;
    }
    return Container();
  }
}

class PaypalWithdrawal extends StatefulWidget {
  PaypalWithdrawal({Key? key, required this.fieldLabelGroup}) : super(key: key);

  final AutoSizeGroup fieldLabelGroup;

  @override
  _PaypalWithdrawalState createState() =>
      _PaypalWithdrawalState(fieldLabelGroup: fieldLabelGroup);
}

class _PaypalWithdrawalState extends WithdrawalFormState<PaypalWithdrawal> {
  late final TextEditingController emailController;
  final emailNode = FocusNode();

  _PaypalWithdrawalState({required AutoSizeGroup fieldLabelGroup})
      : super(fieldLabelGroup: fieldLabelGroup);

  @override
  void initState() {
    emailController = TextEditingController();
    emailNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailNode.dispose();
  }

  @override
  Widget recepientBuilder(BuildContext context, FocusScopeNode focusScopeNode) {
    return TextArea(
      focusNode: emailNode,
      controller: emailController,
      label: 'Paypal Email',
      labelGroup: widget.fieldLabelGroup,
      action: TextInputAction.next,
      inputType: TextInputType.emailAddress,
      onSubmitted: (val) {},
      onEditingComplete: () => focusScopeNode.nextFocus(),
    );
  }
}

class PayoneerWithdrawal extends StatefulWidget {
  PayoneerWithdrawal({Key? key, required this.fieldLabelGroup})
      : super(key: key);

  final AutoSizeGroup fieldLabelGroup;

  @override
  _PayoneerWithdrawalState createState() =>
      _PayoneerWithdrawalState(fieldLabelGroup: fieldLabelGroup);
}

class _PayoneerWithdrawalState extends WithdrawalFormState<PayoneerWithdrawal> {
  late final TextEditingController emailController;
  final emailNode = FocusNode();

  _PayoneerWithdrawalState({required AutoSizeGroup fieldLabelGroup})
      : super(fieldLabelGroup: fieldLabelGroup);

  @override
  void initState() {
    emailController = TextEditingController();
    emailNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailNode.dispose();
  }

  @override
  Widget recepientBuilder(BuildContext context, FocusScopeNode focusScopeNode) {
    return TextArea(
      focusNode: emailNode,
      controller: emailController,
      label: 'Payoneer Email',
      labelGroup: widget.fieldLabelGroup,
      action: TextInputAction.next,
      inputType: TextInputType.emailAddress,
      onSubmitted: (val) {},
      onEditingComplete: () => focusScopeNode.nextFocus(),
    );
  }
}
