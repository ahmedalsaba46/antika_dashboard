import 'package:flutter/material.dart';

import 'containers_decoration.dart';

class InputBoxColumn extends StatelessWidget {
  const InputBoxColumn({
    Key? key,
    required this.label,
    required this.hintText,
    required this.suffixIconData,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.maxLength,
    this.keyboardType,
    this.expands = false,
    this.maxLines = 1,
  }) : super(key: key);

  final String hintText, label;
  final IconData suffixIconData;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool expands;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          label,
          style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: const Color(0xFF2E7D32),
          ),
        ),
        SizedBox(height: 15),
        Container(
          decoration: containersDecoration(context),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            cursorColor: const Color(0xFF4CAF50),
            style: textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              color: const Color(0xFF333333),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF9E9E9E),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: Icon(
                suffixIconData,
                color: const Color(0xFF4CAF50),
              ),
            ),
            maxLength: maxLength,
            obscureText: obscureText,
            validator: validator,
            expands: expands,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
