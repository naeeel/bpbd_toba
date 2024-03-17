import 'package:pelaporan_bencana/petugas_bencana_app/pelaporan_bencana_app_home_screen.dart';
import 'package:pelaporan_bencana/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: IntroductionAnimationScreen(),
    ),
   
    HomeList(
      imagePath: 'assets/introduction_animation/logo.png',
      navigateScreen: PelaporansAppHomeScreen(),
    ),
    
  ];
}
