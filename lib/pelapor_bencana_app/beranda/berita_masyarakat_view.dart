import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_theme.dart';
import 'dart:ui';

class BeritaService {
  final CollectionReference _beritaRef =
      FirebaseFirestore.instance.collection('berita');

  Future<List<Berita>> getBerita() async {
    try {
      final QuerySnapshot snapshot = await _beritaRef.get();
      print('Berita snapshot: ${snapshot.docs.length}'); // Add log here
      return snapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting Berita: $e');
      return [];
    }
  }

  Stream<List<Berita>> getBeritaStream() {
    return _beritaRef.snapshots().map((snapshot) {
      try {
        return snapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
      } catch (e) {
        print('Error processing stream data: $e');
        return [];
      }
    });
  }
}

class Berita {
  final String deskripsi;
  final String gambar;
  final String jenisBencana;
  final Timestamp waktuPelaporan;

  Berita({
    required this.deskripsi,
    required this.gambar,
    required this.jenisBencana,
    required this.waktuPelaporan,
  });

  factory Berita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Berita data: $data'); // Add log here
    return Berita(
      deskripsi: data['deskripsi'] ?? '',
      gambar: data['gambar'] ?? '',
      jenisBencana: data['jenis_bencana'] ?? '',
      waktuPelaporan: data['waktu_pelaporan'] ?? Timestamp.now(),
    );
  }
}

class BeritaMasyarakatView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const BeritaMasyarakatView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _BeritaMasyarakatViewState createState() => _BeritaMasyarakatViewState();
}

class _BeritaMasyarakatViewState extends State<BeritaMasyarakatView> {
  Map<int, bool> showFullDescriptionMap = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Berita>>(
      stream: BeritaService().getBeritaStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<Berita> beritaList = snapshot.data!;
        return AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: widget.animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - widget.animation!.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 16, bottom: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: PelaporansAppTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: PelaporansAppTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(
                      children: beritaList.map((berita) {
                        int index = beritaList.indexOf(berita);
                        bool showFullDescription =
                            showFullDescriptionMap[index] ?? false;
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 8, top: 16),
                                    child: Text(
                                      'Berita Bencana',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily:
                                              PelaporansAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: PelaporansAppTheme.darkText),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, bottom: 3),
                                            child: Text(
                                              berita.jenisBencana,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    PelaporansAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 32,
                                                color: PelaporansAppTheme
                                                    .nearlyDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time,
                                                color: PelaporansAppTheme.grey
                                                    .withOpacity(0.5),
                                                size: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text(
                                                  '${berita.waktuPelaporan.toDate()}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        PelaporansAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: 0.0,
                                                    color: PelaporansAppTheme
                                                        .grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 14),
                                            child: Text(
                                              'Balige Sumatera Utara',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    PelaporansAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: PelaporansAppTheme
                                                    .nearlyDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    NetworkImage(berita.gambar),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(),
                                          ),
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Image.network(
                                                    berita.gambar,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          offset: const Offset(4, 4),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        berita.gambar,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 8, bottom: 8),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: PelaporansAppTheme.background,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 8, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Deskripsi bencana',
                                    style: TextStyle(
                                      fontFamily: PelaporansAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      color: PelaporansAppTheme.nearlyDarkBlue,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    berita.deskripsi,
                                    maxLines: showFullDescription ? null : 5,
                                    style: TextStyle(
                                      fontFamily: PelaporansAppTheme.fontName,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      color: PelaporansAppTheme.grey
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showFullDescriptionMap[index] =
                                            !(showFullDescriptionMap[index] ??
                                                false);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        showFullDescription
                                            ? 'Tutup'
                                            : 'Baca Selengkapnya',
                                        style: TextStyle(
                                          fontFamily:
                                              PelaporansAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          letterSpacing: 0.0,
                                          color:
                                              PelaporansAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only( 
                                        left: 24, right: 24, top: 8, bottom: 8),
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: PelaporansAppTheme.background,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
