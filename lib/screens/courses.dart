import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../providers/content_provider.dart';
import '../providers/user_provider.dart';
import '../screens/units.dart';
import '../models/color_themes.dart';
import '../models/text_styles.dart';
import '../widgets/cards.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 26),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: const Text('AlGeneal'),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreen();
}

class _CourseScreen extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    userProvider.refreshProgress(contentProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Implementa los estilos de texto dinámicamente desde 'text_styles.dart'
    final textStyles = AppTextStyles(Theme.of(context));
    final curso = Provider.of<ContentProvider>(context).getCurso('curso_1');

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: Drawer(
        width: 300,
        shape: Border.all(width: 1, color: ColorsUI.backgroundColor),
        child: ListView(
          children: [
            ListTile(
              title: Text('AlGeneal', style: textStyles.header),
              contentPadding: const EdgeInsets.only(left: 33.0),
              minVerticalPadding: 16.0,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              contentPadding: const EdgeInsets.only(left: 30.0),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Acerca de'),
              contentPadding: const EdgeInsets.only(left: 30.0),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cursos:',
              style: AppTextStyles.cardSubtitle,
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  children: [
                    CardCourse(
                      nombre: curso!.nombre,
                      descripcion: curso.descripcion,
                      totalUnidades: curso.unidades.length,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UnitScreen(
                                cursoId: curso.id,
                                nombreCurso: curso.nombre,
                                unidades: curso.unidades),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ColorsUI.backgroundColor,
    );
  }
}

void showDialogAlert(BuildContext context) {
  QuickAlert.show(
    context: context,
    animType: QuickAlertAnimType.slideInUp,
    borderRadius: 7,
    type: QuickAlertType.success,
    confirmBtnColor: Colors.green,
    title: '¡Bien hecho!',
    text: 'Subtema completado exitosamente, sigue así',
    confirmBtnText: 'Continuar',
  );
}
