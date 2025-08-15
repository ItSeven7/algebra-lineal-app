import 'package:flutter/material.dart';
import '../models/color_themes.dart';
import '../models/text_styles.dart';

class SimpleButtonFilled extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SimpleButtonFilled({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(3))),
      child: Text(
        text,
      ),
    );
  }
}

class SimpleButtonOutlined extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SimpleButtonOutlined({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorsUI.backgroundColor,
          foregroundColor: textStyles.bodyColor.color,
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(3))),
      child: Text(
        text,
      ),
    );
  }
}

class SimpleButtonBorder extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SimpleButtonBorder({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return OutlinedButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          backgroundColor: ColorsUI.backgroundColor,
          foregroundColor: textStyles.bodyColor.color,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(3))),
      child: Text(
        text,
      ),
    );
  }
}
