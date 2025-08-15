import 'package:aplication_algebra_lineal/screens/topics.dart';
import 'package:flutter/material.dart';

import '../colecciones/cursos.dart';
import '../widgets/cards.dart';
import '../models/text_styles.dart';

// ignore: must_be_immutable
class UnitScreen extends StatelessWidget {
  String cursoId;
  String nombreCurso;
  List<Unidad> unidades;

  UnitScreen({
    super.key,
    required this.cursoId,
    required this.nombreCurso,
    required this.unidades,
  });

  @override
  Widget build(BuildContext context) {
    //final textStyles = AppTextStyles(Theme.of(context));
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 40,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Abre el drawer
            },
          ),
          title: ListTile(
              trailing: Text(nombreCurso, style: AppTextStyles.subHeader))),
      body: Scaffold(
        appBar: AppBar(
          toolbarHeight: 33,
          automaticallyImplyLeading: false,
          title: Text('Unidades', style: AppTextStyles.subHeaderWithOpacity),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: unidades.length,
            itemBuilder: (context, index) {
              final unidad = unidades[index];
              return CardUnidad(
                unidad: index + 1,
                nombre: unidad.nombre,
                totalTemas: unidad.temas.length,
                resumen: unidad.resumen,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TopicScreen(
                                cursoId: cursoId,
                                unidadId: unidad.id,
                                numeroUnidad: index + 1,
                                nombreUnidad: unidad.nombre,
                                temas: unidad.temas,
                              )));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
