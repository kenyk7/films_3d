import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              image: const NetworkImage(
                'https://picsum.photos/id/1002/400/800?blur',
              ),
            ),
          ),
          child: ListView(
            children: const [
              CarouselSection(),
              CarouselSection(),
              CarouselSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselSection extends StatefulWidget {
  const CarouselSection({Key? key}) : super(key: key);

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  late PageController _pageCtrl;
  AccelerometerEvent acceleration = AccelerometerEvent(0, 0, 0);
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  int personSensitivity = 2;
  int bgMotionSensitivity = 5;
  int _selectIndex = 1;

  @override
  void initState() {
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });
    _pageCtrl =
        PageController(initialPage: _selectIndex, viewportFraction: 0.75);
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      carouselView(0),
      carouselView(1),
      carouselView(2),
      carouselView(3),
    ];
    return SizedBox(
      height: 520,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
        controller: _pageCtrl,
        itemCount: pages.length,
        itemBuilder: (_, index) {
          return pages[index];
        },
      ),
    );
  }

  Widget carouselView(int index) {
    var _scale = _selectIndex == index ? 1.0 : 0.9;
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 350),
      tween: Tween(begin: _scale, end: _scale),
      curve: Curves.ease,
      child: cardFilm(),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }

  Widget cardFilm() {
    const deep = 60;
    return Center(
      child: SizedBox(
        height: 520,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    top: (acceleration.z * bgMotionSensitivity) - deep,
                    bottom: (acceleration.z * -bgMotionSensitivity) - deep,
                    right: (acceleration.x * -bgMotionSensitivity) - deep,
                    left: (acceleration.x * bgMotionSensitivity) - deep,
                    child: Image.network(
                      'https://i.imgur.com/9JWuT3k.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    // top: acceleration.z * personSensitivity,
                    bottom: acceleration.z * -personSensitivity,
                    right: acceleration.x * -personSensitivity,
                    left: acceleration.x * personSensitivity,
                    child: Image.network('https://i.imgur.com/P6Kwdk7.png'),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    left: acceleration.x * -personSensitivity + 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'IROMAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Row(
                          children: const <Widget>[
                            Text(
                              '5.0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
