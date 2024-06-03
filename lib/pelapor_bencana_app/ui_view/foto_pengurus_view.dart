import 'package:flutter/material.dart';

class AreaListView extends StatefulWidget {
  const AreaListView({Key? key}) : super(key: key);

  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petugas BPBD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
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
            return FotoPengurusView(
              imagepath: areaListData[index],
              ketuaName: _getKetuaName(index),
              jabatan: _getJabatan(index),
            );
          },
        ),
      ),
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

class FotoPengurusView extends StatelessWidget {
  const FotoPengurusView({
    Key? key,
    this.imagepath,
    this.ketuaName,
    this.jabatan,
  }) : super(key: key);

  final String? imagepath;
  final String? ketuaName;
  final String? jabatan;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                imagepath ?? '',
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
    );
  }
}
