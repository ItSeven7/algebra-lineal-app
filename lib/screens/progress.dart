import 'package:aplication_algebra_lineal/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/cards.dart';
import '../models/text_styles.dart';

List<String> nombreCurso = ['Álgebra Lineal'];

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreen();
}

class _ProgressScreen extends State<ProgressScreen> {

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
        centerTitle: true,
      ),
      body: userProvider.isLoaded
          ? RefreshIndicator(
              displacement: 10,
              onRefresh: userProvider.refresh,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: userProvider.usuario!.progreso.cursos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final curso = userProvider.usuario!.progreso.cursos[index];
                          return CardProgress(
                              curso: nombreCurso[index],
                              unidades: curso.unidades);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.threeArchedCircle(
              color: textStyles.header.color!.withValues(alpha: 0.6),
              size: 40,
            )),
    );
  }
}