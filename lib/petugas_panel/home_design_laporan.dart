import 'package:pelaporan_bencana/petugas_panel/laporan_terbaru_list_view.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_info_screen.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_bencana_list_view.dart';
import 'package:flutter/material.dart';
import 'design_petugas_app_theme.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.gempa;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignPetugasAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(context),
                      getKategoriUI(),
                      Flexible(
                        child: getLaporanBencanaUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getKategoriUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 18, right: 16),
          child: Text(
            'Categori Bencana',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignPetugasAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 50,
          child: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              getButtonUI(
                  CategoryType.gempa, categoryType == CategoryType.gempa),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.banjir, categoryType == CategoryType.banjir),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.kebakaran, categoryType == CategoryType.kebakaran),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.longsor, categoryType == CategoryType.longsor),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.gunung, categoryType == CategoryType.gunung),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.angin, categoryType == CategoryType.angin),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.tsunami, categoryType == CategoryType.tsunami),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.lainnya, categoryType == CategoryType.lainnya),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        LaporanTerbaruListView(
          callBack: () {
            moveTo();
          },
        ),
      ],
    );
  }

  Widget getLaporanBencanaUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Laporan Bencana',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignPetugasAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: LaporanBencanaListView(
              callBack: () {
                moveTo();
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LaporanInfoScreen(),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.gempa == categoryTypeData) {
      txt = 'Gempa';
    } else if (CategoryType.banjir == categoryTypeData) {
      txt = 'Banjir';
    } else if (CategoryType.kebakaran == categoryTypeData) {
      txt = 'Kebakaran';
    } else if (CategoryType.longsor == categoryTypeData) {
      txt = 'longsor';
    } else if (CategoryType.gunung == categoryTypeData) {
      txt = 'Gunung Merapi';
    } else if (CategoryType.angin == categoryTypeData) {
      txt = 'Angin Topan';
    } else if (CategoryType.tsunami == categoryTypeData) {
      txt = 'Tsunami';
    } else if (CategoryType.lainnya == categoryTypeData) {
      txt = 'lainnya';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignPetugasAppTheme.nearlyBPBD
                : DesignPetugasAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignPetugasAppTheme.nearlyBPBD)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignPetugasAppTheme.nearlyWhite
                        : DesignPetugasAppTheme.nearlyBPBD,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignPetugasAppTheme.nearlyBPBD,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Cari bencana',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hello Petugas',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignPetugasAppTheme.grey,
                  ),
                ),
                Text(
                  'Laporan Bencana',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignPetugasAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/design_course/userImage.png'),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  gempa,
  banjir,
  kebakaran,
  longsor,
  gunung,
  angin,
  tsunami,
  lainnya,
}
