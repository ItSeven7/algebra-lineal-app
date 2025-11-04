// Clases para estructurar la información del usuario en la app
// Mapeados como en Firestore

class Usuario {
  String nombre;
  String apellidos;
  final String email;
  final Progreso progreso;

  Usuario({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.progreso,
  });
}

class Progreso {
  final List<CursoU> cursos;

  Progreso({required this.cursos});
}

class CursoU {
  final String id;
  final List<UnidadU> unidades;

  CursoU({required this.id, required this.unidades});
}

class UnidadU {
  final String id;
  final List<TemaU> temas;

  UnidadU({required this.id, required this.temas});
}

class TemaU {
  final String id;
  final List<bool> subtemas;

  TemaU({required this.id, required this.subtemas});

  factory TemaU.fromMap(Map<String, dynamic> data, String id) {
    final subtemas = (data['subtemas'] as List<dynamic>? ?? [])
        .map((e) => e as bool)
        .toList();

    return TemaU(id: id, subtemas: subtemas);
  }
}
