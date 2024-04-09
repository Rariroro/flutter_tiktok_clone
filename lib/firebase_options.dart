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
    apiKey: 'AIzaSyDwe_RGrnO5OK6zrxgeEP9pAwTs10_iqWU',
    appId: '1:422698628195:web:e52d5521f570f193887456',
    messagingSenderId: '422698628195',
    projectId: 'tiktok-clone-eunga0110',
    authDomain: 'tiktok-clone-eunga0110.firebaseapp.com',
    storageBucket: 'tiktok-clone-eunga0110.appspot.com',
    measurementId: 'G-KHBFMD43RQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWBxctq7618NQrNDWoHh9xjyl9XbRcfYM',
    appId: '1:422698628195:android:56634bc1f04bfbc3887456',
    messagingSenderId: '422698628195',
    projectId: 'tiktok-clone-eunga0110',
    storageBucket: 'tiktok-clone-eunga0110.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrsSMWxYnr28yzjKfkLmnAINu_pJzb3V0',
    appId: '1:422698628195:ios:b9405d1c0f3a6f5f887456',
    messagingSenderId: '422698628195',
    projectId: 'tiktok-clone-eunga0110',
    storageBucket: 'tiktok-clone-eunga0110.appspot.com',
    iosBundleId: 'com.example.flutterTiktokClone',
  );
}