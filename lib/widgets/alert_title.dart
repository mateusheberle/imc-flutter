import 'package:flutter/material.dart';

class AlertTitle extends StatelessWidget {
  const AlertTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: const Center(
        child: Text(
          'Resultado IMC',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
