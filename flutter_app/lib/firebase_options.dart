import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQAzpAZF2_zKCr3feD-I15QWX2l5mwtdM',
    appId: '1:768816005670:web:d8f9986bd43911d5941ce7',
    messagingSenderId: '768816005670',
    projectId: 'apps-factory-da98e',
    authDomain: 'apps-factory-da98e.firebaseapp.com',
    storageBucket: 'apps-factory-da98e.firebasestorage.app',
  );

  // Usa la config web como fallback para plataformas no configuradas aún
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQAzpAZF2_zKCr3feD-I15QWX2l5mwtdM',
    appId: '1:768816005670:web:d8f9986bd43911d5941ce7',
    messagingSenderId: '768816005670',
    projectId: 'apps-factory-da98e',
    storageBucket: 'apps-factory-da98e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQAzpAZF2_zKCr3feD-I15QWX2l5mwtdM',
    appId: '1:768816005670:web:d8f9986bd43911d5941ce7',
    messagingSenderId: '768816005670',
    projectId: 'apps-factory-da98e',
    storageBucket: 'apps-factory-da98e.firebasestorage.app',
    iosBundleId: 'com.example.moodmapapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQAzpAZF2_zKCr3feD-I15QWX2l5mwtdM',
    appId: '1:768816005670:web:d8f9986bd43911d5941ce7',
    messagingSenderId: '768816005670',
    projectId: 'apps-factory-da98e',
    authDomain: 'apps-factory-da98e.firebaseapp.com',
    storageBucket: 'apps-factory-da98e.firebasestorage.app',
  );
}
