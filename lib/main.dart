import 'app.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_user_service.dart';
import 'providers/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeUser = await UserService().obtenerTemaDesdeFirestore();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(themeUser),
      child: const MyApp(),
    ),
  );
}