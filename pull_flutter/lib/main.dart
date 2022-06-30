import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_common/match_cards.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/model/routes.dart';
import 'package:pull_flutter/model/settings.dart';

//firebase material
import 'package:firebase_core/firebase_core.dart';
import 'package:pull_flutter/ui/notificationbadge.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pull_common/src/model/entity/pushnotification.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  //not sure if this is the right place for this, see below.
  /*
  //need to initialize the firebase application.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   */

  runApp(ProviderScope(
    overrides: [matchStreamRefreshOverride],
    child: PullApp(),
  ));
}

//top level widget class in the application.
class PullApp extends ConsumerStatefulWidget {
  const PullApp({Key? key}) : super(key: key);

  @override
  ConsumerState<PullApp> createState() => _PullAppState();
}

class _PullAppState extends ConsumerState<PullApp> {
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;

  final GoRouter _router = GoRouter(routes: appRoutes);

  @override
  void initState() {
    _totalNotifications = 0;

    registerNotification();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        //TODO update riverpods with the notification information.
        _totalNotifications++;
      });
    });

    checkForInitialMessage();

    super.initState();
  }

  //for detecting notifications
  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. Get the FCM token (required to uniquely identify the device for cloud messaging.
    _messaging.getToken().then((token){
      //TODO should this be put in a riverpods state variable somehow?
      print(token);
    });

    //4. Configure Background messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        //TODO implement riverpods state to tell that there is a new notification.

        setState(() {
          _totalNotifications++;
          print(notification.toString());
        });

        if(notification != null){
          showSimpleNotification(
            Text(notification!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(notification!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }

      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
  //for when the app is terminated and the user is brought back by the click of the notification.
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _totalNotifications++;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final useDarkTheme = ref.watch(useDarkThemeProvider);
    final hiveReady = ref.watch(hiveReadyProvider);
    if (!hiveReady) {
      _initHive(ref.read(hiveReadyProvider.state));
    }

    return OverlaySupport(
      child: MaterialApp.router(
        title: 'Pull',
        theme: ThemeData(
            radioTheme: RadioThemeData(
                fillColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent)
            ),
            brightness: useDarkTheme ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.deepPurple,
            textTheme: GoogleFonts.nunitoTextTheme(),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                    fontSize: 24),
                centerTitle: true),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.lightBlueAccent,
              unselectedItemColor: const Color(0xff383838),
            ),
            extensions: [
              MatchCardsTheme(
                  swipeRightColor: Colors.deepPurple,
                  swipeLeftColor: Colors.pinkAccent.shade200,
                  rewindColor: Colors.blueGrey.shade700)
            ]),
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

  void _initHive(StateController<bool> hiveReady) async {
    await Hive.initFlutter();
    hiveReady.state = true;
  }
}


/*
class PullApp extends ConsumerWidget {
  PullApp({Key? key}) : super(key: key);

  late final FirebaseMessaging _messaging;
  late int _totalNotifications;


  final GoRouter _router = GoRouter(routes: appRoutes);

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        //TODO implement riverpods state to tell that there is a new notification.
        /*
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

         */
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

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
          radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent)
          ),
          brightness: useDarkTheme ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.nunitoTextTheme(),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 24),
              centerTitle: true),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.lightBlueAccent,
            unselectedItemColor: const Color(0xff383838),
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

 */
