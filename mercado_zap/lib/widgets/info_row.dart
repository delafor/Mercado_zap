import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String? text;
  final String? quantidade;
  final String? valor;
  final String? total;
  final String? valorTotal;

  const InfoRow({
    super.key,
    this.quantidade,
    this.text,
    this.total,

    this.valorTotal,
    this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Row(
              children: [
                if (total != null)
                  Text(
                    total!,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                if (quantidade != null)
                  Text(
                    quantidade!,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                if (quantidade != null && text != null) SizedBox(width: 10),
                if (text != null)
                  Text(
                    text!,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          if (valorTotal != null)
            Text(
              valorTotal!,

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.secondary,
              ),
            ),

          // TITULO
          if (valor != null)
            Text(
              valor!,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
