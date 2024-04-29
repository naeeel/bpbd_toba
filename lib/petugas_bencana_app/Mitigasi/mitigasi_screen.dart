import 'package:pelaporan_bencana/petugas_bencana_app/ui_view/title_view.dart';
import 'package:flutter/material.dart';

import '../pelaporan_bencana_app_theme.dart';

class MitigasiScreen extends StatefulWidget {
  const MitigasiScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _MitigasiScreenState createState() => _MitigasiScreenState();
}

class _MitigasiScreenState extends State<MitigasiScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Mitigasi',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/gempa.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromRGBO(139, 69, 19, 1),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Color.fromRGBO(139, 69, 19, 1),
                    child: Center(
                      child: Text(
                        'Gempa Bumi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Gempa Bumi:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Tetap tenang dan jangan panik.\n'
                    '2. Segera cari tempat yang aman, seperti di bawah meja atau tempat yang kuat.\n'
                    '3. Hindari area dengan banyak benda yang bisa jatuh.\n'
                    '4. Jangan berada di dekat jendela atau pintu kaca.\n'
                    '5. Setelah gempa berhenti, tetap waspada terhadap gempa susulan.\n'
                    '6. Ikuti informasi dari otoritas setempat dan siapkan diri untuk evakuasi jika diperlukan.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/fload.png'),
                      fit: BoxFit.cover,
                    ),
                    color: const Color.fromARGB(255, 52, 125, 250),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color.fromARGB(255, 52, 125, 250),
                    child: Center(
                      child: Text(
                        'Banjir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Banjir:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Segera pindahkan barang berharga ke tempat yang aman dan tinggi.\n'
                    '2. Hindari berjalan atau berenang di area yang tergenang.\n'
                    '3. Jangan memasuki area yang terendam penuh tanpa peralatan keselamatan.\n'
                    '4. Jangan berenang di arus banjir yang kuat.\n'
                    '5. Ikuti instruksi dari otoritas setempat dan siapkan diri untuk evakuasi.\n'
                    '6. Jika berada di dalam rumah saat banjir, pindah ke lantai yang lebih tinggi.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );


    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/api.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 231, 11, 33),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Color.fromARGB(255, 231, 11, 33),
                    child: Center(
                      child: Text(
                        'Kebakaran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Kebakaran:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Segera hubungi pemadam kebakaran melalui nomor darurat.\n'
                    '2. Jangan panik, tetap tenang dan evaluasi situasi dengan cepat.\n'
                    '3. Jika kebakaran kecil, gunakan alat pemadam yang sesuai untuk memadamkannya.\n'
                    '4. Jika berada di dalam bangunan yang terbakar, segera keluar dan hindari asap.\n'
                    '5. Tutup pintu dan jendela untuk mencegah penyebaran api.\n'
                    '6. Jangan kembali ke dalam bangunan yang terbakar sampai dinyatakan aman oleh otoritas.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );


    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/longsor.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 44, 26, 26),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Color.fromARGB(255, 44, 26, 26),
                    child: Center(
                      child: Text(
                        'Tanah Longsor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Tanah Longsor:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Segera meninggalkan area yang rawan tanah longsor.\n'
                    '2. Jangan mengendarai kendaraan di area yang berpotensi longsor.\n'
                    '3. Jika berada di dalam rumah, pindah ke area yang lebih tinggi.\n'
                    '4. Hindari daerah aliran sungai dan pantai selama periode hujan lebat.\n'
                    '5. Pantau informasi cuaca dan peringatan dari otoritas setempat.\n'
                    '6. Hindari melakukan aktivitas yang bisa mengganggu struktur tanah, seperti penggalian.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/gunung.png'),
                      fit: BoxFit.cover,
                    ),
                    color: const Color.fromARGB(255, 189, 15, 15),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color.fromARGB(255, 189, 15, 15),
                    child: Center(
                      child: Text(
                        'Gunung Merapi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Menghadapi Erupsi Gunung Merapi:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Ikuti informasi dan peringatan dari BMKG dan otoritas setempat.\n'
                    '2. Jangan mendekati kawasan yang dilarang oleh otoritas.\n'
                    '3. Siapkan masker untuk melindungi saluran pernapasan dari abu vulkanik.\n'
                    '4. Sediakan persediaan makanan dan air minum yang cukup.\n'
                    '5. Hindari mengendarai kendaraan di area yang terkena dampak erupsi.\n'
                    '6. Bersiap untuk evakuasi jika diperintahkan oleh otoritas.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/topann.gif'),
                      fit: BoxFit.cover,
                    ),
                    color: const Color.fromARGB(255, 122, 187, 239),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color.fromARGB(255, 122, 187, 239),
                    child: Center(
                      child: Text(
                        'Angin Topan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Angin Topan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Segera cari tempat yang aman, seperti bangunan kokoh atau tempat perlindungan lainnya.\n'
                    '2. Hindari berada di luar ruangan atau dekat dengan pohon dan struktur yang bisa roboh.\n'
                    '3. Jauhi pantai dan area pesisir selama peringatan topan berlaku.\n'
                    '4. Pantau informasi cuaca dan peringatan dari otoritas setempat.\n'
                    '5. Siapkan peralatan darurat dan persediaan makanan serta air yang cukup.\n'
                    '6. Jangan keluar dari tempat perlindungan sampai dinyatakan aman oleh otoritas.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );



    listViews.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pelaporan_app/tsunami2.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 1, 163, 238),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Color.fromARGB(255, 1, 163, 238),
                    child: Center(
                      child: Text(
                        'Tsunami',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Cara Mengatasi Tsunami:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Segera pindahkan diri ke tempat yang lebih tinggi dan jauh dari pantai.\n'
                    '2. Hindari berada di daerah pesisir atau pantai selama peringatan tsunami berlaku.\n'
                    '3. Ikuti instruksi dan peringatan dari otoritas setempat.\n'
                    '4. Jangan mencoba untuk melihat atau merekam tsunami, tetapi segera cari tempat perlindungan.\n'
                    '5. Siapkan tas darurat yang berisi kebutuhan dasar seperti makanan, air, obat-obatan, dan pakaian.\n'
                    '6. Jangan kembali ke daerah yang terdampak tsunami sampai dinyatakan aman oleh otoritas.\n',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PelaporansAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                  'BPBD',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: PelaporansAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: Color(0xFFF28920),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
