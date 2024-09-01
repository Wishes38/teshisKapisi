import 'dart:async';

import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'onboding_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  int remainingSeconds=100;

  late Timer _verificationTimer;

/*
  _startVerificationTimer() {
    const duration = Duration(seconds: 100);
    _verificationTimer = Timer(duration, () {
      // Süre dolunca bu kısım çalışacak
      _cancelVerificationAndNavigate();
    });
  }*/
  void _startVerificationTimer() {
    const duration = Duration(seconds: 1);
    _verificationTimer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (remainingSeconds < 1) {
          timer.cancel();
          _cancelVerificationAndNavigate();
        } else {
          remainingSeconds--;
        }
      });
    });
  }

  void _cancelVerificationAndNavigate() {


    FirebaseAuth.instance.signOut();
    _verificationTimer.cancel();
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
  }

  @override
  void initState() {
    super.initState();
    try {
      if(user!=null){
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

        if (!isEmailVerified) {
          sendVerificationEmail();

          _startVerificationTimer();
          timer = Timer.periodic(
            Duration(seconds: 3),
                (_) => checkEmailVerified(),
          );
        }
      }

    }
    on Exception catch(ex){
      print(ex);
    }
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseAuth.instance.currentUser!.reload();

      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmailVerified) {
        timer?.cancel();
        _verificationTimer.cancel();
      }
    }else{
      timer?.cancel();
      _verificationTimer.cancel();
      Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

    } catch (e) {
      showErrorMessage(e.toString());
    }
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
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(title: Text('Email Doğrulama Sayfası')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kalan Süre: $remainingSeconds saniye',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  'Doğrulama kodu gönderildi!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  icon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: Text(
                    'Yeniden Gönder',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text('İptal Et', style: TextStyle(fontSize: 24),),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        );
}
