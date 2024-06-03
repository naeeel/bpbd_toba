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
  late AnimationController animationController;
  List<String> areaListData = [
    'assets/pelaporan_app/gempa_mitigasi.jpg',
    'assets/pelaporan_app/banjir_mitigasi.jpg',
    'assets/pelaporan_app/longsor_mitigasi.jpg',
    'assets/pelaporan_app/kebakaran_mitigasi.jpg',
    'assets/pelaporan_app/angin_mitigasi.jpg',
    'assets/pelaporan_app/tsunami_mitigasi.jpg',
    'assets/pelaporan_app/erupsi_mitigasi.jpg',
  ];

  final List<String> descriptions = [
    'Langkah-langkah mitigasi gempa bumi: Memperkuat struktur bangunan, Mengidentifikasi dan mengamankan barang-barang yang dapat jatuh, Membuat rencana evakuasi darurat, Melakukan latihan evakuasi secara berkala, Meningkatkan edukasi dan kesadaran masyarakat, Memastikan kesiapan peralatan darurat, Mengembangkan sistem peringatan dini, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi banjir: Membangun sistem drainase yang baik, Menanam pohon dan tanaman untuk mengurangi limpasan air, Membersihkan saluran air secara rutin, Membuat tanggul dan waduk penahan air, Mengembangkan rencana evakuasi banjir, Meningkatkan edukasi dan kesadaran masyarakat tentang banjir, Menggunakan teknologi untuk pemantauan dan prediksi banjir, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi tanah longsor: Menanam vegetasi penahan tanah, Membuat terasering pada lahan miring, Memasang dinding penahan tanah, Meningkatkan drainase untuk mengurangi air tanah, Melakukan pemantauan area rawan longsor, Mengembangkan rencana evakuasi darurat, Meningkatkan edukasi dan kesadaran masyarakat tentang longsor, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi kebakaran: Membangun jalur evakuasi dan titik berkumpul yang aman, Memastikan adanya peralatan pemadam kebakaran yang cukup, Melakukan pelatihan pemadaman kebakaran secara berkala, Menyusun rencana evakuasi kebakaran, Memastikan bangunan memiliki sistem deteksi dan alarm kebakaran, Menanam tanaman yang tahan api di sekitar area rawan, Meningkatkan edukasi dan kesadaran masyarakat tentang kebakaran, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi badai: Memperkuat struktur bangunan dan atap, Mengamankan barang-barang yang dapat terbang atau jatuh, Menyusun rencana evakuasi badai, Melakukan latihan evakuasi secara berkala, Mengembangkan sistem peringatan dini badai, Menyiapkan peralatan darurat dan perlindungan diri, Meningkatkan edukasi dan kesadaran masyarakat tentang badai, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi tsunami: Memastikan adanya sistem peringatan dini tsunami, Membuat rencana evakuasi dan jalur aman menuju tempat tinggi, Melakukan latihan evakuasi secara berkala, Membangun infrastruktur penahan gelombang, Menyusun rencana tanggap darurat dan pemulihan, Meningkatkan edukasi dan kesadaran masyarakat tentang tsunami, Menggunakan teknologi untuk pemantauan dan prediksi tsunami, Bekerja sama dengan pihak terkait untuk respons cepat.',
    'Langkah-langkah mitigasi erupsi gunung berapi: Memantau aktivitas vulkanik secara terus-menerus, Mengembangkan rencana evakuasi darurat, Membuat pengaturan peringatan dini, Menyiapkan peralatan darurat, Melakukan pendidikan dan latihan masyarakat, Meningkatkan kerja sama dan koordinasi dengan pihak terkait, Mengembangkan rencana darurat dan pemulihan, Meningkatkan edukasi dan kesadaran masyarakat tentang bahaya vulkanik.',
  ];

  final List<String> titles = [
    'Mitigasi Gempa Bumi',
    'Mitigasi Banjir',
    'Mitigasi Tanah Longsor',
    'Mitigasi Kebakaran',
    'Mitigasi Badai',
    'Mitigasi Tsunami',
    'Mitigasi Erupsi Gunung Berapi',
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
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
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: areaListData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = areaListData.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: Interval(
                          (1 / count) * index,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    );
                    animationController.forward();

                    return AreaView(
                      imagePath: areaListData[index],
                      animation: animation,
                      animationController: animationController,
                      title: titles[index],
                      description: descriptions[index],
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
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

class AreaView extends StatelessWidget {
  const AreaView({
    Key? key,
    required this.imagePath,
    required this.animationController,
    required this.animation,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String imagePath;
  final AnimationController animationController;
  final Animation<double> animation;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation.value),
              0.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: PelaporansAppTheme.white,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: PelaporansAppTheme.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ParallaxPopup(
                            imagePath: imagePath,
                            title: title, 
                            description: description,
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(imagePath),
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

List<Widget> buildDescriptionList(String description) {
  List<String> steps = description.split(', ');

  return steps.map((step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '- ' + step,
        style: PelaporansAppTheme.body2,
      ),
    );
  }).toList();
}

class ParallaxPopup extends StatelessWidget {
  const ParallaxPopup({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: PelaporansAppTheme.white,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: PelaporansAppTheme.grey.withOpacity(0.4),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: PelaporansAppTheme.title,
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildDescriptionList(description),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
