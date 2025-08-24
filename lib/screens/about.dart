import 'package:flutter/material.dart';
import '../models/text_styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implementa los estilos de texto dinámicamente desde 'text_styles.dart'
    final textStyles = AppTextStyles(Theme.of(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca De'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('\n'),
                // Card(
                //   child: Image.asset('assets/img/logo_medtrack.png',
                //       scale: 1.1, height: 160),
                // ),
                Text('AlGeneal\n', style: textStyles.header10),
                Text('Sobre la Aplicación', style: textStyles.header),
                const Text(
                    'El objetivo de la aplicación es brindarle a los estudiantes, de la materia '
                    'de Álgebra Lineal, una herramienta para repasar y retroalimentar los temas del curso.\n',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyBlack),
                Text('Desarrollo', style: textStyles.header),
                const Text(
                    'Esta aplicación fue desarrollada como trabajo del servicio social '
                    'de la facultad de Ciencias de la Computación de la BUAP.\n',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyBlack),
                Text('Contacto', style: textStyles.header),
                const Text(
                    'Para errores y/o sugerencias puedes comunicarte mandando un correo '
                    'a la siguiente dirección: ari.rodriguez@alumno.buap.mx',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyBlack),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text('Versión: 1.0.0',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBlack,
            overflow: TextOverflow.visible),
      ),
    );
  }
}
