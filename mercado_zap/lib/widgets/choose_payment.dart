import 'package:flutter/material.dart';

class ChoosePayment extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color iconColor;
  final bool isSelected;
  final Function(bool?) onChanged;

  const ChoosePayment({
    super.key,
    this.onPressed,
    required this.title,
    required this.subtitle,
    this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color:
                  isSelected
                      ? Colors.green
                      : const Color.fromARGB(135, 158, 158, 158),
            ),
          ),
        ),

        onPressed: onPressed,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onChanged,
                    shape: const CircleBorder(),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side: const BorderSide(width: 2, color: Colors.grey),
                  ),
                ),

                const SizedBox(width: 5),

                Icon(icon, size: 35, color: iconColor),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,

                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
