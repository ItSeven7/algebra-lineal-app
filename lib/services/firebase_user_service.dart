import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colecciones/usuarios.dart';
import '../models/color_themes.dart';

class UserService {
  Future<Usuario> getUserData(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

    final data = userDoc.data();
    String nombre = data!['nombre'];
    String apellidos = data['apellidos'];
    String email = data['email'];

    final progresoSnap = await userDoc.reference.collection('progreso').get();
    List<CursoU> cursos = [];

    for (var cursoDoc in progresoSnap.docs) {
      final cursoID = cursoDoc.id;

      final unidadesSnap =
          await cursoDoc.reference.collection('unidades').get();
      List<UnidadU> unidades = [];

      for (var unidadDoc in unidadesSnap.docs) {
        final unidadID = unidadDoc.id;

        final temasSnap = await unidadDoc.reference.collection('temas').get();
        List<TemaU> temas =
            temasSnap.docs.map((t) => TemaU.fromMap(t.data(), t.id)).toList();

        unidades.add(UnidadU(id: unidadID, temas: temas));
      }

      cursos.add(CursoU(id: cursoID, unidades: unidades));
    }

    Progreso progreso = Progreso(cursos: cursos);
    Usuario usuario = Usuario(
        nombre: nombre, apellidos: apellidos, email: email, progreso: progreso);
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
            await temaDoc.reference.collection('sub_temas').get();
        final subtemasCount = subtemasSnap.size + 1;

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

  Future<void> setSubtopicComplete(Usuario? usuario, String uid, String cursoId,
      String unidadId, String temaId, int index) async {
    for (var curso in usuario!.progreso.cursos) {
      if (curso.id == cursoId) {
        for (var unidad in curso.unidades) {
          if (unidad.id == unidadId) {
            for (var tema in unidad.temas) {
              if (temaId == tema.id) {
                tema.subtemas[index] = true;

                await FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(uid)
                    .collection('progreso')
                    .doc(cursoId)
                    .collection('unidades')
                    .doc(unidadId)
                    .collection('temas')
                    .doc(temaId)
                    .update({'subtemas': tema.subtemas});
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
