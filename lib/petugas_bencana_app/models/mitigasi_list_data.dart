class MitigasiListData {
  MitigasiListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.mitigasi,
    this.arahan = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? mitigasi;
  int arahan;

  static List<MitigasiListData> tabIconsList = <MitigasiListData>[
    MitigasiListData(
      imagePath: 'assets/pelaporan_app/volcano.png',
      titleTxt: 'Gempa',
      mitigasi: <String>['Gempa bumi ','dan lain lain'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MitigasiListData(
      imagePath: 'assets/pelaporan_app/cyclone.png',
      titleTxt: 'Badai',
      mitigasi: <String>['Puting beliung'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MitigasiListData(
      imagePath: 'assets/pelaporan_app/volcano.png',
      titleTxt: 'Gunung',
      mitigasi: <String>['Gunung erupsi'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    MitigasiListData(
      imagePath: 'assets/pelaporan_app/waterfall.png',
      titleTxt: 'Banjir',
      mitigasi: <String>['Recommend:', ''],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
