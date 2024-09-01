
import 'package:dgbitirme/screens/lists/diabetes_list.dart';
import 'package:dgbitirme/screens/predicts/predict_anemia.dart';
import 'package:dgbitirme/screens/predicts/predict_diabetes.dart';
import 'package:dgbitirme/screens/onboding/onboding_screen.dart';
import 'package:dgbitirme/screens/start/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../testtt.dart';
import 'home/home_page.dart';
import 'onboding/verify_email_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if(snapshot.connectionState == ConnectionState.waiting)
            {return Center(child: CircularProgressIndicator());}
          else if (snapshot.hasData) {
            return HomePage(); //HomePage()
          }
          else if(snapshot.hasError){
            return Center(child: Text('Bir şeyler yanlış gitti!'));
          }
          else {
            return StartPage(); //OnboardingScreen
          }
        },
      ),
    );
  }
}