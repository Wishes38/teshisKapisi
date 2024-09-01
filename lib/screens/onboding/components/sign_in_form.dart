import 'dart:async';

import 'package:dgbitirme/screens/onboding/verify_email_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

import '../../forgot_pw_page.dart';
import '../../home/home_page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isEmailVerified = false;
  Timer? timer;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    return controller;
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
/*
  void signUserIn() async {

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage('Lütfen geçerli bir e-posta ve şifre girin.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }*/

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    Future.delayed(Duration(seconds: 1), () async {
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          check.fire();
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();

            Future.delayed(Duration(milliseconds: 1200), () async {
              await FirebaseAuth.instance.currentUser!.reload();

              setState(() {
                isEmailVerified =
                    FirebaseAuth.instance.currentUser!.emailVerified;
              });

              if (isEmailVerified) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
              if (!isEmailVerified) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VerifyEmailPage()));
              }

              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            });
//serkan@gmail.com
          });
        } on FirebaseAuthException catch (e) {
          error.fire();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
          });
        }

        //her şey yolundaysa
      } else {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (email) {},
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset(
                        'assets/icons/email.svg',
                        width: 24, // Adjust the width to your desired size
                        height: 24, // Adjust the height to your desired size
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                'Şifre',
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (password) {},
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset('assets/icons/password.svg'),
                  )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordPage();
                      }));
                    },
                    child: Text(
                      'Parolamı Unuttum',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                    onPressed: () {
                      signIn(context);
                      //signUserIn();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueGrey, //0xFFF77D8E , Color(0xFFF77D30)
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ))),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white, //Color(0xFFFE0030)
                    ),
                    label: Text(
                      'Giriş Yap',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          ),
                    )),
              )
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger;
                    error = controller.findSMI("Error") as SMITrigger;
                    reset = controller.findSMI("Reset") as SMITrigger;
                  },
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 7,
                child: RiveAnimation.asset(
                  'assets/RiveAssets/confetti.riv',
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);

                    confetti =
                        controller.findSMI('Trigger explosion') as SMITrigger;
                  },
                ),
              ))
            : SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Column(
      children: [
        Spacer(),
        SizedBox(
          height: size,
          width: size,
          child: child,
        ),
        Spacer(
          flex: 2,
        )
      ],
    ));
  }
}
