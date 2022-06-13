import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        color: Color.fromARGB(255, 193, 14, 124),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Cars',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 45.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                isRepeatingAnimation: true,

                                animatedTexts: [
                                  FadeAnimatedText('do it!',
                                      duration: Duration(seconds: 4)),
                                  FadeAnimatedText('do it right !!',
                                      duration: Duration(seconds: 4)),
                                  FadeAnimatedText('do it right \nNow !!!',
                                      duration: Duration(seconds: 4)),
                                ],
                                // onTap: () {
                                //   print("tap event");
                                // },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Colors.white,
                        ),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/ki-nilam.appspot.com/o/banner%2Fcar.gif?alt=media&token=555b83ac-6a6b-429b-b9ae-7ab38b632d32',
                          width: 102,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {},
                        style: NeumorphicStyle(color: Colors.white),
                        child: Text(
                          'Buy product',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {},
                        style: NeumorphicStyle(color: Colors.white),
                        child: Text(
                          'Sell product',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
