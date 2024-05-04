import 'package:flutter/material.dart';
import 'design_petugas_app_theme.dart';

class LaporanInfoScreen extends StatefulWidget {
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

  bool isImageExpanded = false;
  String selectedImagePath = '';

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
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
                    child: Image.asset(
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
                              'Bencana\nBanjir',
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
                                  '28 Mei 2024', // Ubah string ini sesuai dengan tanggal yang ingin ditampilkan
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

                                        // Icon(
                                        //   _approvalStatus == ApprovalStatus.waiting
                                        //       ? Icons.hourglass_bottom // Ikon menunggu persetujuan
                                        //       : _approvalStatus == ApprovalStatus.approved
                                        //           ? Icons.check_circle // Ikon disetujui
                                        //           : Icons.cancel, // Ikon ditolak
                                        //   color: _approvalStatus == ApprovalStatus.waiting
                                        //       ? DesignPetugasAppTheme.nearlyBPBD
                                        //       : _approvalStatus == ApprovalStatus.approved
                                        //           ? Colors.green
                                        //           : Colors.red,
                                        //   size: 24,
                                        // ),
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
                                  getTimeBoxUI('Lyra', 'Lyra'),
                                  getTimeBoxUI('Lokasi', 'Balige'),
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
        padding: const EdgeInsets.only(left: 16.0), // Tambahkan jarak di sini
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  isImageExpanded = true;
                  selectedImagePath = 'assets/design_course/banjir.jpg';
                });
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    fullscreenDialog: true,
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => _buildImageDetailPage(),
                  ),
                );
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: opacity1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/design_course/banjir.jpg',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8), // Tambahkan jarak antara gambar pertama dan kedua
            GestureDetector(
              onTap: () {
                setState(() {
                  isImageExpanded = true;
                  selectedImagePath = 'assets/design_course/banjir.jpg';
                });
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    fullscreenDialog: true,
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => _buildImageDetailPage(),
                  ),
                );
              },
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: opacity1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
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

                          SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Text(
                                    ' Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum..',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                      letterSpacing: 0.27,
                                      color: DesignPetugasAppTheme.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
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
                                            color: DesignPetugasAppTheme.grey
                                                .withOpacity(0.2)),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: DesignPetugasAppTheme.nearlyBPBD,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: DesignPetugasAppTheme.nearlyBPBD,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: DesignPetugasAppTheme
                                                  .nearlyBPBD
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'apa apa je la',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: DesignPetugasAppTheme
                                                .nearlyWhite,
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
            ),
           Positioned(
  top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
  right: 35,
  child: Row(
    children: [
      Card(
        color: DesignPetugasAppTheme.nearlyBPBD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 10.0,
        child: Container(
          width: 60,
          height: 60,
          child: Center(
            child: Icon(
              Icons.close, // Ikon menolak
              color: DesignPetugasAppTheme.nearlyWhite,
              size: 30,
            ),
          ),
        ),
      ),
      SizedBox(width: 10), // Jarak antara kedua ikon
      Card(
        color: Colors.green, // Warna untuk ikon disetujui
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 10.0,
        child: Container(
          width: 60,
          height: 60,
          child: Center(
            child: Icon(
              Icons.check, // Ikon disetujui
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    ],
  ),
),

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
  Widget getTimeBoxUI(String text1, String txt2) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
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
Widget _buildImageDetailPage() {
  return Scaffold(
    body: GestureDetector(
      onTap: () {
        Navigator.pop(context); // Kembali ke layar sebelumnya jika latar belakang ditekan
      },
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), // Latar belakang transparan dengan opasitas 0.5
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Container(
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  selectedImagePath,
                  fit: BoxFit.cover,
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
