import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colecciones/usuario.dart';
import '../models/color_themes.dart';
import '../providers/content_provider.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<Usuario> getUserData(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    debugPrint("GET USUARIOS getUserData");

    final data = userDoc.data();
    if (data == null) throw Exception("El usuario no existe.");

    String nombre = data['nombre'] ?? '';
    String apellidos = data['apellidos'] ?? '';
    String email = data['email'] ?? '';

    // Leer progreso (si existe)
    Map<String, dynamic> progresoData =
        Map<String, dynamic>.from(data['progreso_curso_1'] ?? {});

    List<CursoU> cursos = [];

    progresoData.forEach((unidadId, temasMap) {
      Map<String, dynamic> temas = Map<String, dynamic>.from(temasMap);

      List<TemaU> temasList = temas.entries.map((entry) {
        // entry.value es la lista de subtemas (List<dynamic>)
        final subtemas = List<bool>.from(entry.value);
        return TemaU(id: entry.key, subtemas: subtemas);
      }).toList();

      UnidadU unidad = UnidadU(id: unidadId, temas: temasList);
      cursos.add(CursoU(id: 'curso_1', unidades: [unidad]));
    });

    Progreso progreso = Progreso(cursos: cursos);

    Usuario usuario = Usuario(
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      progreso: progreso,
    );

    return usuario;
  }

  Future<void> saveChanges(
      String uid, String nombre, String apellidos, String email) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
    }, SetOptions(merge: true));
    debugPrint('Save');
  }

  Future<void> initializeUserProgress(
      String uid, ContentProvider contentProvider) async {
    try {
      final curso = contentProvider.getCurso("curso_1");
      if (curso == null) {
        debugPrint("⚠️ No se encontró el curso_1 en caché.");
        return;
      }

      // Estructura base del progreso
      final Map<String, dynamic> progresoCurso = {};

      for (var unidad in curso.unidades) {
        final Map<String, dynamic> progresoUnidad = {};

        for (var tema in unidad.temas) {
          // Cada tema tiene una lista booleana por cada subtema
          progresoUnidad[tema.id] =
              List.generate(tema.subtemas.length, (_) => false);
        }

        progresoCurso[unidad.id] = progresoUnidad;
      }

      await _db.collection('usuarios').doc(uid).update({
        'progreso_curso_1': progresoCurso,
      });

      debugPrint("✅ Progreso inicial generado para usuario $uid");
    } catch (e) {
      debugPrint("❌ Error generando progreso: $e");
    }
  }

  Future<void> checkAndInitializeProgress(
      String uid, ContentProvider contentProvider) async {
    final docRef = _db.collection('usuarios').doc(uid);
    final snap = await docRef.get();
    debugPrint("GET USUARIOS checkAndInitializeProgress");

    if (snap.data()?['progreso_curso_1'] == null) {
      debugPrint("🆕 Generando progreso inicial...");
      await initializeUserProgress(uid, contentProvider);
    } else {
      debugPrint("✅ El usuario ya tiene progreso, no se crea nuevamente.");
    }
  }

  @Deprecated(
      "Esta función se utlizaba para actualizar la antigua estrtuctura de la base de datos del usuario (expira el 21 de Noviembre)")
  Future<void> updateProgressUser(String uid, String cursoId) async {
    final firestore = FirebaseFirestore.instance;

    final cursoRef = firestore.collection('cursos').doc(cursoId);
    final unidadesSnap = await cursoRef.collection('unidades').get();

    for (var unidadDoc in unidadesSnap.docs) {
      final unidadId = unidadDoc.id;
      final temasSnap = await unidadDoc.reference.collection('temas').get();

      for (var temaDoc in temasSnap.docs) {
        final temaId = temaDoc.id;

        // Subtemas del contenido (cantidad actual)
        final subtemasSnap =
            await temaDoc.reference.collection('subtemas').get();
        final subtemasCount = subtemasSnap.size;

        // Referencia al progreso del usuario
        final progresoTemaRef = firestore
            .collection('usuarios')
            .doc(uid)
            .collection('progreso')
            .doc(cursoId)
            .collection('unidades')
            .doc(unidadId)
            .collection('temas')
            .doc(temaId);

        final progresoSnap = await progresoTemaRef.get();

        if (progresoSnap.exists) {
          // Ya existe → comparar y extender si es necesario
          final data = progresoSnap.data();
          final List<bool> progresoActual =
              (data?['subtemas'] as List<dynamic>? ?? [])
                  .map((e) => e as bool)
                  .toList();

          final diferencia = subtemasCount - progresoActual.length;
          if (diferencia > 0) {
            final nuevos = List<bool>.filled(diferencia, false);
            final actualizado = [...progresoActual.cast<bool>(), ...nuevos];
            await progresoTemaRef.update({'subtemas': actualizado});
            debugPrint(
                'Tema $temaId extendido con $diferencia nuevos subtemas');
          } else {
            debugPrint('Tema $temaId ya está completo');
          }
        } else {
          // No existe → crear nuevo tema en progreso
          final nuevos = List<bool>.filled(subtemasCount, false);
          await progresoTemaRef.set({'subtemas': nuevos});
          debugPrint('Tema $temaId creado con $subtemasCount subtemas');
        }

        // Crear unidad si no existe
        final unidadRef = progresoTemaRef.parent.parent;
        final unidadSnap = await unidadRef!.get();
        if (!unidadSnap.exists) {
          await unidadRef.set({'creado': true});
          debugPrint('Unidad $unidadId creada');
        }

        // Crear curso si no existe
        final cursoSnap = await unidadRef.parent.parent!.get();
        if (!cursoSnap.exists) {
          await cursoSnap.reference.set({'creado': true});
          debugPrint('Curso $cursoId creado');
        }
      }
    }
  }

  Future<void> setSubtopicComplete(
    Usuario? usuario,
    String uid,
    String cursoId,
    String unidadId,
    String temaId,
    int index,
  ) async {
    if (usuario == null) return;

    // Actualizamos el progreso en memoria
    for (var curso in usuario.progreso.cursos) {
      if (curso.id == cursoId) {
        for (var unidad in curso.unidades) {
          if (unidad.id == unidadId) {
            for (var tema in unidad.temas) {
              if (tema.id == temaId) {
                tema.subtemas[index] = true;

                // Actualizamos directamente en Firestore usando notación de puntos
                await FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(uid)
                    .update(
                        {'progreso_curso_1.$unidadId.$temaId': tema.subtemas});

                return; // Terminamos y salimos del loop
              }
            }
          }
        }
      }
    }
  }

  Future<AppColorTheme> obtenerTemaDesdeFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    var doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user?.uid)
        .collection('ajustes')
        .doc('tema')
        .get();

    if (doc.exists) {
      final data = doc.data();
      String colorTema = data!['color_tema'];
      switch (colorTema) {
        case 'rojo':
          return AppColorTheme.rojo;
        case 'indigo':
          return AppColorTheme.indigo;
        case 'purpura':
          return AppColorTheme.purpura;
        case 'azulMarino':
          return AppColorTheme.azulMarino;
        case 'verdeTeal':
          return AppColorTheme.verdeTeal;
        case 'purpuraOscuro':
          return AppColorTheme.purpuraOscuro;
        case 'marron':
          return AppColorTheme.marron;
        case 'grisCarbon':
          return AppColorTheme.grisCarbon;
        case 'magenta':
          return AppColorTheme.magenta;
        case 'lavandaAzul':
          return AppColorTheme.lavandaAzul;
        default:
          return AppColorTheme.rojo;
      }
    }
    return AppColorTheme.rojo;
  }
}
