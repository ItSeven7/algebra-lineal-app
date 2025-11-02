import 'app.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/content_provider.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';
import 'services/firebase_user_service.dart';
import 'firebase_options.dart';

//import 'scripts/populate_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeUser = await UserService().obtenerTemaDesdeFirestore();

  final userProvider = UserProvider();
  await userProvider.refresh();

  //await populateFirestore();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier(themeUser)),
      ChangeNotifierProvider(create: (_) => ContentProvider()),
      ChangeNotifierProvider(create: (_) => userProvider),
    ],
    child: const MyApp(),
  ));
}
