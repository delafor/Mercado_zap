import 'package:flutter/material.dart';

class ChoosePayment extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? cor;

  const ChoosePayment({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: onPressed,

        icon: Icon(icon, color: Colors.white),

        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
