import 'dart:math';
import 'package:aplication_algebra_lineal/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../models/text_styles.dart';
import '../services/firebase_user_service.dart';
import '../colecciones/curso.dart';
import '../widgets/buttons.dart';

UserService userService = UserService();
bool complete = true;

List<String> frasesMotivacion = [
  '¡Bien hecho!',
  '¡Excelente!',
  '¡Buen trabajo!',
  '¡Con todo!',
  '\$texto_positivo'
];

// ignore: must_be_immutable
class SubtopicScreen extends StatefulWidget {
  int index;
  String cursoId;
  String unidadId;
  String temaId;
  int numeroTema;
  String nombreTema;
  SubTema subtema;
  UserProvider? userProvider;

  SubtopicScreen({
    super.key,
    required this.cursoId,
    required this.unidadId,
    required this.temaId,
    required this.index,
    required this.numeroTema,
    required this.nombreTema,
    required this.subtema,
    required this.userProvider,
  });

  @override
  State<SubtopicScreen> createState() => _SubtopicScreenState();
}

class _SubtopicScreenState extends State<SubtopicScreen> {
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
        centerTitle: true,
        title: Text('Tema ${widget.numeroTema}.${widget.index + 1}',
            style: TextStyle(fontSize: 16)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(14),
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            spacing: 33,
            children: [
              SelectionArea(
                child: GptMarkdown(
                  widget.subtema.contenido,
                  style: AppTextStyles.bodyBlack,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SimpleButtonBorder(
                    onPressed: () => _setSubtopicComplete(context, widget.userProvider),
                    text: 'Marcar como completado',
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void _setSubtopicComplete(BuildContext context, UserProvider? userProvider) {
    final userFirebase = FirebaseAuth.instance.currentUser;
    userProvider!.refresh();

    userService
        .setSubtopicComplete(widget.userProvider!.usuario, userFirebase!.uid, widget.cursoId,
            widget.unidadId, widget.temaId, widget.index)
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
        title: frasesMotivacion[Random().nextInt(5)],
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
