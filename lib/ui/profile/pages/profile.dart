import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_pump/assets/assets.gen.dart';
import 'package:cash_pump/ui/widgets/async_btn.dart';
import 'package:cash_pump/ui/widgets/textarea.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:number_display/number_display.dart';
import 'package:supercharged/supercharged.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

final moneiteryDisplay = createDisplay(
  length: 5,
  decimal: 2,
  placeholder: '--',
  separator: ',',
  decimalPoint: '.',
  units: ['K', 'M', 'B', 'T'],
);

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.all(0.5 * context.layout.gutter),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1100.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePicRegion(),
              FocusScope(child: ProfileDetailsRegion()),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePicRegion extends StatelessWidget {
  const ProfilePicRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        height: 5.0 * context.layout.gutter,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: kThemeAnimationDuration,
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: kThemeAnimationDuration,
                    decoration: BoxDecoration(
                      color: Color(0xff163458),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(context.layout.gutter / 2.0),
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
                  child: ClipOval(
                    child: Assets.images.avatars.user.image(fit: BoxFit.cover),
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

class ProfileDetailsRegion extends StatefulWidget {
  const ProfileDetailsRegion({Key? key}) : super(key: key);

  @override
  _ProfileDetailsRegionState createState() => _ProfileDetailsRegionState();
}

class _ProfileDetailsRegionState extends State<ProfileDetailsRegion> {
  late final ValueNotifier<double> totalEarnings;
  late final ValueNotifier<String> currentUsername;

  late final TextEditingController totalEarningController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  final fieldLabelGroup = AutoSizeGroup();

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  final updateNode = FocusNode();

  @override
  void initState() {
    super.initState();

    totalEarnings = ValueNotifier(987778.99);
    currentUsername = ValueNotifier('Lachlan Watson');

    totalEarningController = TextEditingController(text: '__');
    usernameController = TextEditingController(text: currentUsername.value);
    passwordController = TextEditingController(text: '');

    totalEarnings.addListener(_onUpdateTotalEarning);
    usernameNode.requestFocus();

    _onUpdateTotalEarning();
  }

  @override
  void dispose() {
    totalEarnings.removeListener(_onUpdateTotalEarning);

    totalEarnings.dispose();
    currentUsername.dispose();

    totalEarningController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    usernameNode.dispose();
    passwordNode.dispose();
    updateNode.dispose();

    super.dispose();
  }

  void _onUpdateTotalEarning() {
    final bal = moneiteryDisplay(totalEarnings.value);
    totalEarningController.text = '\$ $bal';
  }

  @override
  Widget build(BuildContext context) {
    final focusScopeNode = FocusScope.of(context);

    return FractionallySizedBox(
      widthFactor: 0.75,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          gradient: LinearGradient(
            colors: [Color(0xff163458), Color(0xff475993)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 0.65,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ValueListenableBuilder<String>(
                  valueListenable: currentUsername,
                  builder: (context, username, child) => AutoSizeText(
                    username,
                    maxLines: 2,
                    minFontSize: 6.sp.ceilToDouble(),
                    style: TextStyle(
                      color: Color(0xff76A9EA),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.55,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AutoSizeText(
                  'Joined ${timeago.format(DateTime.now() - 67.days)}',
                  maxLines: 2,
                  minFontSize: 4.0.sp.ceilToDouble(),
                  style: TextStyle(
                    color: Color(0xff76A9EA),
                    fontSize: 6.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.layout.gutter * 0.35),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 720.0),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Padding(
                  padding: EdgeInsets.all(0.35 * context.layout.gutter),
                  child: TextArea(
                    controller: totalEarningController,
                    label: 'Total Earning',
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
                    focusNode: usernameNode,
                    controller: usernameController,
                    label: 'Username',
                    labelGroup: fieldLabelGroup,
                    action: TextInputAction.next,
                    inputType: TextInputType.name,
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
                        focusNode: updateNode,
                        callback: () async => await Future.delayed(3.seconds),
                        idleText: 'Update',
                        loadingText: 'Updating',
                        successText: 'Updated',
                        errorText: 'Failed',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.1 * context.layout.gutter),
          ],
        ),
      ),
    );
  }
}
