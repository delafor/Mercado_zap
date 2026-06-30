import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.onChanged,
    required this.value,
  }) : super(key: key);
  final String label;
  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.isNotEmpty) Text(label),
          Checkbox(
       
            value: value,
            onChanged: (v) {
              if (v != null) {
                onChanged(v);
              }
            },
          ),
        ],
      ),
    );
  }
}
