import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors/sensors.dart';

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
      home: const MyHomePage(title: 'My 3d Films'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // PageController _pageController = PageController();
  AccelerometerEvent acceleration = AccelerometerEvent(0, 0, 0);
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  int planetMotionSensitivity = 2;
  int bgMotionSensitivity = 5;

  @override
  void initState() {
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black12,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
            image: const NetworkImage(
              'https://i.imgur.com/9JWuT3k.jpg',
            ),
          ),
        ),
        child: PageView(
          // controller: _pageController,
          children: <Widget>[
            cardFilm(),
            cardFilm(),
          ],
        ),
      ),
    );
  }

  Widget cardFilm() {
    const deep = 60;
    return Center(
      child: SizedBox(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    // top: acceleration.z * planetMotionSensitivity,
                    bottom: acceleration.z * -planetMotionSensitivity,
                    right: acceleration.x * -planetMotionSensitivity,
                    left: acceleration.x * planetMotionSensitivity,
                    child: Image.network('https://i.imgur.com/P6Kwdk7.png'),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Iroman',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: const <Widget>[
                            Text(
                              '5.0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
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
