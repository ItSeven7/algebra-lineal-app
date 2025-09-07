import 'package:flutter/material.dart';

import '../models/text_styles.dart';

class SimpleForm extends StatelessWidget {
  final String labelText;
  final int maxLines;
  final bool isEnable;
  final bool readOnly;
  final TextEditingController controller;

  const SimpleForm({
    super.key,
    required this.labelText,
    this.maxLines = 1,
    required this.isEnable,
    this.readOnly = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      enabled: isEnable,
      maxLines: maxLines,
      style: AppTextStyles.bodyBlack,
      decoration: InputDecoration(
        enabled: isEnable,
        labelStyle: AppTextStyles.bodyBlack,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
