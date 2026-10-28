import 'package:flutter/material.dart';

/// A calculator key with a consistent shape and touch target.
class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    required this.label,
    required this.onPressed,
    this.isOperator = false,
    this.isAction = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isOperator;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = isOperator
        ? colors.primaryContainer
        : isAction
        ? colors.secondaryContainer
        : colors.surfaceContainerHigh;
    final foreground = isOperator
        ? colors.onPrimaryContainer
        : isAction
        ? colors.onSecondaryContainer
        : colors.onSurface;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox.expand(
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(4),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
