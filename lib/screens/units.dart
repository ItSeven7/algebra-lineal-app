import 'package:aplication_algebra_lineal/screens/account.dart';
import 'package:aplication_algebra_lineal/screens/topics.dart';
import 'package:aplication_algebra_lineal/services/firebase_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colecciones/cursos.dart';
import '../colecciones/usuarios.dart';
import '../widgets/cards.dart';
import '../models/text_styles.dart';

UserService userService = UserService();
Usuario? user = usuario;

// ignore: must_be_immutable
class UnitScreen extends StatefulWidget {
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
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario().then((data) {
      setState(() {
        user = data;
      });
    });
  }

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
              trailing:
                  Text(widget.nombreCurso, style: AppTextStyles.subHeader))),
      body: Scaffold(
        appBar: AppBar(
          toolbarHeight: 33,
          automaticallyImplyLeading: false,
          title: Text('Unidades', style: AppTextStyles.subHeaderWithOpacity),
        ),
        body: RefreshIndicator(
          displacement: 3,
          onRefresh: () async {
            await _cargarDatosUsuario().then((data) {
              setState(() {
                user = data;
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.unidades.length,
              itemBuilder: (context, index) {
                final unidad = widget.unidades[index];
                return CardUnidad(
                  unidad: index + 1,
                  nombre: unidad.nombre,
                  totalTemas: unidad.temas.length,
                  resumen: unidad.resumen,
                  unidadU: _obtenerTemas(unidad.id),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TopicScreen(
                                  cursoId: widget.cursoId,
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
      ),
    );
  }

  UnidadU _obtenerTemas(String unidadId) {
    UnidadU aux = UnidadU(id: "", temas: []);

    for (var curso in user!.progreso.cursos) {
      if (curso.id == widget.cursoId) {
        for (var unidad in curso.unidades) {
          if (unidad.id == unidadId) {
            return unidad;
          }
        }
      }
    }
    return aux;
  }

  Future<Usuario> _cargarDatosUsuario() async {
    final userFirebase = FirebaseAuth.instance.currentUser;
    final data = await userService.getUserData(userFirebase!.uid);

    return data;
  }
}
