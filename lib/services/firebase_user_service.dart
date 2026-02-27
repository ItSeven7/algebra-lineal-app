import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colecciones/usuario.dart';
import '../models/color_themes.dart';
import '../providers/content_provider.dart';

/// Maneja las operaciones para obtener de **Firestore** los datos del **Usuario**.
class UserService {
  final _db = FirebaseFirestore.instance;

  /// Obtiene los datos y progreso del usuario desde su documento (UID) y los organiza de acuerdo a la colección _usuarios_.
  /// Si el usuario se registra por primera vez crea un nuevo documento en Firestore e inicializa todos los campos, así como el progreso.
  /// 
  /// Si el documento (UID) no existe, devuelve una excepción.
  /// 
  /// Devuelve un objeto [Usuario].
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
    List<UnidadU> unidades = [];

    progresoData.forEach((unidadId, temasMap) {
      Map<String, dynamic> temas = Map<String, dynamic>.from(temasMap);

      List<TemaU> temasList = temas.entries.map((entry) {
        // entry.value es la lista de subtemas (List<dynamic>)
        final subtemas = List<bool>.from(entry.value);
        return TemaU(id: entry.key, subtemas: subtemas);
      }).toList();

      UnidadU unidad = UnidadU(id: unidadId, temas: temasList);
      unidades.add(unidad);
    });

    cursos.add(CursoU(id: 'curso_1', unidades: unidades));

    debugPrint("getUserData CURSOS: ${cursos.length}");

    Progreso progreso = Progreso(cursos: cursos);

    Usuario usuario = Usuario(
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      progreso: progreso,
    );

    return usuario;
  }

  /// Actualiza únicamente los datos personales del usuario en el documento. Reemplaza solamente los campos que han cambiado.
  Future<void> updatePersonalInfo(
      String uid, String nombre, String apellidos, String email) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
    }, SetOptions(merge: true));
    debugPrint('Save');
  }

  /// Crea el campo de progreso en el documento de Firestore del usuario.
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

  /// Verifica la existencia del campo _progreso_ en su documento de Firestore del usuario.
  /// Lo inicializa en caso de no existir.
  /// 
  /// Hasta el momento ésta es la manera de inicializar el _progreso_ del usuario. Se ejecuta cada que se inicia seión.
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

  /// Actualiza el estado de un _subtema_ en el progreso del usuario. Lo hace en el documento de Firestore y en el Provider.
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

  /// Obtiene el tema de la aplicación desde el documento del usuario.
  /// Se ejecuta cada que se inicia seión.
  /// 
  /// Devuelve un objeto [AppColorTheme]. Por defecto retorna [AppColorTheme.rojo].
  Future<AppColorTheme> obtenerTemaDesdeFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return AppColorTheme.rojo;
    }

    var doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
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
