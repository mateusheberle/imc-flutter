import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// const hintStyle = TextStyle(fontSize: 24, fontStyle: FontStyle.italic);
const borderStyle =
    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)));

InputDecoration criarInputDecoration(bool isError) {
  return InputDecoration(
    // labelStyle: TextStyle(
    //   color: isError ? Colors.red : Colors.grey[800],
    // ),
    isDense: true,
    filled: false,
    contentPadding: const EdgeInsets.all(8),
    // label: Text(label),
    // hintText: hintText,
    // hintStyle: hintStyle,
    border: borderStyle,
    errorText: isError ? 'Valor inválido' : null,
  );
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final bool isError;
  final FocusNode focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.focusNode,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      decoration: criarInputDecoration(isError).copyWith(
        border: InputBorder.none,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      // decoration: criarInputDecoration(label, hintText, isError),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      style: TextStyle(
          fontSize: 36,
          color: Colors.grey[800],
          fontFamily: GoogleFonts.nunito().fontFamily),
    );
  }
}
