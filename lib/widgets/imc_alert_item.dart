import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImcAlertItem extends StatelessWidget {
  final String descricao;
  final double valorImc;

  const ImcAlertItem({
    super.key,
    required this.valorImc,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        descricao,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.nunito().fontFamily,
        ),
      ),
      trailing: Text(
        valorImc.toString().replaceAll('.', ','),
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[800],
          fontFamily: GoogleFonts.nunito().fontFamily,
        ),
      ),
    );
  }
}
