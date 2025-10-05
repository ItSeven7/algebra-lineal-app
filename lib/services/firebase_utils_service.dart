import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UtilService {
  void agregarSub() {
    addSubtopic('curso_1', 'unidad_1', 'tema_1', 'subtema_1');
  }
}

Future<void> addSubtopic(
  String cursoId,
  String unidadId,
  String temaId,
  String subtemaId,
) async {
  final Map<String, dynamic> subtema = {
    'titulo': 'Propiedad conmutativa',
    'contenido': [
      {'type': 'texto', 'data': 'La propiedad conmutativa dice que:'},
      {'type': 'formula', 'data': 'a + b = b + a'}
    ]
  };

  await FirebaseFirestore.instance
      .collection('cursos')
      .doc(cursoId)
      .collection('unidades')
      .doc(unidadId)
      .collection('temas')
      .doc(temaId)
      .collection('subtemas')
      .doc(subtemaId)
      .set(subtema);

  debugPrint('Datos subidos correctamente.');
}
