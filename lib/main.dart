import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gl1/dashboard.dart';
import 'package:gl1/init.dart';
import 'package:gl1/installApp.dart';
import 'package:gl1/login.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(
    ChangeNotifierProvider(
      create: (context) => StateController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مطعم الأرض الخضراء',
      navigatorKey: navigatorKey,
      locale: Locale('ar', ''),
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'bukraBold', // Set your custom font here
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'bukraBold',
            fontSize: 14,
          ),
          // You can define other text styles as needed
          bodyMedium: TextStyle(
            fontFamily: 'bukraBold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontFamily: 'bukraBold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'bukraBold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'مطعم الارض الخضراء'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool isInstallPromptAvailable() {
  return js.context.callMethod('isInstallPromptAvailable') as bool;
}

void checkInit() {
  final requestserver = Requestserver();
  if (!requestserver.isInit()) {
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => InitPage()),
      (Route<dynamic> route) => false,
    );
  } else {
    if (requestserver.isLogined()) {
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => DashboardPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  void delayedFunction() async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await Future.delayed(const Duration(seconds: 3)); // Delay for 2 seconds
      if (isInstallPromptAvailable()) {
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => InstallAppPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        checkInit();
      }
    } else {
      final Uri uri = Uri.parse(
          "https://play.google.com/store/apps/details?id=com.yemen_restaurant.greenland");

      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        Navigator.of(navigatorKey.currentContext!)
            .popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    delayedFunction();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboard.JPG'),
            fit: BoxFit.cover, // This will cover the whole screen
          ),
        ),
        child: const Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column()),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
