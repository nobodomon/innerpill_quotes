import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class SaveQuote extends StatefulWidget {
  final String content;
  final String id;
  SaveQuote({this.content, this.id});
  _SaveQuoteState createState() => _SaveQuoteState();
}

class _SaveQuoteState extends State<SaveQuote> {
  @override
  void initState() {
    super.initState();
  }

  List<Gradient> gradientlist = [
    Gradients.hotLinear,
    Gradients.jShine,
    Gradients.aliHussien,
    Gradients.rainbowBlue,
    Gradients.ali,
    Gradients.cosmicFusion,
    Gradients.backToFuture,
    Gradients.blush,
    Gradients.byDesign,
    Gradients.coldLinear,
    Gradients.haze,
    Gradients.hersheys,
    Gradients.tameer,
    Gradients.taitanum,
    Gradients.deepSpace,
  ];
  int selectedGradient = 0;

  Uint8List _imageFile;
  Color fixedColor = Colors.white;
  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Screenshot(
          controller: controller,
          child: Scaffold(
            body: Center(
                child: Container(
              decoration:
                  BoxDecoration(gradient: gradientlist[selectedGradient]),
              child: Center(
                  child: Text(
                widget.content,
                maxLines: 3,
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.5, 2.5),
                      ),
                    ],
                    fontFamily: 'GrestralScript',
                    fontSize: 24,
                    color: fixedColor),
              )),
            )),
          )),
      Stack(children: [
        Positioned(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.black54,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      previousBg();
                    },
                    child: Icon(
                      Icons.navigate_before,
                    )),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.black54,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      _imageFile = null;
                      controller
                          .capture(
                              pixelRatio: 5.1,
                              delay: Duration(milliseconds: 10))
                          .then((Uint8List image) async {
                        //print("Capture Done");
                        setState(() {
                          _imageFile = image;
                        });
                        final result = await ImageGallerySaver.saveImage(
                            image); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
                        print("File Saved to Gallery");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Image Saved to Gallery")));
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    child: Icon(
                      Icons.save,
                    )),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.black54,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      nextBg();
                    },
                    child: Icon(
                      Icons.navigate_next,
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 50,
                )
              ],
            ),
          ]),
        ),
      ])
    ]);
  }

  void previousBg() {
    setState(() {
      if (selectedGradient == 0) {
        selectedGradient = gradientlist.length - 1;
        print(selectedGradient);
      } else {
        selectedGradient--;
        if (selectedGradient == 10) {
          fixedColor = Colors.black;
        } else {
          fixedColor = Colors.white;
        }
        print(selectedGradient);
      }
    });
  }

  void nextBg() {
    setState(() {
      if (selectedGradient == gradientlist.length - 1) {
        selectedGradient = 0;
      } else {
        selectedGradient++;
        if (selectedGradient == 10) {
          fixedColor = Colors.black;
        } else {
          fixedColor = Colors.white;
        }
      }
    });
  }
}
