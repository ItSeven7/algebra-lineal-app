import 'package:flutter/material.dart';
import 'dart:math';

import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_user_service.dart';
import '../colecciones/cursos.dart';
import '../widgets/buttons.dart';
import '../screens/account.dart';

UserService userService = UserService();
bool complete = true;

List<String> titulos = [
  '¡Bien hecho!',
  '¡Excelente!',
  '¡Buen trabajo!',
  '¡Con todo!',
  '\$texto_positivo'
];

// ignore: must_be_immutable
class SubtopicScreen extends StatelessWidget {
  int index;
  String cursoId;
  String unidadId;
  String temaId;
  int numeroTema;
  String nombreTema;
  SubTema subtema;

  SubtopicScreen(
      {super.key,
      required this.cursoId,
      required this.unidadId,
      required this.temaId,
      required this.index,
      required this.numeroTema,
      required this.nombreTema,
      required this.subtema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Tema $numeroTema.${index + 1}',
            style: TextStyle(fontSize: 16)),
        leadingWidth: 33,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(subtema.titulo), Text(subtema.contenido)],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SimpleButtonBorder(
                  onPressed: () => _setSubtopicComplete(context),
                  text: 'Marcar como completado',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _setSubtopicComplete(BuildContext context) {
    final userFirebase = FirebaseAuth.instance.currentUser;

    userService
        .setSubtopicComplete(
            usuario, userFirebase!.uid, cursoId, unidadId, temaId, index)
        .then((_) {
      complete = true;
    });

    if (complete == true) {
      QuickAlert.show(
        context: context,
        animType: QuickAlertAnimType.slideInUp,
        borderRadius: 7,
        type: QuickAlertType.success,
        confirmBtnColor: Colors.green,
        title: titulos[Random().nextInt(5)],
        text: 'Subtema completado, sigue así',
        confirmBtnText: 'Continuar',
      );
    } else {
      QuickAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        animType: QuickAlertAnimType.slideInUp,
        borderRadius: 7,
        type: QuickAlertType.error,
        confirmBtnColor: Colors.red,
        title: '¡Sin internet!',
        text: 'Conéctate e intentalo de nuevo',
        confirmBtnText: 'Cerrar',
      );
    }

    complete = false;
  }
}
