import 'package:kalbemd/blesscom/pages/login_new.dart';
import 'package:kalbemd/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your applxication.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: const SplashScreen(),
              theme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                primarySwatch: Colors.blue,
              ),
            );
          } else {
            return MaterialApp(
              title: 'Aplikasi Kalbe MD',
              // theme: ThemeData(
              //   textTheme: GoogleFonts.poppinsTextTheme(),
              //   primarySwatch: Colors.blue,
              //   cardTheme: const CardTheme(
              //     clipBehavior: Clip.antiAlias,
              //     elevation: 10,
              //     shadowColor: Colors.white54,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(8),
              //       ),
              //     ),
              //   ),
              // ),
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: GoogleFonts.poppins().fontFamily,
                primaryColor: Colors.orange,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.orange,
                  brightness: Brightness.dark,
                  accentColor: Colors.orange,
                ),
                cardTheme: const CardTheme(
                  clipBehavior: Clip.antiAlias,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.orange,
                ),
                tabBarTheme: const TabBarTheme(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.white,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                ),
                checkboxTheme: CheckboxThemeData(
                  checkColor: MaterialStateProperty.all(Colors.white),
                  fillColor: MaterialStateProperty.all(Colors.orange),
                ),
              ),
              home: const LoginNew(),
            );
          }
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<String> initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 1));

    return "WOOOOW";
  }
}
