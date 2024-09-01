import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatefulWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.press,
    required this.customText,
    this.customWidth = 210.0,
    this.customHeight = 58.0,
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;
  final String customText;
  final double customWidth;
  final double customHeight;
  @override
  _AnimatedBtnState createState() => _AnimatedBtnState();
}

class _AnimatedBtnState extends State<AnimatedBtn> {
  bool isPressed = false;

  Widget _buildText() {
    return Text(
      widget.customText, // Kullanıcının belirlediği metni kullan
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: isPressed ? Colors.blue : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startAnimation();
        widget.press();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isPressed
            ? widget.customWidth
            : widget.customWidth + 10, // customWidth kullan
        height: isPressed ? widget.customHeight : widget.customHeight + 8,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0), // Köşeleri yuvarlama
          ),
          child: Stack(
            children: [
              Positioned.fill(
                //top: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    _buildText()
                    /*
                    Text(
                      ,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isPressed ? Colors.orange : Colors.black,
                      ),
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startAnimation() {
    setState(() {
      isPressed = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          isPressed = false;
        });
      });
      widget._btnAnimationController.isActive = true;
    });
  }
}
