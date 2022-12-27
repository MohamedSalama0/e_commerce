// ignore_for_file: unnecessary_string_escapes

import 'package:e_commerce/common/size_config.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';

class SignUpBackground extends StatelessWidget {
  final Widget? child;
  const SignUpBackground({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        // alignment: Alignment.center,
        children: [
          Indexer(
            children: [
              Positioned(
                  top: getResponsiveScreenHeight(-2.3),
                  left: getResponsiveScreenWidth(-7),
                  // top: getResponsiveScreenHeight(-2.3),
                  // left: getResponsiveScreenWidth(-7),
                  child: SizedBox(
                      width: getResponsiveScreenWidth(45),
                      child: Image.asset(
                        'assets/images/signup_top.png',
                        color: Colors.white.withOpacity(0.9),
                        colorBlendMode: BlendMode.modulate,
                      ))),
              Indexed(
                index: 9,
                child: Positioned(
                  bottom: -16,
                  left: -8,
                  child: SizedBox(
                    width: getResponsiveScreenWidth(25),
                    child: Image.asset(
                      "assets/images/main_bottom.png",
                      color: const Color.fromARGB(255, 101, 153, 142)
                          .withOpacity(0.7),
                      // color: Colors.lightBlue.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Indexed(
                index: 11,
                child: child!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
