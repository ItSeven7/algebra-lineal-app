import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../screens/account.dart';
import '../colecciones/usuarios.dart';
import '../colecciones/cursos.dart';
import '../models/text_styles.dart';
import '../services/firebase_user_service.dart';
import '../widgets/cards.dart';

UserService userService = UserService();
Usuario? user = usuario;

// ignore: must_be_immutable
class TopicScreen extends StatefulWidget {
  String cursoId;
  String unidadId;
  int numeroUnidad;
  String nombreUnidad;
  List<Tema> temas;

  TopicScreen({
    super.key,
    required this.cursoId,
    required this.unidadId,
    required this.numeroUnidad,
    required this.nombreUnidad,
    required this.temas,
  });

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
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
    Future.delayed(Duration(seconds: 3));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: ListTile(
          trailing: Text('Unidad ${widget.numeroUnidad}',
              style: AppTextStyles.subHeader),
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          toolbarHeight: 33,
          automaticallyImplyLeading: false,
          title: Text(widget.nombreUnidad,
              style: AppTextStyles.subHeaderWithOpacity),
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
              itemCount: widget.temas.length,
              itemBuilder: (context, index) {
                final tema = widget.temas[index];
                return CardTema(
                  cursoId: widget.cursoId,
                  unidadId: widget.unidadId,
                  temaId: tema.id,
                  numero: index + 1,
                  nombre: tema.nombre,
                  subtemas: tema.subtemas,
                  completados: _obtenerListaSubtemas(tema.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<bool> _obtenerListaSubtemas(String temaId) {
    List<bool> listaSubtemas = [];

    for (var curso in user!.progreso.cursos) {
      if (curso.id == widget.cursoId) {
        for (var unidad in curso.unidades) {
          if (unidad.id == widget.unidadId) {
            for (var tema in unidad.temas) {
              if (temaId == tema.id) {
                return tema.subtemas;
              }
            }
          }
        }
      }
    }

    return listaSubtemas;
  }

  Future<Usuario> _cargarDatosUsuario() async {
    final userFirebase = FirebaseAuth.instance.currentUser;
    final data = await userService.getUserData(userFirebase!.uid);

    return data;
  }
}
