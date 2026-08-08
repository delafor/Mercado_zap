import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;

  final bool obscureText;
  final String hintText;
  final Color? colors;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final int? maxLines;
  final InputDecoration? decoration;
  final int? minLines;
  final ValueChanged<String>? onChanged;

  final dynamic errorText;

  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.controller,
    this.decoration,
    this.colors,
    required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.minLines,
    this.errorText,
    this.inputFormatters, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),

      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          errorText: errorText,
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,

          hintText: hintText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? value;

  const CustomText({Key? key, required this.text, this.style, this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
