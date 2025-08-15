import 'package:aplication_algebra_lineal/colecciones/cursos.dart';
import 'package:aplication_algebra_lineal/colecciones/usuarios.dart';
import 'package:aplication_algebra_lineal/screens/subtopic.dart';
import 'package:flutter/material.dart';

import '../models/text_styles.dart';

// Para mostrar el curso
class CardCourse extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final int totalUnidades;
  final VoidCallback onTap;

  const CardCourse({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.totalUnidades,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: textStyles.bodyColor.color),
              height: 10,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              title: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(nombre),
                trailing: Text('$totalUnidades Unidades'),
              ),
              subtitle: Center(
                child: Text(descripcion, style: AppTextStyles.bodyBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Para mostrar la Unidad
class CardUnidad extends StatelessWidget {
  final int unidad;
  final String nombre;
  final String resumen;
  final int totalTemas;
  final VoidCallback onTap;

  const CardUnidad({
    super.key,
    required this.unidad,
    required this.nombre,
    required this.resumen,
    required this.totalTemas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: textStyles.bodyColor.color),
              height: 9,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              title: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text('Unidad $unidad'),
                subtitle: Text(nombre),
                trailing: Text('0/$totalTemas'),
              ),
              subtitle: Center(
                child: Text(resumen, style: AppTextStyles.bodyBlack),
              ),
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

// Para mostrar el tema
class CardTema extends StatelessWidget {
  final String cursoId;
  final String unidadId;
  final String temaId;
  final int numero;
  final String nombre;
  final List<SubTema> subtemas;
  final List<bool> completados;

  const CardTema({
    super.key,
    required this.cursoId,
    required this.unidadId,
    required this.temaId,
    required this.numero,
    required this.nombre,
    required this.subtemas,
    required this.completados,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 13),
      child: ListBody(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: textStyles.bodyColor.color),
            height: 5,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
          ),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text('$numero. $nombre'),
            children: List.generate(
              subtemas.length,
              (index) => SubtemaTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SubtopicScreen(
                                index: index,
                                cursoId: cursoId,
                                unidadId: unidadId,
                                temaId: temaId,
                                numeroTema: numero,
                                nombreTema: nombre,
                                subtema: subtemas[index],
                              )));
                },
                titulo: subtemas[index].titulo,
                completado:
                    completados.length > index ? completados[index] : false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Para mostrar los subtemas
class SubtemaTile extends StatelessWidget {
  final String titulo;
  final bool completado;
  final VoidCallback onTap;

  const SubtemaTile({
    super.key,
    required this.titulo,
    required this.completado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.menu_book_rounded,
          color: AppTextStyles.cardTrailing.color),
      title: Text(titulo, style: AppTextStyles.cardSubtitle),
      trailing: completado
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
    );
  }
}

/////////////////////////////////   PROGRESO    /////////////////////////////////
// Para mostrar el progreso
class CardProgress extends StatelessWidget {
  final String curso;
  final List<UnidadU> unidades;

  const CardProgress({
    super.key,
    required this.curso,
    required this.unidades,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListBody(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: textStyles.bodyColor.color),
            height: 10,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
          ),
          ExpansionTile(
            title: Text(curso, style: AppTextStyles.cardSubtitle),
            subtitle: Text('Temas completados',
                style: AppTextStyles.progressCardSubtitle),
            trailing: const Text('Resumen',
                style: AppTextStyles.cardSubtitle, textAlign: TextAlign.right),
            children: List.generate(
              unidades.length,
              (index) => UnidadProgresoTile(
                unidad: index + 1,
                temas: unidades[index].temas,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Para mostrar el progreso de cada unidad
class UnidadProgresoTile extends StatelessWidget {
  final int unidad;
  final List<TemaU> temas;
  //final String calificacion;

  const UnidadProgresoTile({
    super.key,
    required this.unidad,
    required this.temas,
    //required this.calificacion,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('Unidad $unidad:', style: AppTextStyles.cardSubtitle),
      title: Row(
        children: List.generate(
            temas.length,
            (index) => esTemaCompleto(temas[index].subtemas)
                ? Icon(Icons.check_box_rounded, color: Colors.green)
                : Icon(Icons.check_box_outline_blank_rounded, size: 23)),
      ),
    );
  }
}

bool esTemaCompleto(List<bool> subtemas) {
  for (var s in subtemas) {
    debugPrint('$s');
    if (s == false) {
      return false;
    }
  }
  return true;
}
