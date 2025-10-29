import 'package:cloud_firestore/cloud_firestore.dart';

class Curso {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Unidad> unidades;

  Curso({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.unidades = const [],
  });

  factory Curso.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Curso(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
    );
  }
}

class Unidad {
  final String id;
  final String nombre;
  final String resumen;
  final List<Tema> temas;

  Unidad({
    required this.id,
    required this.nombre,
    required this.resumen,
    this.temas = const [],
  });

  factory Unidad.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Unidad(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      resumen: data['resumen'] ?? '',
    );
  }
}

class Tema {
  final String id;
  final String nombre;
  final List<SubTema> subtemas;

  Tema({
    required this.id,
    required this.nombre,
    this.subtemas = const [],
  });

  factory Tema.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tema(
      id: doc.id,
      nombre: data['nombre'] ?? '',
    );
  }
}

class SubTema {
  final String id;
  final String titulo;
  final String contenido;

  SubTema({
    required this.id,
    required this.titulo,
    required this.contenido,
  });

  factory SubTema.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubTema(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      contenido: data['contenido'] ?? '',
    );
  }
}
