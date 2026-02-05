import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../colecciones/curso.dart';

/// Representa todo el contenido del curso y de las colecciones de Firestore:
/// - unidades
/// - temas
/// - subtemas
/// 
/// Mantiene el estado global de estos datos en un objeto [Curso].
class ContentProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cache local
  final Map<String, Curso> _cursosCache = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Retorna un curso desde la caché (si ya fue cargado)
  Curso? getCurso(String id) => _cursosCache[id];

  /// Carga un curso completo (cursos → unidades → temas → subtemas)
  Future<void> loadCurso(String cursoId) async {
    if (_cursosCache.containsKey(cursoId)) return; // ya cargado

    _isLoading = true;
    debugPrint("LOAD CURSO");

    try {
      // 1️⃣ Curso base
      final cursoDoc = await _db.collection('cursos').doc(cursoId).get();
      final curso = Curso.fromFirestore(cursoDoc);
      debugPrint("GET CURSOS");

      // 2️⃣ Unidades del curso
      final unidadesSnap = await _db
          .collection('unidades')
          .where('cursoId', isEqualTo: cursoId)
          .get();
      debugPrint("GET UNIDADES");

      final unidades = <Unidad>[];
      for (var unidadDoc in unidadesSnap.docs) {
        final unidad = Unidad.fromFirestore(unidadDoc);

        // 3️⃣ Temas de la unidad
        final temasSnap = await _db
            .collection('temas')
            .where('unidadId', isEqualTo: unidad.id)
            .get();
        debugPrint("GET TEMAS");

        final temas = <Tema>[];
        for (var temaDoc in temasSnap.docs) {
          final tema = Tema.fromFirestore(temaDoc);

          // 4️⃣ Subtemas del tema
          final subtemasSnap = await _db
              .collection('subtemas')
              .where('temaId', isEqualTo: tema.id)
              .get();
          debugPrint("GET SUBTEMAS");

          final subtemas =
              subtemasSnap.docs.map((s) => SubTema.fromFirestore(s)).toList();

          temas.add(Tema(
            id: tema.id,
            nombre: tema.nombre,
            subtemas: subtemas,
          ));
        }

        unidades.add(Unidad(
          id: unidad.id,
          nombre: unidad.nombre,
          resumen: unidad.resumen,
          temas: temas,
        ));
      }

      _cursosCache[cursoId] = Curso(
        id: curso.id,
        nombre: curso.nombre,
        descripcion: curso.descripcion,
        unidades: unidades,
      );
    } catch (e) {
      debugPrint('Error cargando curso: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
