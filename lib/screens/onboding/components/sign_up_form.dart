import 'dart:async';

import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:dgbitirme/screens/onboding/components/sign_in_form.dart';
import 'package:dgbitirme/screens/onboding/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isEmailVerified = false;
  Timer? timer;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

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
/*
  Future<void> sign() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set({"email": "emre@gmail.com", "password": "1231234"});
    print('SİGNNNNN');
  }*/

  Future<AlertDialog?> signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            /*child: CircularProgressIndicator(
            color: Colors.green,
          ),*/
            );
      },
    );
    try {
      print('try a girdi');
      if (passwordController.text == passwordConfirmController.text && passwordController.text != "" &&
          passwordConfirmController.text!="" && emailController.text !="") {
        print('password ve email boş geçilmedi');

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        await FirebaseAuth.instance.currentUser!.reload();
/*
        await FirebaseFirestore.instance.collection("Users").doc().set({
          //userCredential.user!.email
          'username': emailController.text.split('@')[0],
          'bio': 'empty bio',
        });*/

        await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
          'username': emailController.text.split('@')[0],
          'bio': 'empty bio',
        });

        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
        print('email kontroll');
        if (isEmailVerified) {
          /*
          FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.email)
              .set({
            'username': emailController.text.split('@')[0],
            'bio': 'empty bio',
          });

          print('collection\'a eklemeye çalıştı');
          await FirebaseFirestore.instance.collection("Users").doc().set({
            //userCredential.user!.email
            'username': emailController.text.split('@')[0],
            'bio': 'empty bio',
          });
          print('HOMEPAGEE GONDER');
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));*/
        }
        // /////////////////////////

        print('try BİTTİ');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Parolalar Eşleşmedi!"),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
      print('FİrebaseAuthException Yakalandı');
    } finally {}
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

              const Text(
                'Şifre Onayla',
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: passwordConfirmController,
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
                        'assets/icons/password.svg',
                        width: 24, // Adjust the width to your desired size
                        height: 24, // Adjust the height to your desired size
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton.icon(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey, //0xFFF77D8E
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
                    label: const Text('Kayıt Ol', style: TextStyle(color: Colors.white, fontSize: 15),)),
              ),

              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Seni Aramızda Görmeyi \nHeyecanla Bekliyoruz!',
                      style: TextStyle(color: Colors.black26),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              //Expanded(child: Divider()),
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
