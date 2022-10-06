
import 'package:e_commerce/view/screens/complete_profile/complete_profile_screen.dart';
import 'package:e_commerce/view/screens/forget_password/forget_password_screen.dart';
import 'package:e_commerce/view/screens/home_screen.dart';
import 'package:e_commerce/view/screens/on_boarding/onBoarding_screen.dart';
import 'package:e_commerce/view/screens/otp/otp_screen.dart';
import 'package:e_commerce/view/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce/view/screens/sign_up/sign_up_screen.dart';
import 'package:e_commerce/view/screens/starting/starting_screen.dart';
import 'package:flutter/material.dart';

import 'view/screens/details_card_screen.dart';


class AppRouter {
  Route? generateRoute(RouteSettings screen) {
    switch (screen.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen());
      case 'HomeScreen':
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case 'SignInScreen':
        return MaterialPageRoute(builder: (context) => const SignInScreen());

      case 'ForgetPasswordScreen':
        return MaterialPageRoute(
            builder: (context) => const ForgetPasswordScreen());

      case 'SignUpScreen':
        return MaterialPageRoute(builder: (context) => const SignUpScreen());

      case 'CompleteProfile':
        return MaterialPageRoute(builder: (context) => const CompleteProfile());

      case 'OtpScreen':
        return MaterialPageRoute(builder: (context) => const OtpScreen());

      case 'StartingScreen':
        return MaterialPageRoute(builder: (context) => const StartingScreen());
      
      case 'DetailsCardScreen':
        return MaterialPageRoute(builder: (context) =>  DetailsCardScreen());
      
     
    }
    return null;
  }
}
