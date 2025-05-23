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
    apiKey: 'AIzaSyAeoPnDrsKX-V-uFjWbrIcCdoF_QsNFiGg',
    appId: '1:753044783566:web:5b6e06f8b6824f7df36b9f',
    messagingSenderId: '753044783566',
    projectId: 'kashinfo-58bb5',
    authDomain: 'kashinfo-58bb5.firebaseapp.com',
    storageBucket: 'kashinfo-58bb5.firebasestorage.app',
    measurementId: 'G-VJ5WE261TE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7cTis9IEeS9YNNYDfR_ugmi_QuZKQdaE',
    appId: '1:753044783566:android:010c0f2ca463217bf36b9f',
    messagingSenderId: '753044783566',
    projectId: 'kashinfo-58bb5',
    storageBucket: 'kashinfo-58bb5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuskXeDbR30KulTbrHVIPj53-c-4Bu_3E',
    appId: '1:753044783566:ios:f1dff183bdcd3bd6f36b9f',
    messagingSenderId: '753044783566',
    projectId: 'kashinfo-58bb5',
    storageBucket: 'kashinfo-58bb5.firebasestorage.app',
    iosBundleId: 'com.example.kashinfo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuskXeDbR30KulTbrHVIPj53-c-4Bu_3E',
    appId: '1:753044783566:ios:f1dff183bdcd3bd6f36b9f',
    messagingSenderId: '753044783566',
    projectId: 'kashinfo-58bb5',
    storageBucket: 'kashinfo-58bb5.firebasestorage.app',
    iosBundleId: 'com.example.kashinfo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAeoPnDrsKX-V-uFjWbrIcCdoF_QsNFiGg',
    appId: '1:753044783566:web:957a69442027645df36b9f',
    messagingSenderId: '753044783566',
    projectId: 'kashinfo-58bb5',
    authDomain: 'kashinfo-58bb5.firebaseapp.com',
    storageBucket: 'kashinfo-58bb5.firebasestorage.app',
    measurementId: 'G-LQ38JKBWKW',
  );
}
