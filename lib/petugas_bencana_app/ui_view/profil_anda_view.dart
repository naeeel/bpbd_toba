import 'package:flutter/material.dart';
import '../pelaporan_bencana_app_theme.dart';

class WorkoutView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const WorkoutView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  TextEditingController nameController = TextEditingController(text: 'Lyra');
  TextEditingController accountController = TextEditingController(text: 'Nyoba');
  TextEditingController birthDateController = TextEditingController(text: '10 November 2089');

  bool isEditing = false;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF729FFF),
                    hexToColor("#87CEEB")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PelaporansAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildTextField('Nama : ', nameController),
                      SizedBox(height: 16),
                      buildTextField('No Telp : ', accountController),
                      SizedBox(height: 16),
                      buildTextField('Tanggal Lahir : ', birthDateController),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: Text(isEditing ? 'Simpan' : 'Edit'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: PelaporansAppTheme.fontName,
            fontWeight: FontWeight.normal,
            fontSize: 20,
            letterSpacing: 0.0,
            color: PelaporansAppTheme.white,
            decoration: TextDecoration.none,
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(
            color: PelaporansAppTheme.white,
            decoration: TextDecoration.none,
          ),
          enabled: isEditing,
        ),
      ],
    );
  }
}
