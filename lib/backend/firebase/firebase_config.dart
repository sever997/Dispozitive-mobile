import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD_o9BcrmbX9ZBKb_jr3NDTMyw0Fo-RHsk",
            authDomain: "student-resource-hub-24hvca.firebaseapp.com",
            projectId: "student-resource-hub-24hvca",
            storageBucket: "student-resource-hub-24hvca.firebasestorage.app",
            messagingSenderId: "726616670078",
            appId: "1:726616670078:web:0801e1e6b5b20ab441fd2f"));
  } else {
    await Firebase.initializeApp();
  }
}
