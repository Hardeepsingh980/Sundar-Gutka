
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/firebase_options.dart';
import 'package:sundargutka/home.dart';
import 'package:sundargutka/hukam.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'bloc/home_bloc.dart';
import 'bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  return runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    super.initState();
    // _firebaseMessaging.subscribeToTopic('hukam');
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => HukamScreen()));
    });
    FirebaseMessaging.onMessage.listen((message) async {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => HukamScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return BlocProvider(
      create: (context) => ThemeBloc()..add(ThemeInitialEvent()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeStateLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ThemeStateLoaded) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: state.appSettings.darkTheme ? Colors.grey.shade900 : Colors.white,
                colorScheme: ColorScheme.fromSwatch(
                  brightness: state.appSettings.darkTheme ? Brightness.dark : Brightness.light,
                ).copyWith(primary: Colors.orange, secondary: Colors.orange),
                brightness: state.appSettings.darkTheme ? Brightness.dark : Brightness.light,
              ),
              home: BlocProvider(
                create: (context) =>
                    HomeBloc()..add(HomeEventLoading()),
                child: BaniListPage(),
              ),
            );
          }
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
