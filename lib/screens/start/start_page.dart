import 'package:dgbitirme/screens/onboding/components/animated_btn.dart';
import 'package:dgbitirme/screens/onboding/onboding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          // assets/images/mobileAI.png
          padding:
              const EdgeInsets.only(top: 30.0, left: 10, right: 10, bottom: 5),
          child: Column(
            children: [
              Image(image: AssetImage("assets/images/mobileAI.png")),
              Text(
                "Sağlıkta Yapay Zeka",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 40,
                endIndent: 25,
                indent: 25,
              ),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  "İnsanlar için olmazsa olmaz olan sağlık, gelişen teknoloji"
                  " ve ortaya çıkan yeni yapay zeka modelleri ile her geçen gün ileriye taşınmaktadır."
                  " Yapay zekanın bir alt dalı olan makine öğrenmesi kullanılarak geliştirilen bu uygulama,"
                  " teşhis koyulabilmesi için doktorlara yardımcı olacak.",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.bottomRight,
                child: AnimatedBtn(
                  btnAnimationController: _btnAnimationController,
                  press: () {
                    _btnAnimationController!.isActive = true;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingScreen()));
                  },
                  customText: 'İleri',
                  customWidth: 100,
                  customHeight: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
