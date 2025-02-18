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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCLZaRhJ-u1iogdtpsnEShLNyoZXO_jIoo',
    appId: '1:143345546135:web:8ec6dd0759d22e19f00ad2',
    messagingSenderId: '143345546135',
    projectId: 'rinlin-dceb1',
    authDomain: 'rinlin-dceb1.firebaseapp.com',
    storageBucket: 'rinlin-dceb1.appspot.com',
    measurementId: 'G-F73ZCPBLV3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFA1TI5-b-NYqjC0IPYQmpV8cJx9MbCrY',
    appId: '1:143345546135:android:cadcd9853a6ee7e9f00ad2',
    messagingSenderId: '143345546135',
    projectId: 'rinlin-dceb1',
    storageBucket: 'rinlin-dceb1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx9qSq69j6kxmtwQEaP2T8PYRgIShvsH0',
    appId: '1:143345546135:ios:6819047cc26f560ef00ad2',
    messagingSenderId: '143345546135',
    projectId: 'rinlin-dceb1',
    storageBucket: 'rinlin-dceb1.firebasestorage.app',
    androidClientId: '143345546135-gotnc2674jnglk3268j2jqead2fn9ii3.apps.googleusercontent.com',
    iosClientId: '143345546135-qndv92nia68fvcobum8fgv11m3lafeak.apps.googleusercontent.com',
    iosBundleId: 'com.app.rinlin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBx9qSq69j6kxmtwQEaP2T8PYRgIShvsH0',
    appId: '1:143345546135:ios:e039d572efe662e1f00ad2',
    messagingSenderId: '143345546135',
    projectId: 'rinlin-dceb1',
    storageBucket: 'rinlin-dceb1.appspot.com',
    iosClientId: '143345546135-48v5qgonch0uv1o8hj2lduiv7js83bie.apps.googleusercontent.com',
    iosBundleId: 'com.app.rinliln',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLZaRhJ-u1iogdtpsnEShLNyoZXO_jIoo',
    appId: '1:143345546135:web:f50f7917382e3c2ff00ad2',
    messagingSenderId: '143345546135',
    projectId: 'rinlin-dceb1',
    authDomain: 'rinlin-dceb1.firebaseapp.com',
    storageBucket: 'rinlin-dceb1.appspot.com',
    measurementId: 'G-6D3CELC675',
  );
}