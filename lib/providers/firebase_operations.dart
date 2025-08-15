// import 'package:aplication_algebra_lineal/models/color_themes.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// final user = FirebaseAuth.instance.currentUser;

// Future<AppColorTheme> obtenerTemaDesdeFirestore() async {
//   var doc = await FirebaseFirestore.instance
//       .collection('usuarios')
//       .doc(user?.uid)
//       .collection('ajustes')
//       .doc('tema')
//       .get();

//   if (doc.exists) {
//     final data = doc.data();
//     String colorTema = data!['color_tema'];
//     switch (colorTema) {
//       case 'rojo':
//         return AppColorTheme.rojo;
//       case 'indigo':
//         return AppColorTheme.indigo;
//       case 'purpura':
//         return AppColorTheme.purpura;
//       case 'azulMarino':
//         return AppColorTheme.azulMarino;
//       case 'verdeTeal':
//         return AppColorTheme.verdeTeal;
//       case 'purpuraOscuro':
//         return AppColorTheme.purpuraOscuro;
//       case 'marron':
//         return AppColorTheme.marron;
//       case 'grisCarbon':
//         return AppColorTheme.grisCarbon;
//       case 'magenta':
//         return AppColorTheme.magenta;
//       case 'lavandaAzul':
//         return AppColorTheme.lavandaAzul;
//       default:
//         return AppColorTheme.rojo;
//     }
//   } else {
//     await FirebaseFirestore.instance
//         .collection('usuarios')
//         .doc(user?.uid)
//         .collection('ajustes')
//         .doc('tema')
//         .set({'color_tema': 'rojo'});
//   }
//   return AppColorTheme.rojo;
// }

// Future<void> actualizarProgresoUsuario(String uid, String cursoId) async {
//   final firestore = FirebaseFirestore.instance;

//   final cursoRef = firestore.collection('cursos').doc(cursoId);
//   final unidadesSnap = await cursoRef.collection('unidades').get();

//   for (var unidadDoc in unidadesSnap.docs) {
//     final unidadId = unidadDoc.id;
//     final temasSnap = await unidadDoc.reference.collection('temas').get();

//     for (var temaDoc in temasSnap.docs) {
//       final temaId = temaDoc.id;

//       // Subtemas del contenido (cantidad actual)
//       final subtemasSnap =
//           await temaDoc.reference.collection('sub_temas').get();
//       final subtemasCount = subtemasSnap.size + 1;

//       // Referencia al progreso del usuario
//       final progresoTemaRef = firestore
//           .collection('usuarios')
//           .doc(uid)
//           .collection('progreso')
//           .doc(cursoId)
//           .collection('unidades')
//           .doc(unidadId)
//           .collection('temas')
//           .doc(temaId);

//       final progresoSnap = await progresoTemaRef.get();

//       if (progresoSnap.exists) {
//         // Ya existe → comparar y extender si es necesario
//         final data = progresoSnap.data();
//         final List<bool> progresoActual = data?['subtemas'] ?? [];

//         final diferencia = subtemasCount - progresoActual.length;
//         if (diferencia > 0) {
//           final nuevos = List<bool>.filled(diferencia, false);
//           final actualizado = [...progresoActual.cast<bool>(), ...nuevos];
//           await progresoTemaRef.update({'subtemas': actualizado});
//           debugPrint('Tema $temaId extendido con $diferencia nuevos subtemas');
//         } else {
//           debugPrint('Tema $temaId ya está completo');
//         }
//       } else {
//         // No existe → crear nuevo tema en progreso
//         final nuevos = List<bool>.filled(subtemasCount, false);
//         await progresoTemaRef.set({'subtemas': nuevos});
//         debugPrint('Tema $temaId creado con $subtemasCount subtemas');
//       }

//       // Crear unidad si no existe
//       final unidadRef = progresoTemaRef.parent.parent;
//       final unidadSnap = await unidadRef!.get();
//       if (!unidadSnap.exists) {
//         await unidadRef.set({'creado': true});
//         debugPrint('Unidad $unidadId creada');
//       }

//       // Crear curso si no existe
//       final cursoSnap = await unidadRef.parent.parent!.get();
//       if (!cursoSnap.exists) {
//         await cursoSnap.reference.set({'creado': true});
//         debugPrint('Curso $cursoId creado');
//       }
//     }
//   }
// }
