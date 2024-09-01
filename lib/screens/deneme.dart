import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DenemView extends StatefulWidget {
  const DenemView({super.key});

  @override
  State<DenemView> createState() => _DenemViewState();
}

class _DenemViewState extends State<DenemView> {
  Future<void> signUp() async {
    print('methoda girdi');
    await FirebaseFirestore.instance.collection('users').doc().set({
      "email": "babaemre32@gmail.com",
      "password": "baba3264"
    });

    print('methottan cikti');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Center(child: FloatingActionButton(onPressed: signUp,child: Text('Sign Up Bro'),)),);
  }
}
