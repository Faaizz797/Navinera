import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:itinerary_generator_with_gemini_ai/firebase_options.dart';
import 'package:itinerary_generator_with_gemini_ai/screen/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(DevicePreview(
    enabled: true, 
    builder: (context) => const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, 
      locale: DevicePreview.locale(context), 
      builder: DevicePreview.appBuilder, 
      home: const HomeScreen(),
    );
  }
}



// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:itinerary_generator_with_gemini_ai/firebase_options.dart';
// import 'package:itinerary_generator_with_gemini_ai/screen/home/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Tambahin ini biar bisa pakai async
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // Pastikan pakai FirebaseOptions yang bener
//   );
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }
