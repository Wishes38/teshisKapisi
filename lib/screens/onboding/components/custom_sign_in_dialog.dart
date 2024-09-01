import 'package:dgbitirme/screens/onboding/components/custom_sign_up_dialog.dart';
import 'package:dgbitirme/screens/onboding/components/sign_in_form.dart';
import 'package:dgbitirme/screens/onboding/components/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

import '../../forgot_pw_page.dart';
import '../onboding_screen.dart';


Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {



  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'Giriş Yap',
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
                      'Giriş Yap',
                      style: TextStyle(fontSize: 34, fontFamily: 'Poppins'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Üye oldun mu? o halde giriş yapmanın tam sırası!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SignInForm(),
/*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){},
                          child: Text(
                            'Üye Ol',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),*/

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'YA DA',
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Email, Apple ya da Google ile giriş yap',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /*
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/email_box.svg',
                              height: 64,
                              width: 64,
                            )),*/
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/apple-logo.svg',
                              height: 64,
                              width: 64,
                            )),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/google.svg',
                              height: 64,
                              width: 64,
                            )),
                      ],
                    )
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