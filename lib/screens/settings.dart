import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/theme_provider.dart';
import '../models/color_themes.dart';
import '../models/text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final textStyles = AppTextStyles(Theme.of(context));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Ajustes'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          ListTile(
            title: const Text('Tema', style: AppTextStyles.bodyTitleBlack),
            subtitle: const Text(
                'Selecciona el color principal para aplicación',
                style: AppTextStyles.bodyBlack),
            trailing: Icon(Icons.palette, color: textStyles.bodyColor.color),
            onTap: () => _showThemeDialog(context, themeNotifier),
          ),
        ],
      ),
    );
  }
}

void _showThemeDialog(BuildContext context, ThemeNotifier themeNotifier) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        title: const Text('Temas disponibles'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: AppColorTheme.values.map((theme) {
              final color = appThemeColors[theme]!;

              return ListTile(
                leading: CircleAvatar(backgroundColor: color),
                titleTextStyle: AppTextStyles.cardSubtitle,
                title: Text(
                  getNombreColor(theme.name),
                ),
                onTap: () {
                  themeNotifier.updateTheme(theme);
                  saveUserColor(theme);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

String getNombreColor(String name) {
  switch (name) {
    case 'rojo':
      return 'Rojo';
    case 'indigo':
      return 'índigo';
    case 'purpura':
      return 'Púrpura';
    case 'azulMarino':
      return 'Azul Marino';
    case 'verdeTeal':
      return 'Verde Teal';
    case 'purpuraOscuro':
      return 'Púrpura Oscuro';
    case 'marron':
      return 'Marrón';
    case 'grisCarbon':
      return 'Gris Carbon';
    case 'magenta':
      return 'Magenta';
    case 'lavandaAzul':
      return 'Lavanda Azul';
    default:
      return '';
  }
}

Future<void> saveUserColor(AppColorTheme theme) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(user!.uid)
      .collection('ajustes')
      .doc('tema')
      .set({
    'color_tema': theme.name,
  });
}
