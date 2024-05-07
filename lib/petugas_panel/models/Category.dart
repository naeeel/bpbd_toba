import 'dart:ffi';

class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.description ='jangan dong aku juga ingin pakwkawokoawkkawkoawkoakwoawkoakwowkaoawkoawk',
    this.jmlhbencana = 0,
    this.tanggal = '',
    this.peringatandini = 0,
    // tambahi kalo memang ada yg kurang ini di panggil di card yang nge geser ke samping
  });

  String title;
  int jmlhbencana;
  String description;
  String tanggal;
  String imagePath;
  int peringatandini;
// kode di bawah ini ciri dari card card yang nge geser ke samping
  static List<Category> CategoryList = <Category>[
    Category(
      imagePath: 'assets/design_course/aw.jpg',
      title: 'Ada bencana Bicalk',
      tanggal: ''
    ),
    Category(
      imagePath: 'assets/design_course/aw.jpg',
      title: 'Ada bencana banjir',
      peringatandini: 12,
    ),
    Category(
      imagePath: 'assets/design_course/aw.jpg',
      title: 'Au ah males',
      jmlhbencana: 24,
    ),
    Category(
      imagePath: 'assets/design_course/aw.jpg',
      title: 'YNTKS',
      jmlhbencana: 22,
    ),
  ];

// kalo ini yang paling bawah ini nanti kalo di pencet gempa /box gempa yng muncul ini (laporan bencana)
  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'assets/design_course/banjir.jpg',
      title: 'Gabut doang',
      jmlhbencana: 12,
    ),
    Category(
      imagePath: 'assets/design_course/image.png',
      title: 'Berak',
      jmlhbencana: 28,
    ),
    Category(
      imagePath: 'assets/design_course/image.png',
      title: 'No ingpo',
      jmlhbencana: 12,
    ),
    Category(
      imagePath: 'assets/design_course/image.png',
      title: 'Gatau',
      jmlhbencana: 28,
    ),
  ];
}
