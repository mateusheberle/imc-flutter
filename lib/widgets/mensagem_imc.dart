import 'package:flutter/material.dart';

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
              fontSize: 14,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
