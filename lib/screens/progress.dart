import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../colecciones/usuario.dart';
import '../services/firebase_user_service.dart';
import '../widgets/cards.dart';
import '../models/text_styles.dart';

UserService userService = UserService();
List<CursoU> cursos = [];
Progreso progresoUsuario = Progreso(cursos: cursos);

List<String> nombreCurso = ['Álgebra Lineal'];
bool loadingIsComplete = false;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreen();
}

class _ProgressScreen extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    cargarProgresoUsuario().then((data) {
      if (!mounted) return;
      setState(() {
        progresoUsuario = data;
        loadingIsComplete = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingIsComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
        centerTitle: true,
      ),
      body: loadingIsComplete
          ? RefreshIndicator(
              displacement: 10,
              onRefresh: () async {
                await cargarProgresoUsuario().then((data) {
                  setState(() {
                    progresoUsuario = data;
                  });
                });
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: progresoUsuario.cursos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final curso = progresoUsuario.cursos[index];
                          return CardProgress(
                              curso: nombreCurso[index],
                              unidades: curso.unidades);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.threeArchedCircle(
              color: textStyles.header.color!.withValues(alpha: 0.6),
              size: 40,
            )),
    );
  }
}

Future<Progreso> cargarProgresoUsuario() async {
  final userFirebase = FirebaseAuth.instance.currentUser;
  final data = await userService.getUserData(userFirebase!.uid);

  progresoUsuario = data.progreso;

  debugPrint(progresoUsuario.cursos.first.unidades.first.id);

  return data.progreso;
}
