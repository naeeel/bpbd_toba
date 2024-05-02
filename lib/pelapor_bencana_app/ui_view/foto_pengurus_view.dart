import 'package:flutter/material.dart';

import '../pelaporan_bencana_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> areaListData = <String>[
    'assets/pelaporan_app/ketua.jpeg',
    'assets/pelaporan_app/peng1.jpeg',
    'assets/pelaporan_app/peng2.jpeg',
    'assets/pelaporan_app/peng3.jpeg',
    'assets/pelaporan_app/peng4.jpeg',
    'assets/pelaporan_app/ketua.jpeg',
    'assets/pelaporan_app/ketua.jpeg',
    'assets/pelaporan_app/ketua.jpeg',
    'assets/pelaporan_app/ketua.jpeg',
    'assets/pelaporan_app/ketua.jpeg',
  ];

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - widget.mainScreenAnimation!.value),
              0.0,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: areaListData.length,
                  itemBuilder: (context, index) {
                    final int count = areaListData.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController!,
                        curve: Interval(
                          (1 / count) * index,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    );
                    animationController?.forward();
                    return AreaView(
                      imagepath: areaListData[index],
                      animation: animation,
                      animationController: animationController!,
                      ketuaName: _getKetuaName(index),
                      jabatan: _getJabatan(index),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getKetuaName(int index) {
    switch (index) {
      case 0:
        return 'Dr. PONTAS HUMISAR BATUBARA, M.Kes';
      case 1:
        return 'MARASI SIMAMORA, S.Pd';
      case 2:
        return 'Ir. JHON PITER SILALAHI, MT';
      case 3:
        return 'RIDOLF SIMANJUNTAK, SH';
      case 4:
        return 'BERTON SIMANJUNTAK, SH';
      case 5:
        return 'HERMANTO SITORUS, ST';
      case 6:
        return 'RIVAYANTI SAGALA, SE';
      case 7:
        return 'KOORSAS TAMPUBOLON, ST';
      case 8:
        return 'PARLINDUNGAN PASARIBU, SE';
      case 9:
        return 'MARADONG NAPITUPULU, SH';
      default:
        return '';
    }
  }

  String _getJabatan(int index) {
    switch (index) {
      case 0:
        return 'KEPALA UNSUR PELAKSANA';
      case 1:
        return 'SEKRETARIS';
      case 2:
        return 'KABID PENCEGAHAN & KESIAPSIAGAAN';
      case 3:
        return 'KABID KEDARURATAN & LOGISTIK';
      case 4:
        return 'KABID REHABILITASI REKONSTRUKSI';
      case 5:
        return 'KASUBBAG PERENCANAAN';
      case 6:
        return 'KASUBBAG UMUM DAN KEPEGAWAIAN';
      case 7:
        return 'KASI KESIAPSIAGAAN';
      case 8:
        return 'KASI KEDARURATAN';
      case 9:
        return 'KASI REHABILITASI';
      default:
        return '';
    }
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    this.imagepath,
    this.animationController,
    this.animation,
    this.ketuaName,
    this.jabatan,
  }) : super(key: key);

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? ketuaName;
  final String? jabatan;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: PelaporansAppTheme.white,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(255, 58, 81, 96).withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: Color(0xFF2633C5).withOpacity(0.2),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        imagepath!,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ketuaName ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        jabatan ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
