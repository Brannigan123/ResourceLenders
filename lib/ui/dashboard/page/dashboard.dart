import 'package:cash_pump/ui/dashboard/widgets/sidemenu.dart';
import 'package:cash_pump/ui/dashboard/widgets/topbar.dart';
import 'package:cash_pump/ui/home/page/home.dart';
import 'package:cash_pump/ui/profile/pages/profile.dart';
import 'package:cash_pump/ui/withdrawal/pages/withdrawal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:layout/layout.dart';

enum EmbeddedDashboardPageKind { Home, Profile, Withdrawal }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

final displaySidebar =
    LayoutValue.fromBreakpoint(xs: false, sm: false, md: true);

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  late final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = ValueNotifier(EmbeddedDashboardPageKind.Home);
  }

  @override
  void dispose() {
    currentPage.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff000422), Color(0xff151935)],
            ),
          ),
          child: displaySidebar.resolve(context)
              ? DashboardWithSidebar(currentPage: currentPage)
              : DashboardWithDrawer(currentPage: currentPage),
        ),
      ),
    );
  }
}

class DashboardWithSidebar extends StatelessWidget {
  const DashboardWithSidebar({Key? key, required this.currentPage})
      : super(key: key);

  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(context.layout.gutter),
          child: SidebarMenu(currentPage: currentPage),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.5 * context.layout.gutter),
            child: EmbeddedDashboardPage(
                showDrawerToggle: false, currentPage: currentPage),
          ),
        ),
      ],
    );
  }
}

class DashboardWithDrawer extends StatefulWidget {
  const DashboardWithDrawer({Key? key, required this.currentPage})
      : super(key: key);

  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  _DashboardWithDrawerState createState() => _DashboardWithDrawerState();
}

class _DashboardWithDrawerState extends State<DashboardWithDrawer> {
  late final ZoomDrawerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ZoomDrawerController();
    widget.currentPage.addListener(_handlePageSelect);
  }

  @override
  void dispose() {
    widget.currentPage.removeListener(_handlePageSelect);
    super.dispose();
  }

  void _handlePageSelect() {
    _controller.close?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _controller,
      menuScreen: DrawerMenu(currentPage: widget.currentPage),
      mainScreen: EmbeddedDashboardPage(
          showDrawerToggle: true, currentPage: widget.currentPage),
      borderRadius: 24.0,
      showShadow: false,
      slideWidth: MediaQuery.of(context).size.width *
          (ZoomDrawer.isRTL() ? 0.45 : 0.55),
    );
  }
}

class EmbeddedDashboardPage extends StatefulWidget {
  const EmbeddedDashboardPage({
    Key? key,
    required this.showDrawerToggle,
    required this.currentPage,
  }) : super(key: key);

  final bool showDrawerToggle;
  final ValueNotifier<EmbeddedDashboardPageKind> currentPage;

  @override
  _EmbeddedDashboardPageState createState() => _EmbeddedDashboardPageState();
}

class _EmbeddedDashboardPageState extends State<EmbeddedDashboardPage> {
  late final PageController _pageController;
  late int _previousPageIndex;

  @override
  void initState() {
    super.initState();
    _previousPageIndex = widget.currentPage.value.index;
    _pageController = PageController(initialPage: _previousPageIndex);
    widget.currentPage.addListener(_onPageChange);
    _pageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange() {
    _previousPageIndex = widget.currentPage.value.index;
    _pageController.jumpToPage((_previousPageIndex)); //,
  }

  void _onPageScroll() {
    if (_pageController.page!.toInt() == _pageController.page) {
      _previousPageIndex = _pageController.page!.toInt();
    }
    print(_previousPageIndex);
    widget.currentPage.value =
        EmbeddedDashboardPageKind.values[_pageController.page!.toInt()];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff000422), Color(0xff151935)],
        ),
      ),
      child: Column(
        children: [
          Topbar(showDrawerToggle: widget.showDrawerToggle),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: EmbeddedDashboardPageKind.values.length,
              itemBuilder: (context, index) {
                if (index == EmbeddedDashboardPageKind.Home.index)
                  return HomePage();
                if (index == EmbeddedDashboardPageKind.Profile.index)
                  return ProfilePage();
                if (index == EmbeddedDashboardPageKind.Withdrawal.index)
                  return WithdrawalPage();
                return HomePage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
