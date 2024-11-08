// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfDwCeVf7xUKWJoN9tkUA3L0FSor0l2JA',
    appId: '1:2995162908:web:9b12b8eb0772e639bfb4d9',
    messagingSenderId: '2995162908',
    projectId: 'sundar-gutka-7175a',
    authDomain: 'sundar-gutka-7175a.firebaseapp.com',
    storageBucket: 'sundar-gutka-7175a.firebasestorage.app',
    measurementId: 'G-5GX7QB3D3P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY9QaOh5XO_rvl25Nl_zcq6Ni-abvZ3ms',
    appId: '1:2995162908:android:ce9c889866d1cdeebfb4d9',
    messagingSenderId: '2995162908',
    projectId: 'sundar-gutka-7175a',
    storageBucket: 'sundar-gutka-7175a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHIHjqjGA-ePK6FtD2ArzF4KoePikdRcQ',
    appId: '1:2995162908:ios:8973dee13e0292f6bfb4d9',
    messagingSenderId: '2995162908',
    projectId: 'sundar-gutka-7175a',
    storageBucket: 'sundar-gutka-7175a.firebasestorage.app',
    iosClientId: '2995162908-qqvpaufuj0qj1tp7uo0draet6es1qqns.apps.googleusercontent.com',
    iosBundleId: 'com.hardeep.sundargutka',
  );
}
