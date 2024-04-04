// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyATrDr1EyDtAv23qS0wHJJ599m5bXMVY_0',
    appId: '1:383268732137:web:7a183b28ab98dbab374478',
    messagingSenderId: '383268732137',
    projectId: 'immunotheraphytracker',
    authDomain: 'immunotheraphytracker.firebaseapp.com',
    storageBucket: 'immunotheraphytracker.appspot.com',
    measurementId: 'G-25FKH0LLE2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAi1J-X5Uq_ECmOFGunluT4lGnaFWTBGpQ',
    appId: '1:383268732137:android:3a97a8f29663bf54374478',
    messagingSenderId: '383268732137',
    projectId: 'immunotheraphytracker',
    storageBucket: 'immunotheraphytracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYZkW0BUEIrZeM0Phmu2hytaV2rxov1ao',
    appId: '1:383268732137:ios:5ece3000d011f819374478',
    messagingSenderId: '383268732137',
    projectId: 'immunotheraphytracker',
    storageBucket: 'immunotheraphytracker.appspot.com',
    iosBundleId: 'com.comp491.immunotheraphyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYZkW0BUEIrZeM0Phmu2hytaV2rxov1ao',
    appId: '1:383268732137:ios:e5eb16679488acf5374478',
    messagingSenderId: '383268732137',
    projectId: 'immunotheraphytracker',
    storageBucket: 'immunotheraphytracker.appspot.com',
    iosBundleId: 'com.example.immunotheraphyApp.RunnerTests',
  );
}