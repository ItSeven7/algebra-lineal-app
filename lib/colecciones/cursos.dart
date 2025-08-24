// Clases para estructurar la información de los cursos en la app
// Mapeados como en Firestore

class Curso {
  final String id;
  final String nombre;
  final String descripcion;
  final List<Unidad> unidades;

  Curso({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.unidades,
  });
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
    required this.temas,
  });
}

class Tema {
  final String id;
  final String nombre;
  final List<SubTema> subtemas;

  Tema({
    required this.id,
    required this.nombre,
    required this.subtemas,
  });
}

class SubTema {
  final String titulo;
  // final List<Map<String, dynamic>> contenido;
  final String contenido;

  SubTema({
    required this.titulo,
    required this.contenido,
  });

  factory SubTema.fromMap(Map<String, dynamic> data) {
    return SubTema(
      titulo: data['titulo'] ?? '',
      // contenido: (data['contenido'] as List<dynamic>)
      //     .map((item) => Map<String, dynamic>.from(item))
      //     .toList(),
      contenido: data['contenido'],
    );
  }
}
