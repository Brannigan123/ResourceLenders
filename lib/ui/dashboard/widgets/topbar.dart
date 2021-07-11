import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:layout/layout.dart';

class Topbar extends StatelessWidget {
  const Topbar({Key? key, required this.showDrawerToggle}) : super(key: key);

  final bool showDrawerToggle;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: showDrawerToggle ? Color(0xff1B213E) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDrawerToggle)
              Padding(
                padding: EdgeInsets.all(context.layout.gutter / 2.0),
                child: TopbarBtn(
                  iconData: Icons.menu_outlined,
                  onTap: () => ZoomDrawer.of(context)!.toggle(),
                ),
              ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(context.layout.gutter / 2.0),
              child: TopbarBtn(
                iconData: Icons.settings,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopbarBtn extends StatefulWidget {
  TopbarBtn({Key? key, required this.iconData, this.onTap}) : super(key: key);

  final IconData iconData;
  final VoidCallback? onTap;

  @override
  _TopbarBtnState createState() => _TopbarBtnState();
}

class _TopbarBtnState extends State<TopbarBtn> {
  late final ValueNotifier<bool> hovered;
  late final ValueNotifier<bool> pressed;

  final double expandRatio = 0.1;

  @override
  void initState() {
    super.initState();
    hovered = ValueNotifier<bool>(false);
    pressed = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    hovered.dispose();
    pressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => hovered.value = true,
      onExit: (event) => hovered.value = false,
      child: GestureDetector(
        onTapDown: (details) => pressed.value = true,
        onTapUp: (details) => pressed.value = false,
        onTap: widget.onTap,
        child: SizedBox(
          width: context.layout.gutter * (1.0 + expandRatio),
          height: context.layout.gutter * (1.0 + expandRatio),
          child: ValueListenableBuilder<bool>(
            valueListenable: pressed,
            builder: (context, isPressed, child) => AnimatedPadding(
              duration: kThemeAnimationDuration,
              padding: isPressed
                  ? EdgeInsets.zero
                  : EdgeInsets.all(context.layout.gutter * expandRatio),
              child: ValueListenableBuilder<bool>(
                valueListenable: hovered,
                builder: (context, isHovered, child) => FittedBox(
                  fit: BoxFit.fill,
                  child: AnimatedOpacity(
                    duration: kThemeAnimationDuration,
                    opacity: isHovered ? 0.8 : 1.0,
                    child: Icon(
                      widget.iconData,
                      color: Color(0xff76A9EA),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
