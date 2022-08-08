import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_common/match_cards.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/model/routes.dart';
import 'package:pull_flutter/model/settings.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ProviderScope(
    overrides: [matchStreamRefreshOverride],
    child: PullApp(),
  ));
}

class PullApp extends ConsumerWidget {
  PullApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(routes: appRoutes);


  void getConcurrentMatchLimit() async {
    print("got into getConcurrentMatchLimit");
    var url = concurrentMatchLimitUri;
    var decoded;
    try {
      var response = await http.get(url).timeout(const Duration(seconds: 3));
      if(response.statusCode == 200){
        print("Success");
        decoded = json.decode(response.body);
        print("attemping to set hive with concurrent match limit.");

        //TODO send this to hive.

        var box = await Hive.openBox(kSettingsBox);
        box.put('concurrentMatchLimit',decoded['limit']);
        var printout = box.get('concurrentMatchLimit');
        print("match limit: ${printout}");
      }else{
        print("Something's wrong");
      }
    } on TimeoutException catch (e) {
      print('Timeout');
      Fluttertoast.showToast(
          msg: "You're having connectivity issues, please check connection and reset your app.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //TODO make a call to the database to get the max number of concurrent matches, save it in hive.


    final useDarkTheme = ref.watch(useDarkThemeProvider);
    final hiveReady = ref.watch(hiveReadyProvider);
    if (!hiveReady) {
      _initHive(ref.read(hiveReadyProvider.state));
    }

    getConcurrentMatchLimit();

    return MaterialApp.router(
      title: 'Pull',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          background: Colors.white,
          brightness: Brightness.light,
          error: Colors.red,
          onBackground: Colors.black,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          primary: Colors.lightBlueAccent,
          secondary: Colors.pinkAccent,
          surface: Colors.grey,
        ),
        brightness: useDarkTheme ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.nunitoTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: Colors.lightBlueAccent,
            shape: const StadiumBorder(),
          ),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
                fontSize: 24),
            centerTitle: true),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Color(0xff383838),
        ),
        radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith(
                    (states) => Colors.lightBlueAccent)
        ),
        extensions: [
          MatchCardsTheme(
              swipeRightColor: Colors.deepPurple,
              swipeLeftColor: Colors.pinkAccent.shade200,
              rewindColor: Colors.blueGrey.shade700)
        ]),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }

  void _initHive(StateController<bool> hiveReady) async {
    await Hive.initFlutter();
    //(await Hive.openBox(kSettingsBox)).delete(kSettingsApiToken);
    hiveReady.state = true;
  }

}
