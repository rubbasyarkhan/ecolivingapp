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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAt65LyKMLlF9ueo1nL4C0QonBRd0V1xXw',
    appId: '1:282251096910:web:314fee1bd3f145803fe41f',
    messagingSenderId: '282251096910',
    projectId: 'eco-living-app-b9db9',
    authDomain: 'eco-living-app-b9db9.firebaseapp.com',
    storageBucket: 'eco-living-app-b9db9.firebasestorage.app',
    measurementId: 'G-1YHPD2YH9E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnIk9IGzQJl3YRSLRwUnk72_tQCD2A-4k',
    appId: '1:282251096910:android:e1c3ed7fceea7fad3fe41f',
    messagingSenderId: '282251096910',
    projectId: 'eco-living-app-b9db9',
    storageBucket: 'eco-living-app-b9db9.firebasestorage.app',
  );
}
