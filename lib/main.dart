import 'package:e_commerce/cubit/general_cubit.dart';
import 'package:e_commerce/view/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_router.dart';
import 'bloc_observer.dart';
import 'common/app_style.dart';


void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(appRouter: AppRouter()),
    
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);
  AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneralCubit>(
      create: (context) => GeneralCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: myWhite,
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            inputDecorationTheme: inputDecorationTheme(),
            fontFamily: 'Muli',
            scaffoldBackgroundColor: const Color(0xFFE7E9F5),
            // primaryColor: const Color(0xFF283C63),
            iconTheme: IconThemeData(color: Colors.black.withOpacity(0.4))),
        // home:  HomePage(),
        onGenerateRoute: appRouter.generateRoute,
        // home: const HomeScreen(),
      ),
    );
  }
}
