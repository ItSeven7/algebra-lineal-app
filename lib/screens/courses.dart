import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';

import '../screens/units.dart';
import '../colecciones/curso.dart';
import '../widgets/cards.dart';
import '../models/color_themes.dart';
import '../models/text_styles.dart';

List<Curso> cursos = [];
bool loadingIsComplete = false;

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
    loadDataBase().then((data) {
      if (!mounted) return;
      setState(() {
        cursos = data;
        loadingIsComplete = true;
      });
    }).timeout(Duration(seconds: 5), onTimeout: () {});
  }

  @override
  void dispose() {
    super.dispose();
    loadingIsComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    // Implementa los estilos de texto dinámicamente desde 'text_styles.dart'
    final textStyles = AppTextStyles(Theme.of(context));

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
      body: loadingIsComplete
          ? RefreshIndicator(
              displacement: 3,
              onRefresh: () async {
                await loadDataBase().then((data) {
                  setState(() {
                    cursos = data;
                  });
                });
              },
              child: Padding(
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
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemCount: cursos.length,
                          itemBuilder: (context, index) {
                            final curso = cursos[index];
                            return CardCourse(
                              nombre: curso.nombre,
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                  color: textStyles.header.color!.withValues(alpha: 0.6),
                  size: 40)),
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

Future<List<Curso>> loadDataBase() async {
  debugPrint("LOAD DATA BASE");

  final cursosSnap =
      await FirebaseFirestore.instance.collection('cursos').get();

  List<Curso> cursos = [];

  for (var cursoDoc in cursosSnap.docs) {
    final cursoId = cursoDoc.id;
    final cursoData = cursoDoc.data();

    // 1. Cargar unidades
    final unidadesSnap = await cursoDoc.reference.collection('unidades').get();
    List<Unidad> unidades = [];

    for (var unidadDoc in unidadesSnap.docs) {
      final unidadId = unidadDoc.id;
      final unidadData = unidadDoc.data();

      // 2. Cargar temas
      final temasSnap = await unidadDoc.reference.collection('temas').get();
      List<Tema> temas = [];

      for (var temaDoc in temasSnap.docs) {
        final temaId = temaDoc.id;
        final temaData = temaDoc.data();

        // 3. Cargar subtemas
        final subtemasSnap =
            await temaDoc.reference.collection('subtemas').get();
        List<SubTema> subtemas =
            subtemasSnap.docs.map((s) => SubTema.fromMap(s.data())).toList();

        temas.add(Tema(
          id: temaId,
          nombre: temaData['nombre'],
          subtemas: subtemas,
        ));
      }

      unidades.add(Unidad(
        id: unidadId,
        nombre: unidadData['nombre'],
        resumen: unidadData['resumen'],
        temas: temas,
      ));
    }

    cursos.add(Curso(
      id: cursoId,
      nombre: cursoData['nombre'],
      descripcion: cursoData['descripcion'],
      unidades: unidades,
    ));
  }

  return cursos;
}
