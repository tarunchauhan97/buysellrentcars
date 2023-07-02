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
    apiKey: 'AIzaSyDNfZMnnohqEqHnhCu0_N4EO6fe81qEmlM',
    appId: '1:787230091620:web:27ec3b37e99c2021b73271',
    messagingSenderId: '787230091620',
    projectId: 'buysellrentcars',
    authDomain: 'buysellrentcars.firebaseapp.com',
    storageBucket: 'buysellrentcars.appspot.com',
    measurementId: 'G-T4MBE04MSB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABmcXjwVDOyc3zm2FiGVIEYAe64ZNXRys',
    appId: '1:787230091620:android:641b212ef1d26ed2b73271',
    messagingSenderId: '787230091620',
    projectId: 'buysellrentcars',
    storageBucket: 'buysellrentcars.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_mQH-S0cj-YapM2-qAJfZd_tnlW-zddE',
    appId: '1:787230091620:ios:42de94035bc141f1b73271',
    messagingSenderId: '787230091620',
    projectId: 'buysellrentcars',
    storageBucket: 'buysellrentcars.appspot.com',
    androidClientId: '787230091620-vbmpf52v6f183t293a8eq51s4nirn33e.apps.googleusercontent.com',
    iosClientId: '787230091620-67vp99t7id2niqj7kjig707qv6gdgtj6.apps.googleusercontent.com',
    iosBundleId: 'com.example.icarcodingCafe',
  );
}