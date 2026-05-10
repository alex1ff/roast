import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC33j_eEWs87CyrQBO9ZlRQi4QSmqKKrdg",
            authDomain: "roast-nutri-tracker-7c67ct.firebaseapp.com",
            projectId: "roast-nutri-tracker-7c67ct",
            storageBucket: "roast-nutri-tracker-7c67ct.firebasestorage.app",
            messagingSenderId: "705916310047",
            appId: "1:705916310047:web:116b92d2dd801c3e277b2a"));
  } else {
    await Firebase.initializeApp();
  }
}
