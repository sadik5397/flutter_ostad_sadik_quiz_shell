import 'package:flutter/material.dart';

import 'my_text_field.dart';

class OptionField extends StatelessWidget {
  const OptionField({super.key, required this.controller, required this.label, required this.index, this.onRemove});

  final TextEditingController controller;
  final String label;
  final int index;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Radio<int?>(value: index, activeColor: colorScheme.primary, visualDensity: VisualDensity.compact),
        Expanded(
          child: MyTextField(controller: controller, label: label, validator: (v) => v!.isEmpty ? "Enter $label" : null),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
          ),
      ],
    );
  }
}
