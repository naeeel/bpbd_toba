import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'design_petugas_app_theme.dart';
import 'models/category.dart';

class LaporanInfoScreen extends StatefulWidget {
  final String categoryId;

  const LaporanInfoScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _LaporanInfoScreenState createState() => _LaporanInfoScreenState();
}

class _LaporanInfoScreenState extends State<LaporanInfoScreen> with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  bool isImageExpanded = false;
  String selectedImagePath = '';

  Category? category;
  String? userName;
  String? location;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    fetchCategoryData();
    super.initState();
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

  Future<void> fetchCategoryData() async {
    DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .get();

    if (categorySnapshot.exists) {
      setState(() {
        category = Category.fromFirestore(categorySnapshot);
      });

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(category!.userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot['name'];
          location = userSnapshot['location'];
        });
      }
    }
  }

  String formatDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat.yMMMMd().format(date);
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
            Column(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: category != null
                        ? Image.network(
                            category!.imagePath,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/design_course/banjir.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
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
                              category != null
                                  ? category!.disasterType
                                  : 'Bencana',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  category != null
                                      ? formatDate(category!.timestamp)
                                      : 'Tanggal',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignPetugasAppTheme.nearlyBPBD,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Status',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: DesignPetugasAppTheme.grey,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.hourglass_bottom,
                                        color: DesignPetugasAppTheme.nearlyBPBD,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI('Pengguna', userName ?? 'Loading...'),
                                  getTimeBoxUI('Lokasi', location ?? 'Loading...'),
                                  getTimeBoxUI('Status', 'Seat'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isImageExpanded = true;
                                            selectedImagePath = category != null
                                                ? category!.imagePath
                                                : 'assets/design_course/banjir.jpg';
                                          });
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              fullscreenDialog: true,
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              pageBuilder: (_, __, ___) =>
                                                  _buildImageDetailPage(),
                                            ),
                                          );
                                        },
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: opacity1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: category != null
                                                  ? Image.network(
                                                      category!.imagePath,
                                                    )
                                                  : Image.asset(
                                                      'assets/design_course/banjir.jpg',
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isImageExpanded = true;
                                            selectedImagePath = category != null
                                                ? category!.imagePath
                                                : 'assets/design_course/banjir.jpg';
                                          });
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              fullscreenDialog: true,
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              pageBuilder: (_, __, ___) =>
                                                  _buildImageDetailPage(),
                                            ),
                                          );
                                        },
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: opacity1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: category != null
                                                  ? Image.network(
                                                      category!.imagePath,
                                                    )
                                                  : Image.asset(
                                                      'assets/design_course/banjir.jpg',
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, left: 8),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                        AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: DesignPetugasAppTheme.nearlyBlack,
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

  Widget getTimeBoxUI(String label, String value) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.27,
              color: DesignPetugasAppTheme.nearlyBPBD,
            ),
          ),
          Text(
            label,
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
    );
  }

  Widget _buildImageDetailPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            selectedImagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
