import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:automatic_animated_list/automatic_animated_list.dart';
import 'package:cash_pump/constants/sort.dart';
import 'package:cash_pump/models/withdrawal.dart';
import 'package:cash_pump/ui/home/widgets/history_graph.dart';
import 'package:cash_pump/ui/home/widgets/withdrawal_view.dart';
import 'package:cash_pump/ui/widgets/dateperiod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:layout/layout.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:number_display/number_display.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sizer/sizer.dart';

final displayAsSingleColumn = LayoutValue.fromBreakpoint(xs: true, sm: false);

final moneiteryDisplay = createDisplay(
  length: 5,
  decimal: 2,
  placeholder: '--',
  separator: ',',
  decimalPoint: '.',
  units: ['K', 'M', 'B', 'T'],
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  late final ValueNotifier<DatePeriod> period;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    period = ValueNotifier<DatePeriod>(DatePeriod(today, today));
  }

  @override
  void dispose() {
    period.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return displayAsSingleColumn.resolve(context)
        ? SingleColumnView(period: period)
        : MetroView(period: period);
  }
}

class SingleColumnView extends StatefulWidget {
  const SingleColumnView({Key? key, required this.period}) : super(key: key);

  final ValueNotifier<DatePeriod> period;

  @override
  _SingleColumnViewState createState() => _SingleColumnViewState();
}

class _SingleColumnViewState extends State<SingleColumnView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scrollbar(
        controller: scrollController,
        showTrackOnHover: true,
        isAlwaysShown: true,
        // style: VsScrollbarStyle(
        //   radius: Radius.circular(2.0),
        //   color: Color(0xff000422),
        //   thickness: 5.0,
        //   hoverThickness: 8.0,
        // ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1.1 * context.layout.gutter),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: BalanceCard(),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: EarningPeriod(period: widget.period),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.layout.gutter),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: EarningChart(period: widget.period),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.99,
                child: ConstrainedBox(
                  constraints: constraints.copyWith(
                    minWidth: 0.0,
                    minHeight: 0.0,
                    maxHeight: 0.75 * constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(context.layout.gutter),
                    child: WithdrawalHistory(),
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

class MetroView extends StatelessWidget {
  const MetroView({Key? key, required this.period}) : super(key: key);

  final ValueNotifier<DatePeriod> period;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: EarningPeriod(period: period),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: EarningChart(period: period),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: BalanceCard(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: WithdrawalHistory(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class EarningPeriod extends StatelessWidget {
  const EarningPeriod({Key? key, required this.period}) : super(key: key);
  final ValueNotifier<DatePeriod> period;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff242b5c), Color(0xff475993)],
        ),
      ),
      child: ValueListenableBuilder<DatePeriod>(
        valueListenable: period,
        builder: (context, _period, child) => Flex(
          direction:
              context.layout.breakpoint.isXs ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(context.layout.gutter / 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.all(context.layout.gutter / 2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: AutoSizeText(
                                  'Total Earning',
                                  maxLines: 1,
                                  minFontSize: 6.0.sp.ceilToDouble(),
                                  style: TextStyle(
                                    color: Color(0xffd7d7d7),
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: FractionallySizedBox(
                                widthFactor: 0.8,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: DatePeriodeView(
                                    period: _period,
                                    style: TextStyle(
                                      color: Color(0xffd7d7d7),
                                      fontSize: 10.0.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(context.layout.gutter / 2.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.65,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tooltip(
                              message: '\$ ${784873.97}',
                              textStyle: TextStyle(
                                fontSize: 5.0.sp,
                                color: Color(0xff76A9EA),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff163458),
                                    Color(0xff242b5c),
                                  ],
                                ),
                              ),
                              child: AutoSizeText(
                                '\$ ${moneiteryDisplay((_period.end.difference(_period.start)).inHours)}',
                                maxLines: 1,
                                minFontSize: 7.0.sp.ceilToDouble(),
                                style: TextStyle(
                                  color: Color(0xff76A9EA),
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(context.layout.gutter / 2.0),
                child: RangePicker(
                  selectedPeriod: _period,
                  firstDate: DateTime.now() - 365.days,
                  lastDate: DateTime.now() + 365.days,
                  onChanged: (p) => period.value = p,
                  datePickerStyles: DatePickerRangeStyles(
                    prevIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xdde8e8e8),
                    ),
                    nextIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xdde8e8e8),
                    ),
                    displayedPeriodTitle: TextStyle(
                      color: Color(0xdde8e8e8),
                      fontSize: 7.0.sp,
                    ),
                    dayHeaderStyleBuilder: (i) => DayHeaderStyle(
                      textStyle: TextStyle(
                        color: Color(0xdde8e8e8),
                        fontWeight: FontWeight.bold,
                        fontSize: 6.5.sp,
                      ),
                      decoration: BoxDecoration(color: Colors.black12),
                    ),
                    defaultDateTextStyle: TextStyle(
                      color: Color(0xffA8B3Bd),
                      fontSize: 6.0.sp,
                    ),
                    currentDateStyle: TextStyle(
                      color: Color(0xff3cf7ff),
                      fontWeight: FontWeight.bold,
                      fontSize: 6.0.sp,
                    ),
                    selectedDateStyle: TextStyle(
                      color: Color(0xffe8e8e8),
                      fontSize: 6.0.sp,
                    ),
                    selectedSingleDateDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: Color(0xff2765FF),
                    ),
                    selectedPeriodStartTextStyle: TextStyle(
                      color: Color(0xffe8e8e8),
                      fontWeight: FontWeight.bold,
                      fontSize: 6.0.sp,
                    ),
                    selectedPeriodStartDecoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        bottomLeft: Radius.circular(24.0),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff008CF0),
                            Color(0xff2765FF),
                          ]),
                    ),
                    selectedPeriodMiddleTextStyle: TextStyle(
                      color: Color(0xffe8e8e8),
                      fontSize: 6.0.sp,
                    ),
                    selectedPeriodMiddleDecoration: BoxDecoration(
                      color: Color(0xff2765FF),
                    ),
                    selectedPeriodEndTextStyle: TextStyle(
                      color: Color(0xffe8e8e8),
                      fontWeight: FontWeight.bold,
                      fontSize: 6.0.sp,
                    ),
                    selectedPeriodLastDecoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24.0),
                        bottomRight: Radius.circular(24.0),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff2765FF),
                            Color(0xff008CF0),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EarningChart extends StatelessWidget {
  const EarningChart({Key? key, required this.period}) : super(key: key);

  final ValueNotifier<DatePeriod> period;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff163458), Color(0xff475993)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.layout.gutter / 1.0),
            child: AutoSizeText(
              'Earnings',
              minFontSize: 7.0.sp.ceilToDouble(),
              style: TextStyle(
                color: Color(0xffd7d7d7),
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.layout.gutter / 1.0),
              child: HistoryGraph(
                withdrawals: ValueNotifier([]),
              ), // LineChart(avgData(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff2765FF), Color(0xff17D7FF)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(0.25 * context.layout.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(0.25 * context.layout.gutter),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AutoSizeText(
                          'Current Balance',
                          maxLines: 1,
                          minFontSize: 7.0.sp.ceilToDouble(),
                          style: TextStyle(
                            color: Color(0xffd7d7d7),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.layout.gutter),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomAnimation<double>(
                          duration: 300.milliseconds,
                          control: CustomAnimationControl.LOOP,
                          tween: (0.0).tweenTo(1.0),
                          builder: (context, child, turns) => Transform.rotate(
                            angle: turns,
                            child: Icon(
                              Icons.settings_outlined,
                              size: 2.0 * context.layout.gutter,
                              color: Color(0xffdddddd),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(0.35 * context.layout.gutter),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Tooltip(
                    message: '\$ ${784873.97}',
                    textStyle:
                        TextStyle(fontSize: 5.0.sp, color: Color(0xff76A9EA)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        colors: [Color(0xff163458), Color(0xff242b5c)],
                      ),
                    ),
                    child: AutoSizeText(
                      '\$ ${moneiteryDisplay(784873.97)}',
                      maxLines: 1,
                      minFontSize: 10.0.sp.ceilToDouble(),
                      style: TextStyle(
                        color: Color(0xffFF9C3A),
                        fontSize: context.layout.gutter * 4.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum HistoryState { Loading, Stable }

class WithdrawalHistory extends StatefulWidget {
  const WithdrawalHistory({Key? key}) : super(key: key);

  @override
  _WithdrawalHistoryState createState() => _WithdrawalHistoryState();
}

class _WithdrawalHistoryState extends State<WithdrawalHistory> {
  late final ValueNotifier<List<Withdrawal>> withdrawals;
  late final ValueNotifier<HistoryState> state;

  late final ValueNotifier<WithdrawalField> sortField;
  late final ValueNotifier<Sort> timeSort;
  late final ValueNotifier<Sort> amountSort;
  late final ValueNotifier<Sort> methodSort;

  late final ScrollController scrollController;

  final amountLabelGroup = AutoSizeGroup();
  final methodLabelGroup = AutoSizeGroup();
  final timeLabelGroup = AutoSizeGroup();
  final idLabelGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();

    withdrawals = ValueNotifier<List<Withdrawal>>([]);
    state = ValueNotifier(HistoryState.Stable);

    sortField = ValueNotifier<WithdrawalField>(WithdrawalField.Time);
    timeSort = ValueNotifier<Sort>(Sort.Descending);
    amountSort = ValueNotifier<Sort>(Sort.Descending);
    methodSort = ValueNotifier<Sort>(Sort.Ascending);

    scrollController = ScrollController();

    _loadMoreWithdrawals();
  }

  @override
  void dispose() {
    withdrawals.dispose();
    state.dispose();

    sortField.dispose();
    timeSort.dispose();
    amountSort.dispose();
    methodSort.dispose();

    scrollController.dispose();

    super.dispose();
  }

  Future<bool> _loadMoreWithdrawals() async {
    state.value = HistoryState.Loading;

    await Future.delayed(2.seconds);

    final list = [...withdrawals.value];
    final theresMore = list.length <= 200;

    if (theresMore) {
      final rng = Random();

      var time = list.isEmpty ? DateTime.now() - 2.hours : list.last.time;

      list.addAll(List.generate(
        4,
        (i) {
          time = time - rng.nextInt(566).hours;
          return Withdrawal(
            time: time,
            amount: rng.nextDouble() * 1000,
            method: WithdrawalMethod
                .values[rng.nextInt(WithdrawalMethod.values.length)],
            id: '${rng.nextInt(1000)} ${rng.nextInt(1000)} ${rng.nextInt(1000)} ${rng.nextInt(1000)}',
          );
        },
      ).reversed);

      withdrawals.value = list;
    }

    if (mounted) state.value = HistoryState.Stable;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0097BB), Color(0xff4FA6BB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(context.layout.gutter),
            child: AutoSizeText(
              'Withdrawals',
              maxLines: 1,
              minFontSize: 7.0.sp.ceilToDouble(),
              style: TextStyle(
                color: Color(0xffd7d7d7),
                fontWeight: FontWeight.bold,
                fontSize: 10.0.sp.ceilToDouble(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0.5 * context.layout.gutter),
              child: ValueListenableBuilder<List<Withdrawal>>(
                valueListenable: withdrawals,
                builder: (context, _withdrawals, child) => Scrollbar(
                  controller: scrollController,
                  showTrackOnHover: true,
                  isAlwaysShown: true,
                  // style: VsScrollbarStyle(
                  //   radius: Radius.circular(2.0),
                  //   color: Color(0xff000422),
                  //   thickness: 5.0,
                  //   hoverThickness: 8.0,
                  // ),
                  child: AutomaticAnimatedList<Withdrawal>(
                    controller: scrollController,
                    items: _withdrawals,
                    insertDuration: 1.seconds,
                    removeDuration: 1.seconds,
                    keyingFunction: (withdrawal) => Key(withdrawal.id),
                    itemBuilder: (context, withdrawal, animation) {
                      final isLast = withdrawal.id == _withdrawals.last.id;

                      final view = FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: WithdrawalView(
                            withdrawal: withdrawal,
                            amountLabelGroup: amountLabelGroup,
                            methodLabelGroup: methodLabelGroup,
                            timeLabelGroup: timeLabelGroup,
                            idLabelGroup: idLabelGroup,
                          ),
                        ),
                      );

                      return isLast
                          ? VisibilityDetector(
                              key: Key(withdrawal.id),
                              onVisibilityChanged: (visibilityInfo) async {
                                if (visibilityInfo.visibleFraction == 1.0) {
                                  await _loadMoreWithdrawals();
                                }
                              },
                              child: view,
                            )
                          : view;
                    },
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<HistoryState>(
            valueListenable: state,
            builder: (context, _state, child) => _state == HistoryState.Stable
                ? SizedBox.shrink()
                : SpinKitThreeBounce(
                    color: Color(0xffd7d7d7),
                    size: 1.0 * context.layout.gutter,
                  ),
          ),
          SizedBox(height: 0.25 * context.layout.gutter),
        ],
      ),
    );
  }
}
