import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design_petugas_app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;

class LaporanInfoScreen extends StatefulWidget {
  final String id;
  final String description;
  final String disasterType;
  final String imageUrl;
  final String location; // Assuming this is a "latitude,longitude" string
  final String timestamp;
  final String userId;

  LaporanInfoScreen({
    required this.id,
    required this.description,
    required this.disasterType,
    required this.imageUrl,
    required this.location,
    required this.timestamp,
    required this.userId,
  });

  @override
  _LaporanInfoScreenState createState() => _LaporanInfoScreenState();
}

class _LaporanInfoScreenState extends State<LaporanInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  String locationName = 'Loading...';
  String phoneNumber = '';

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
    _getLocationName();
    _fetchPhoneNumber();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  Future<void> _getLocationName() async {
    try {
      final coords = widget.location.split(',');
      final latitude = double.parse(coords[0]);
      final longitude = double.parse(coords[1]);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          locationName = placemarks.first.street ?? 'Unknown location';
        });
      }
    } catch (e) {
      setState(() {
        locationName = 'Unknown location';
      });
    }
  }

  Future<void> _fetchPhoneNumber() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('members')
          .doc(widget.userId)
          .get();
      if (snapshot.exists) {
        setState(() {
          phoneNumber = snapshot.data()!['phone'];
        });
      }
    } catch (e) {
      setState(() {
        phoneNumber = 'Phone not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: DesignPetugasAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            // Background image with blur effect
            Positioned.fill(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.network(widget.imageUrl),
                ),
              ],
            ),
            Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: DesignPetugasAppTheme.nearlyWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DesignPetugasAppTheme.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: infoHeight,
                              maxHeight: tempHeight > infoHeight
                                  ? tempHeight
                                  : infoHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, left: 18, right: 16),
                                child: Text(
                                  'Bencana\n${widget.disasterType}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignPetugasAppTheme.darkerText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 8, top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '+62$phoneNumber',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: DesignPetugasAppTheme.nearlyBPBD,
                                      ),
                                    ),

                                    // Container(
                                    //   child: Row(
                                    //     children: <Widget>[
                                    //       Text(
                                    //         'Hubungi Pelapor',
                                    //         textAlign: TextAlign.left,
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.w400,
                                    //           fontSize: 15,
                                    //           // letterSpacing: 0.27,
                                    //           color: DesignPetugasAppTheme.grey,
                                    //         ),
                                    //       ),
                                    //       Icon(
                                    //         Icons.call,
                                    //         color: DesignPetugasAppTheme.nearlyBPBD,
                                    //         size: 34,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        getTimeBoxUI(
                                            'Pelapor', widget.userId, false),
                                        getTimeBoxUI('Waktu Tanggal',
                                            widget.timestamp, false),
                                        GestureDetector(
                                          onTap: _openMaps,
                                          child: getTimeBoxUI(
                                              'Location', locationName, true),
                                        ),
                                        getTimeBoxUI(
                                            'Status', 'Menunggu', false),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                    opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                      child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                        child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                      Text(
                                        widget.description,
                                        textAlign: TextAlign.justify,
                                          style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 14,
                                          letterSpacing: 0.27,
                                          color: DesignPetugasAppTheme.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                  width: 48,
                                  height: 48,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: DesignPetugasAppTheme.nearlyWhite,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                      border: Border.all(
                                        color: DesignPetugasAppTheme.grey.withOpacity(0.2)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (phoneNumber.isNotEmpty && phoneNumber != 'Phone not available') {
                                         _launchPhoneCall(phoneNumber);
                                        } else {
                                        }
                                      },
                                      child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                          color: DesignPetugasAppTheme.nearlyBPBD,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: DesignPetugasAppTheme.nearlyBPBD.withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0,
                                            ),
                                            ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Hubungi Kami',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                  color: DesignPetugasAppTheme.nearlyWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).padding.bottom,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 59.0,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                  parent: animationController!,
                  curve: Curves.fastOutSlowIn,
                ),
                child: Row(
                  children: <Widget>[
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 8,
                  right: 8),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: DesignPetugasAppTheme.nearlyBPBD,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String txt1, String txt2, bool isLocation) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignPetugasAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignPetugasAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            children: <Widget>[
              Text(
                txt1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignPetugasAppTheme.nearlyBPBD,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignPetugasAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMaps() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(widget.location)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchPhoneCall(String phoneNumber) async {
  try {
    // Ensure phoneNumber starts with '0'
    if (!phoneNumber.startsWith('0')) {
      phoneNumber = '0$phoneNumber';
    }

    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching phone call: $e');
    // Handle error as needed
  }
}

}
