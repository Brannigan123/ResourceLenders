import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/models/withdrawal.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:sizer/sizer.dart';

class WithdrawalView extends StatelessWidget {
  const WithdrawalView({
    Key? key,
    required this.withdrawal,
    required this.amountLabelGroup,
    required this.methodLabelGroup,
    required this.timeLabelGroup,
    required this.idLabelGroup,
  }) : super(key: key);

  final Withdrawal withdrawal;

  final AutoSizeGroup amountLabelGroup;
  final AutoSizeGroup methodLabelGroup;
  final AutoSizeGroup timeLabelGroup;
  final AutoSizeGroup idLabelGroup;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff76A9EA),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(0.25 * context.layout.gutter),
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            iconColor: Color(0xff2765FF),
            iconSize: context.layout.gutter,
            iconPadding: EdgeInsets.all(
              0.25 * context.layout.gutter,
            ),
            useInkWell: true,
            tapHeaderToExpand: true,
          ),
          header: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(
                    0.25 * context.layout.gutter,
                  ),
                  child: withdrawal.method.logo.svg(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                    width: 4.5 * context.layout.gutter,
                  ),
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 5,
                child: AutoSizeText(
                  withdrawal.fstr(WithdrawalField.Amount),
                  group: amountLabelGroup,
                  maxLines: 1,
                  minFontSize: 4.0.sp.ceilToDouble(),
                  style: TextStyle(
                    color: Color(0xff2765FF),
                    fontSize: 7.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
          collapsed: Container(),
          expanded: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: false ? Axis.vertical : Axis.horizontal,
                mainAxisSize: false ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: false
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: false
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      0.2 * context.layout.gutter,
                    ),
                    child: AutoSizeText(
                      withdrawal.fstr(WithdrawalField.Method),
                      group: methodLabelGroup,
                      minFontSize: 5.0.sp.ceilToDouble(),
                      style: TextStyle(
                        color: Color(0xffd7d7d7),
                        fontSize: 7.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      0.2 * context.layout.gutter,
                    ),
                    child: AutoSizeText(
                      withdrawal.fstr(WithdrawalField.Time),
                      maxLines: 2,
                      group: timeLabelGroup,
                      minFontSize: 2.sp.ceilToDouble(),
                      style: TextStyle(
                        color: Color(0xffd7d7d7),
                        fontSize: 6.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(
                  0.2 * context.layout.gutter,
                ),
                child: AutoSizeText(
                  withdrawal.fstr(WithdrawalField.Id),
                  group: idLabelGroup,
                  minFontSize: 3.0.sp.ceilToDouble(),
                  style: TextStyle(
                    color: Color(0xffd7d7d7),
                    fontSize: 5.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
