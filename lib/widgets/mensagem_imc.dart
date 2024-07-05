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
            'Nível IMC',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
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
