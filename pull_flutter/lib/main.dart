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
          brightness: useDarkTheme ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.nunitoTextTheme(),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.purpleAccent, fontSize: 24),
              centerTitle: true),
          extensions: const [MatchCardsTheme()]),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }

  void _initHive(StateController<bool> hiveReady) async {
    await Hive.initFlutter();
    hiveReady.state = true;
  }
}
