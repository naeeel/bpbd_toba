import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pelaporan_bencana/petugas_panel/design_petugas_app_theme.dart';
import 'package:pelaporan_bencana/petugas_panel/models/Category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelaporan_bencana/main.dart';
import 'package:pelaporan_bencana/petugas_panel/laporan_info_screen.dart';

class LaporanTerbaruListView extends StatefulWidget {
  const LaporanTerbaruListView({Key? key, this.callBack}) : super(key: key);

  final Function(Category)? callBack;

  @override
  _LaporanTerbaruListViewState createState() => _LaporanTerbaruListViewState();
}

class _LaporanTerbaruListViewState extends State<LaporanTerbaruListView>
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
    // Assuming category.location is a GeoPoint
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
          location: locationString, // Pass the converted string here
          timestamp: formattedTimestamp, // Pass the formatted timestamp here
          userId: category.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child: StreamBuilder<List<Category>>(
          stream: CategoryService().getCategoriesStream(),
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
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

              // Urutkan categories berdasarkan timestamp
              categories.sort((a, b) => b.timestamp.compareTo(a.timestamp));

              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  right: 16,
                  left: 16,
                ),
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                  categories.length > 10? 10 : categories.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval(
                        (1 / count) * index,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  );
                  animationController?.forward();

                  return CategoryView(
                    category: categories[index],
                    animation: animation,
                    animationController: animationController,
                    callback: () => moveTo(categories[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    Key? key,
    this.category,
    this.animationController,
    this.animation,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              100 * (1.0 - animation!.value),
              0.0,
              0.0,
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.12),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 14,
                                            ),
                                            child: Text(
                                              category!.disasterType,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: DesignPetugasAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              category!.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color:
                                                DesignPetugasAppTheme.grey,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              formatDate(category!.timestamp),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color:
                                                DesignPetugasAppTheme.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          bottom: 24,
                          left: 16,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(
                              category!.imageUrl,
                              fit: BoxFit.cover,
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
