import 'package:aplication_algebra_lineal/screens/quiz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_gate.dart';
import './screens/settings.dart';
import './screens/about.dart';
import './screens/account.dart';
import './screens/progress.dart';
import './screens/topics.dart';
import './screens/units.dart';

import './providers/theme_provider.dart';
import './colecciones/cursos.dart';
import './screens/subtopic.dart';
import './models/color_themes.dart';
import './models/text_styles.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          title: 'AlGeneal',
          theme: buildTheme(themeNotifier.currentTheme),
          home: const AuthGate(),
          routes: {
            '/settings': (context) => const SettingsPage(),
            '/about': (context) => const AboutPage(),
            '/account': (context) => const AccountScreen(),
            '/progress': (context) => const ProgressScreen(),
            '/units': (context) =>
                UnitScreen(cursoId: '', nombreCurso: '', unidades: []),
            '/topics': (context) => TopicScreen(
                cursoId: '',
                unidadId: '',
                nombreUnidad: '',
                numeroUnidad: 0,
                temas: []),
            '/subtopic': (context) => SubtopicScreen(
                index: 0,
                cursoId: '',
                unidadId: '',
                temaId: '',
                numeroTema: 0,
                nombreTema: '',
                subtema: SubTema(titulo: '', contenido: '')),
            '/quiz': (context) => QuizScreen(nombreUnidad: ''),
          },
        );
      },
    );
  }
}

ThemeData buildTheme(AppColorTheme theme) {
  final primary =
      appThemeColors[theme]!; // Accede directamente al color desde el mapa

  return ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: ColorsUI.backgroundColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color.fromRGBO(63, 63, 63, 1.0)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      titleTextStyle: AppTextStyles.subHeader,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primary,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 26),
        selectedItemColor: ColorsUI.selectedIcon,
        unselectedItemColor: ColorsUI.unSelectedIcon),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: ColorsUI.backgroundColor,
      ),
    ),
    cardTheme: const CardTheme(color: ColorsUI.backgroundColor, elevation: 2),
    listTileTheme: const ListTileThemeData(
        titleTextStyle: AppTextStyles.cardTitle,
        subtitleTextStyle: AppTextStyles.cardSubtitle,
        leadingAndTrailingTextStyle: AppTextStyles.cardTrailing),
    expansionTileTheme:
        ExpansionTileThemeData(textColor: AppTextStyles.bodyBlack.color),
    dialogTheme: const DialogTheme(
        titleTextStyle: AppTextStyles.titleBlackDialog,
        contentTextStyle: AppTextStyles.bodyBlack),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
}
