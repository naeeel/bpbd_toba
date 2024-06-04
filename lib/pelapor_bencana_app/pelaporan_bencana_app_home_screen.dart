import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/cuaca/cuaca_theme.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/models/tabIcon_data.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/profil/profil_screen.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/bottom_navigation_view/bottom_bar_view.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_theme.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/mitigasi/mitigasi_screen.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/beranda/beranda_screen_controller.dart';

class PelaporansAppHomeScreen extends StatefulWidget {
  @override
  _PelaporansAppHomeScreenState createState() =>
      _PelaporansAppHomeScreenState();
}

class _PelaporansAppHomeScreenState extends State<PelaporansAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: PelaporansAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = BerandaScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PelaporansAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      BerandaScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MitigasiScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = WeatherTheme(); // Perbaikan nama class
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
