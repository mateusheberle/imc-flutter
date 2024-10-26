import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/imc_model.dart';

class MensagemIMC extends StatelessWidget {
  final ImcModel imcModel;

  const MensagemIMC({
    super.key,
    required this.imcModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            imcModel.mensagem,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[800],
              fontFamily: GoogleFonts.nunito().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
