import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/common/app_style.dart';
import 'package:e_commerce/common/constants.dart';
import 'package:e_commerce/common/size_config.dart';
import 'package:e_commerce/common/widgets.dart';
import 'package:e_commerce/view/screens/details_card_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectIndex = 0;

  Artboard? _riverArtboard;
  SMIInput<double>? _progress;
  StateMachineController? controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load("assets/images/liquid_download.riv").then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      controller = StateMachineController.fromArtboard(artboard, 'Guido SM');
      if (controller != null) {
        artboard.addController(controller!);
        _progress = controller!.findInput('input');
        setState(() => _riverArtboard = artboard);
      }
    });
  }

  RiveAnimationController<dynamic>? riveAnimationController;
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/images/1873.jpg',
      'assets/images/1874.jpg',
    ];

    List<Widget> widgetOptions = <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getResponsiveScreenWidth(4),
        ),
        child: Column(
          children: [
            buildHeightSpace(10),
            header(),
            buildHeightSpace(5),
            sliderSection(images),
            buildHeightSpace(5),
            Container(
              color: Colors.red,
              height: 100,
              width: 100,
              child: const Center(
                child: RiveAnimation.asset(
                  'assets/images/liquid_download.riv',
                  artboard: 'Guido SM',

                  // alignment: Alignment.center,
                  // artboard: _riverArtboard!,
                ),
              ),
            ),
            buildHeightSpace(5),
            Expanded(
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: getResponsiveScreenWidth(5)),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 15,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsCardScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: Colors.amber,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          'assets/images/ps-store-credit-image-block-01-en-21oct21.jpg',
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      DetailsCardScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
        itemCount: widgetOptions.length,
        itemBuilder: (context, index) {
          return widgetOptions.elementAt(index);
        },
      ),
      backgroundColor: const Color(0xFFE7E9F5),
      // backgroundColor: Colors.white,

      // bottomNavigationBar: const BottomNavBar(),

      // _widgetOptions.elementAt(_selectIndex)
    );
  }

  CarouselSlider sliderSection(List<String> images) {
    return CarouselSlider.builder(
      itemCount: 2,
      itemBuilder: (context, i, intPageView) {
        return Container(
          height: getResponsiveScreenHeight(10),
          // width: getResponsiveScreenWidth(80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            images[i],
            fit: BoxFit.cover,
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(
          milliseconds: 800,
        ),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 3.0,
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: getResponsiveScreenHeight(5.0),
          width: getResponsiveScreenWidth(60),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.hardEdge,
          child: TextField(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsetsDirectional.all(getResponsiveScreenWidth(3.0)),
              hintText: 'Search Products',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: kPrimaryColor,
              ),
            ),
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _progress!.value++;
          },
          child: Container(
            height: getResponsiveScreenHeight(5),
            width: getResponsiveScreenWidth(10.7),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.all(getResponsiveScreenWidth(0.9)),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/cart_icon.svg',
                color: const Color.fromARGB(255, 247, 250, 255),
                width: 27,
                // alignment: Alignment.center,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          // borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              Container(
                height: getResponsiveScreenHeight(5),
                width: getResponsiveScreenWidth(10.7),
                padding: EdgeInsets.all(getResponsiveScreenWidth(2.2)),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  'assets/images/Bill_icon.svg',
                  color: const Color.fromARGB(255, 247, 250, 255),
                  // theme: SvgTheme(),
                  width: 10,
                ),
              ),
              Positioned(
                bottom: 29,
                top: 0,
                left: 29,
                right: 0,
                child: Container(
                  height: getResponsiveScreenHeight(2),
                  width: getResponsiveScreenWidth(2),
                  // margin: EdgeInsets.fromLTRB(getResponsiveScreenWidth(2),
                  //     getResponsiveScreenHeight(0.2), 0, 0),
                  decoration: const BoxDecoration(
                      color: iconColor2, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(displayWidth * .05),
      height: displayWidth * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              currentIndex = index;
              HapticFeedback.lightImpact();
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .32
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: index == currentIndex ? displayWidth * .12 : 0,
                  width: index == currentIndex ? displayWidth * .32 : 0,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? Colors.grey.withOpacity(.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .31
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == currentIndex ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == currentIndex ? listOfStrings[index] : '',
                              style: TextStyle(
                                color: Colors.purple[800],
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width:
                              index == currentIndex ? displayWidth * .03 : 20,
                        ),
                        Icon(
                          listOfIcons[index],
                          size: displayWidth * .076,
                          color: index == currentIndex
                              ? Colors.blueGrey
                              : Colors.black26,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Faviorate',
    'Settings',
    'Account',
  ];
}
