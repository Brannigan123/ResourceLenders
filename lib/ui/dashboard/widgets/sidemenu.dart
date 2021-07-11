import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cash_pump/assets/assets.gen.dart';
import 'package:cash_pump/ui/dashboard/page/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:layout/layout.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key, required this.currentPage}) : super(key: key);

  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: LayoutBuilder(
        builder: (context, constraints) => Material(
          color: Color(0xff1B213E),
          shape: SuperellipseShape(borderRadius: BorderRadius.circular(24.0)),
          elevation: 2.0,
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            height: constraints.maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: UserPreview(showName: false),
                ),
                PageLinks(currentPage: currentPage, showTexts: false),
                Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: LogoutAction(showText: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key, required this.currentPage}) : super(key: key);

  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Material(
        color: Color(0xff1B213E),
        shape: SuperellipseShape(
          borderRadius: ZoomDrawer.isRTL()
              ? BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                ),
        ),
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          width: 0.45 * constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(0.5 * context.layout.gutter),
                child: UserPreview(showName: true),
              ),
              PageLinks(currentPage: currentPage, showTexts: true),
              Padding(
                padding: EdgeInsets.all(0.5 * context.layout.gutter),
                child: LogoutAction(showText: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserPreview extends StatelessWidget {
  const UserPreview({Key? key, required this.showName}) : super(key: key);

  final bool showName;

  @override
  Widget build(BuildContext context) {
    // default , when logged
    return Tooltip(
      message: 'Lachlan',
      textStyle: TextStyle(fontSize: 12.0, color: Color(0xff76A9EA)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [Color(0xff163458), Color(0xff242b5c)],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showName)
            Padding(
              padding: EdgeInsets.all(context.layout.gutter / 2.0),
              child: AutoSizeText(
                'Username',
                minFontSize: 8.0,
                style: TextStyle(
                  fontSize: 0.6 * context.layout.gutter,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff76A9EA),
                ),
              ),
            ),
          ClayAnimatedContainer(
            duration: kThemeAnimationDuration,
            color: Color(0xff1B213E),
            customBorderRadius:
                BorderRadius.circular(1.3 * context.layout.gutter),
            curveType: CurveType.convex,
            child: Padding(
              padding: EdgeInsets.all(0.15 * context.layout.gutter),
              child: AnimatedContainer(
                duration: kThemeAnimationDuration,
                width: 2.0 * context.layout.gutter,
                height: 2.0 * context.layout.gutter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: Color(0xff76A9EA),
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
    );
  }
}

class PageLinks extends StatelessWidget {
  const PageLinks({
    Key? key,
    required this.currentPage,
    required this.showTexts,
  }) : super(key: key);

  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;
  final bool showTexts;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EmbeddedDashboardPageKind>(
      valueListenable: currentPage,
      builder: (context, page, child) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(0.6 * context.layout.gutter),
            child: PageLink(
              iconData: Entypo.home,
              text: 'Home',
              showText: showTexts,
              selected: page == EmbeddedDashboardPageKind.Home,
              onTap: () => currentPage.value = EmbeddedDashboardPageKind.Home,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0.6 * context.layout.gutter),
            child: PageLink(
              iconData: Entypo.user,
              text: 'Profile',
              showText: showTexts,
              selected: page == EmbeddedDashboardPageKind.Profile,
              onTap: () =>
                  currentPage.value = EmbeddedDashboardPageKind.Profile,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0.6 * context.layout.gutter),
            child: PageLink(
              iconData: Entypo.credit_card,
              text: 'Withdraw',
              showText: showTexts,
              selected: page == EmbeddedDashboardPageKind.Withdrawal,
              onTap: () =>
                  currentPage.value = EmbeddedDashboardPageKind.Withdrawal,
            ),
          ),
        ],
      ),
    );
  }
}

class PageLink extends StatelessWidget {
  const PageLink({
    Key? key,
    required this.iconData,
    required this.text,
    required this.showText,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final IconData iconData;
  final String text;
  final bool showText;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: selected ? Colors.black12 : Colors.transparent,
      ),
      child: showText
          ? InkWell(
              borderRadius: BorderRadius.circular(10.0),
              hoverColor: Colors.black12,
              onTap: selected ? null : onTap,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.layout.gutter / 2.0),
                    child: Icon(
                      iconData,
                      size: context.layout.gutter,
                      color: selected ? Color(0xff008CF0) : Color(0xff76A9EA),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.layout.gutter / 2.0),
                    child: AutoSizeText(
                      text,
                      minFontSize: 8.0,
                      style: TextStyle(
                        fontSize: 0.5 * context.layout.gutter,
                        fontWeight: FontWeight.w600,
                        color: selected ? Color(0xff008CF0) : Color(0xff76A9EA),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Tooltip(
              message: text,
              textStyle: TextStyle(fontSize: 12.0, color: Color(0xff76A9EA)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [Color(0xff163458), Color(0xff242b5c)],
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                hoverColor: Colors.black12,
                onTap: selected ? null : onTap,
                child: Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: SizedBox(
                    width: context.layout.gutter,
                    height: context.layout.gutter,
                    child: Icon(
                      iconData,
                      size: 0.9 * context.layout.gutter,
                      color: selected ? Color(0xff008CF0) : Color(0xff76A9EA),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class LogoutAction extends StatelessWidget {
  const LogoutAction({Key? key, required this.showText}) : super(key: key);

  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Log out',
      textStyle: TextStyle(fontSize: 12.0, color: Color(0xff76A9EA)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [Color(0xff163458), Color(0xff242b5c)],
        ),
      ),
      child: ClayAnimatedContainer(
        duration: kThemeAnimationDuration,
        color: Color(0xff1B213E),
        customBorderRadius: BorderRadius.circular(10.0),
        spread: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          hoverColor: Colors.black12,
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showText)
                Padding(
                  padding: EdgeInsets.all(context.layout.gutter / 2.0),
                  child: AutoSizeText(
                    'Log Out',
                    minFontSize: 8.0,
                    style: TextStyle(
                      fontSize: 0.5 * context.layout.gutter,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff76A9EA),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(context.layout.gutter / 2.0),
                child: Icon(
                  Icons.logout,
                  size: 1.2 * context.layout.gutter,
                  color: Color(0xff76A9EA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
