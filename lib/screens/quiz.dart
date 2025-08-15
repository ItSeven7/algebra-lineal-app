import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuizScreen extends StatelessWidget {
  String nombreUnidad;

  QuizScreen({
    super.key,
    required this.nombreUnidad,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('Custionario: $nombreUnidad', style: TextStyle(fontSize: 16)),
        leadingWidth: 33,
      ),
      body: Center(child: stepperExample()),
    );
  }
}

Stepper stepperExample() {
  int index = 0;

  return Stepper(
    currentStep: index,
    onStepCancel: () {
      if (index > 0) {
        index -= 1;
      }
    },
    onStepContinue: () {
      if (index <= 0) {
        index += 1;
      }
    },
    onStepTapped: (int index) {
      index = index;
    },
    steps: <Step>[
      Step(
        title: const Text('Step 1 title'),
        content: Container(
          alignment: Alignment.centerLeft,
          child: const Text('Content for Step 1'),
        ),
      ),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 2')),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 3')),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 4')),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 5')),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 6')),
      Step(title: Text('Step 2 title'), content: Text('Content for Step 7')),
    ],
  );
}
