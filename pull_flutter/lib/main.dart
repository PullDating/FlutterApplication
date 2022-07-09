import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_common/match_cards.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/model/routes.dart';
import 'package:pull_flutter/model/settings.dart';

void main() {
  runApp(ProviderScope(
    overrides: [matchStreamRefreshOverride],
    child: PullApp(),
  ));
}

class PullApp extends ConsumerWidget {
  PullApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(routes: appRoutes);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useDarkTheme = ref.watch(useDarkThemeProvider);
    final hiveReady = ref.watch(hiveReadyProvider);
    if (!hiveReady) {
      _initHive(ref.read(hiveReadyProvider.state));
    }

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
    hiveReady.state = true;
  }
}
