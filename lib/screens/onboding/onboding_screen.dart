import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'package:lorem_ipsum/lorem_ipsum.dart';

import 'components/animated_btn.dart';
import 'components/custom_sign_in_dialog.dart';
import 'components/custom_sign_up_dialog.dart';

String loremText1 = loremIpsum(words: 60, paragraphs: 1);
String loremText2 = loremIpsum(words: 30, paragraphs: 1);
String loremText3 = loremIpsum(words: 10, paragraphs: 1);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  bool isSignUpDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
/*
                Positioned(
                    width: MediaQuery.of(context).size.width * 1.7,
                    bottom: 200,
                    left: -350,
                    child: Image.asset('assets/Backgrounds/wp.png')),*/
                Positioned.fill(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                )),
                const RiveAnimation.asset(
                    'assets/RiveAssets/onboard_animation.riv'),
                Positioned.fill(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: const SizedBox(),
                )),
                AnimatedPositioned(
                  top: isSignInDialogShown ? -50 : 0,
                  duration: const Duration(milliseconds: 240),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //const Spacer(),
                          const SizedBox(
                              height: 10), //Spacer yerine kullanıldı.

                          SizedBox(
                            width: 270,
                            child: Column(
                              children: [
                                Text(
                                  'Teşhis Kapısı',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontFamily: 'Poppins',
                                    height: 1.2,
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Makine öğrenmesi ile geliştirilmiş olan teşhis modellerimizi denemeye hazır mısın?\n"
                                  "\nHenüz üye olmadıysan üye ol butonuna basabilirsin.\n"
                                      "\nEğer üyeysen, Ne duruyorsun?\n",
                                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                                ), //loremText1
                              ],
                            ),
                          ),

                          //const Spacer(flex: 2),
                          const SizedBox(height: 10), //Spacer yerine kullanıldı

                          //Haydi Başlayalım Butonu
                          AnimatedBtn(
                            btnAnimationController: _btnAnimationController,
                            press: () {
                              _btnAnimationController.isActive = true;
                              /* Future.delayed(
                                Duration(milliseconds: 800),
                              );*/
                              setState(() {
                                isSignInDialogShown = true;
                              });

                              customSigninDialog(context, onClosed: (_) {
                                setState(() {
                                  isSignInDialogShown = false;
                                });
                              });
                            },
                            customText: 'Haydi Başlayalım',
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 120), //24
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Varsayılan olarak siyah renk
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Created by ",
                                  ),
                                  TextSpan(
                                    text: "Serkan Özdemir",
                                    style: TextStyle(color: Colors.blue), // Serkan Özdemir için kırmızı renk
                                  ),
                                  TextSpan(
                                    text: "\nInspired by the idea of ",
                                  ),
                                  TextSpan(
                                    text: "Dr. Öğr. Üyesi ",
                                    style: TextStyle(color: Colors.orange), // Kıyas Kayaalp için kırmızı renk
                                  ),
                                  TextSpan(
                                    text: "Kıyas Kayaalp",
                                    style: TextStyle(color: Colors.red), // Kıyas Kayaalp için kırmızı renk
                                  ),
                                ],
                              ),
                            )

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  left: 5,
                  top: isSignInDialogShown ? -50 : -19,
                  duration: const Duration(milliseconds: 240),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Üye Ol Butonu
                          AnimatedBtn(
                            btnAnimationController: _btnAnimationController,
                            press: () {
                              _btnAnimationController.isActive = true;
                              /* Future.delayed(
                                Duration(milliseconds: 800),
                              );*/
                              setState(() {
                                isSignUpDialogShown = true;
                              });

                              customSignupDialog(context, onClosed: (_) {
                                setState(() {
                                  isSignUpDialogShown = false;
                                });
                              });
                            },
                            customText: 'Üye Ol',
                            customWidth: 185,
                            customHeight: 40,

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
