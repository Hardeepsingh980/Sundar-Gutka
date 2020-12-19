import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/home.dart';
import 'package:sundargutka/hukam.dart';
import 'package:get/get.dart';
import 'bloc/home_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  return runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic('hukam');
    _firebaseMessaging.configure(
      onResume: (message) async {
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => HukamScreen()));
      },
      onLaunch: (message) async {
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (_) => HukamScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return BlocProvider(
      create: (context) => ThemeBloc()..add(ThemeInitialEvent()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeStateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ThemeStateLoaded) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: state.appSettings.darkTheme
                  ? ThemeData(
                      brightness: Brightness.dark, accentColor: Colors.orange)
                  : ThemeData(
                      brightness: Brightness.light,
                      primaryColor: Colors.black,
                      accentColor: Colors.orange),
              home: BlocProvider(
                create: (context) =>
                    HomeBloc(HomeStateLoading())..add(HomeEventLoading()),
                child: BaniListPage(),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
