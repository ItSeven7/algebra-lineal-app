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

  //await populateFirestore();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier(themeUser)),
      ChangeNotifierProvider(create: (_) => ContentProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

/// Optimización de Firestore completada :D ! (versión 2)
/// Hacer limpieza de código y hacer merge con el main (LISTO)
/// Subir al repositorio (versión 1.2.0) 03/11/2025
/// 
/// Siguiente:
///   Mejorar la UI
///   Representación más visual sobre lo que esta completado
///   Animaciones (para que no se sienta tan rigida la interfaz) y fluides