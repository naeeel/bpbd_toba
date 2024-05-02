import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_theme.dart';
import 'package:flutter/material.dart';


class BodyMeasurementView extends StatelessWidget  {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const BodyMeasurementView({Key? key, this.animationController, this.animation})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
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
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 8, top: 16),
                            child: Text(
                              'Kategori: Sedang',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: PelaporansAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: PelaporansAppTheme.darkText),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      'BANJIR',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: PelaporansAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                       color: PelaporansAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'Ringan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: PelaporansAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                       color: PelaporansAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: PelaporansAppTheme.grey
                                            .withOpacity(0.5),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Today 8:26 AM',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                PelaporansAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: PelaporansAppTheme.grey
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
                                        fontFamily: PelaporansAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                       color: PelaporansAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                
                                ],
                              )
                              
                            ],
                            
                          )
                        ],
                      ),
                    ),
                      Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: PelaporansAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0), // Sesuaikan dengan nilai yang diinginkan
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(4, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0), // Sesuaikan dengan nilai yang diinginkan
                          child: Image.asset(
                            'assets/pelaporan_app/banjir.jpg', // Sesuaikan dengan path gambar Anda
                            width: 350, // Sesuaikan dengan lebar yang diinginkan
                            height: 200, // Sesuaikan dengan tinggi yang diinginkan
                            fit: BoxFit.cover, // Sesuaikan dengan kebutuhan tata letak gambar
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
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '10 Org',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: PelaporansAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: PelaporansAppTheme.darkText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Korban',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: PelaporansAppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                          PelaporansAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'lyra',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: PelaporansAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: PelaporansAppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Pelapor',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: PelaporansAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: PelaporansAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                        'Selesai',
                                        style: TextStyle(
                                          fontFamily: PelaporansAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.2,
                                          color: Colors.green, // Mengganti warna menjadi hijau
                                        ),
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Status',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: PelaporansAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: PelaporansAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 14, left: 16, right: 16,), // Sesuaikan dengan kebutuhan padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            SizedBox(height: 8), // Sesuaikan dengan kebutuhan spasi antara teks dan deskripsi
                            Text(
                              'Gempa bumi tektonik dengan magnitudo 5,0 mengguncang Kabupaten Toba, Sumatera Utara pada Sabtu pukul 15.46 WIB. Kepala Pusat Gempa Bumi dan Tsunami BMKG, Bambang Setiyo Prayitno, dalam keterangan tertulisnya yang diterima di Sibolga, Sabtu, menyebutkan dengan memperhatikan lokasi episenter dan kedalaman hiposenternya, gempa bumi yang terjadi merupakan jenis menengah akibat dari aktivitas subduksi. Lokasi gempa berada pada koordinat 2.43 LU dan 98.96 BT, atau tepatnya berlokasi di darat pada jarak 11 km arah Barat Laut kota Balige, ibukota Kabupaten Toba, Sumatera Utara, pada kedalaman 137 km.',
                               // Jumlah baris maksimum sebelum "Read More"
                              style: TextStyle(
                                fontFamily: PelaporansAppTheme.fontName,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                letterSpacing: 0.0,
                                color: PelaporansAppTheme.grey.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

