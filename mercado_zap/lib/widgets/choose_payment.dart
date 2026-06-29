import 'package:flutter/material.dart';

class ChoosePayment extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final bool? isSelected;
  final ValueChanged<bool?>? onChanged;

  const ChoosePayment({
    super.key,
    this.onPressed,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = isSelected ?? false;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color:
                  selected
                      ? Colors.green
                      : const Color.fromARGB(135, 158, 158, 158),
            ),
          ),
        ),
        child: Row(
          children: [
            if (onChanged != null)
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: selected,
                  onChanged: onChanged,
                  shape: const CircleBorder(),
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  side: const BorderSide(width: 2, color: Colors.grey),
                ),
              ),

            if (onChanged != null) const SizedBox(width: 8),

            if (icon != null) Icon(icon, size: 35, color: iconColor),

            if (icon != null) const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
