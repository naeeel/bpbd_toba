import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelaporan_bencana/main.dart';
import 'package:pelaporan_bencana/petugas_panel/design_petugas_app_theme.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_terbaru_list_view.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_info_screen.dart';
import 'package:pelaporan_bencana/petugas_panel/models/Category.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_bencana_list_view.dart';

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
                      getSearchBarUI(),
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
            'Kategori Bencana',
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
        
        const SizedBox(
          height: 16,
        ),
        LaporanTerbaruListView(
          callBack: (Category category) {
            moveTo(category);
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
              callBack: (Category category) {
                moveTo(category);
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo(Category category) {
    // Assuming category.location is a GeoPoint
    String locationString =
        "${category.location.latitude}, ${category.location.longitude}";

    // Convert Timestamp to String
    String formattedTimestamp =
    DateFormat('dd MMM yyyy, hh:mm a').format(category.timestamp.toDate());

    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LaporanInfoScreen(
          id: category.id,
          description: category.description,
          disasterType: category.disasterType,
          imageUrl: category.imageUrl,
          location: locationString, // Pass the converted string here
          timestamp: formattedTimestamp, // Pass the formatted string here
          userId: category.userId,
        ),
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
          border: Border.all(color: DesignPetugasAppTheme.nearlyBPBD),
        ),
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

  Widget getSearchBarUI() {
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
                // child: Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Container(
                //         padding: const EdgeInsets.only(left: 16, right: 16),
                //         child: TextFormField(
                //           style: TextStyle(
                //             fontFamily: 'WorkSans',
                //             fontWeight: FontWeight.bold,
                //             fontSize: 16,
                //             color: DesignPetugasAppTheme.nearlyBPBD,
                //           ),
                //           keyboardType: TextInputType.text,
                //           decoration: InputDecoration(
                //             labelText: 'Cari bencana',
                //             border: InputBorder.none,
                //             helperStyle: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16,
                //               color: HexColor('#B9BABC'),
                //             ),
                //             labelStyle: TextStyle(
                //               fontWeight: FontWeight.w600,
                //               fontSize: 16,
                //               letterSpacing: 0.2,
                //               color: HexColor('#B9BABC'),
                //             ),
                //           ),
                //           onEditingComplete: () {},
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 60,
                //       height: 60,
                //       child: Icon(Icons.search, color: HexColor('#B9BABC')),
                //     )
                //   ],
                // ),
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
            child: Image.asset('assets/introduction_animation/logo.png'),
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