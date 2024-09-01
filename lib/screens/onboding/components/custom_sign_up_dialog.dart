import 'package:dgbitirme/screens/onboding/components/sign_in_form.dart';
import 'package:dgbitirme/screens/onboding/components/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../forgot_pw_page.dart';
import '../onboding_screen.dart';

Future<Object?> customSignupDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'Kayıt Ol',
    context: context,
    transitionDuration: const Duration(milliseconds: 650),
    transitionBuilder: (_, animation, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 660,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const Text(
                      'Kayıt Ol',
                      style: TextStyle(fontSize: 34, fontFamily: 'Poppins'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Halen Üye Olmadın Mı? Hemen Aramıza Katıl!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SignUpForm(),

                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 615,
                  //bottom: -48,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  ).then(onClosed);
}