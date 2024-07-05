import 'package:flutter/material.dart';

class ImcAlertItem extends StatelessWidget {
  final String descricao;
  final double valorImc;
  final Widget icon;

  const ImcAlertItem({
    super.key,
    required this.valorImc,
    required this.descricao,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        descricao,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      trailing: Text(
        valorImc.toString().replaceAll('.', ','),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      leading: icon,
    );
  }
}
