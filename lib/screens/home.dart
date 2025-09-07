import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/progress.dart';
import '../screens/courses.dart';
import '../screens/account.dart';
import '../models/color_themes.dart';
import '../services/firebase_user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 1;

  List<Widget> screens = const [
    ProgressScreen(),
    CourseScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    actualizarProgreso().then((data) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Implementa los estilos de texto dinámicamente desde 'text_styles.dart'
    //final textStyles = AppTextStyles(Theme.of(context));

    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: myIndex,
          children: screens,
        ),
      ),
      backgroundColor: ColorsUI.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.insert_chart),
                icon: Icon(Icons.insert_chart_outlined_outlined),
                label: 'Progreso'),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.person_2),
                icon: Icon(Icons.person_2_outlined),
                label: 'Tú')
          ]),
    );
  }
}

Future<void> actualizarProgreso() async {
  final user = FirebaseAuth.instance.currentUser;

  final cursosSnap =
      await FirebaseFirestore.instance.collection('cursos').get();
  for (var curso in cursosSnap.docs) {
    await UserService().updateProgressUser(user!.uid.toString(), curso.id);
  }
}
