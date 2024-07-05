import 'package:flutter/material.dart';

const hintStyle = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);
const borderStyle =
    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)));

InputDecoration criarInputDecoration(
    String label, String hintText, bool isError) {
  return InputDecoration(
    isDense: true,
    filled: false,
    contentPadding: const EdgeInsets.all(8),
    label: Text(label),
    hintText: hintText,
    hintStyle: hintStyle,
    border: borderStyle,
    errorText: isError ? 'Valor inválido' : null,
  );
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String label;
  final String hintText;
  final bool isError;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.label,
    required this.hintText,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: criarInputDecoration(label, hintText, isError),
      onChanged: onChanged,
    );
  }
}
