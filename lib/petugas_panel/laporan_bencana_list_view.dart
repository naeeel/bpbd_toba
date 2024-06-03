import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pelaporan_bencana/petugas_panel/design_petugas_app_theme.dart';
import 'package:pelaporan_bencana/petugas_panel/models/Category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelaporan_bencana/main.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_info_screen.dart';

class LaporanBencanaListView extends StatefulWidget {
  const LaporanBencanaListView({Key? key, this.callBack}) : super(key: key);

  final Function(Category)? callBack;

  @override
  _LaporanBencanaListViewState createState() => _LaporanBencanaListViewState();
}

class _LaporanBencanaListViewState extends State<LaporanBencanaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void moveTo(Category category) {
    String locationString =
        "${category.location.latitude}, ${category.location.longitude}";
    String formattedTimestamp =
        DateFormat('dd MMM yyyy, hh:mm a').format(category.timestamp.toDate());

    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LaporanInfoScreen(
          id: category.id,
          description: category.description,
          disasterType: category.disasterType,
          imageUrl: category.imageUrl,
          location: locationString,
          timestamp: formattedTimestamp,
          userId: category.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 30),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return StreamBuilder<List<Category>>(
              stream: CategoryService().getCategoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                } else {
                  List<Category> categories = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 32.0,
                      crossAxisSpacing: 32.0,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval(
                            (1 / categories.length) * index,
                            1.0,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      );
                      animationController?.forward();

                      return CategoryView(
                        callback: () => moveTo(categories[index]),
                        category: categories[index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    Key? key,
    required this.category,
    required this.animationController,
    required this.animation,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final Category category;
  final AnimationController animationController;
  final Animation<double> animation;

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

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
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    child: Text(
                                      category.disasterType,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: DesignPetugasAppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 16, right: 16, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          formatDate(category.timestamp),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 12,
                                            letterSpacing: 0.27,
                                            color: DesignPetugasAppTheme.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color:
                                    DesignPetugasAppTheme.grey.withOpacity(0.2),
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.network(
                                category.imageUrl,
                                fit: BoxFit.cover,
                              ),
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
        );
      },
    );
  }
}
