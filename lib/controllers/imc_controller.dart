import 'package:flutter/material.dart';
import '../models/imc_model.dart';

class ImcController {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  ValueNotifier<bool> erroPeso = ValueNotifier(false);
  ValueNotifier<bool> erroAltura = ValueNotifier(false);
  ValueNotifier<bool> botaoProcessar = ValueNotifier(false);

  void validarPeso(String valor) {
    valor = valor.replaceAll(',', '.');
    if (valor.isNotEmpty && double.tryParse(valor) != null) {
      if (double.tryParse(valor)! < 500 && double.tryParse(valor)! > 0) {
        erroPeso.value = false;
      } else {
        erroPeso.value = true;
      }
    } else {
      erroPeso.value = true;
    }
  }

  void validarAltura(String valor) {
    valor = valor.replaceAll(',', '.');
    if (valor.isNotEmpty && double.tryParse(valor) != null) {
      if (double.tryParse(valor)! <= 2.5 && double.tryParse(valor)! >= 0.5) {
        erroAltura.value = false;
      } else {
        erroAltura.value = true;
      }
    } else {
      erroAltura.value = true;
    }
  }

  double resultadoImc = 0;

  void _adicionarListener(ValueNotifier listener) {
    listener.addListener(_habilitaBotao);
  }

  ImcController() {
    _adicionarListener(pesoController);
    _adicionarListener(alturaController);
    _adicionarListener(erroPeso);
    _adicionarListener(erroAltura);
  }

  void _habilitaBotao() {
    if (pesoController.text.isEmpty || alturaController.text.isEmpty) {
      botaoProcessar.value = false;
    } else {
      botaoProcessar.value =
          erroPeso.value == false && erroAltura.value == false;
    }
  }

  ImcModel processarIMC() {
    resultadoImc = double.tryParse(_calcularIMC().toStringAsFixed(2)) as double;

    if (resultadoImc == 0) {
      return ImcModel(
        peso: 0,
        altura: 0,
        mensagem: 'Erro ao calcular IMC',
      );
    }

    var mensagemIMC = _obterMensagemIMC(resultadoImc);

    ImcModel imcModel = ImcModel(
      peso: double.parse(pesoController.value.text.replaceAll(',', '.')),
      altura: double.parse(alturaController.value.text.replaceAll(',', '.')),
      mensagem: mensagemIMC,
    );

    return imcModel;
  }

  double _calcularIMC() {
    // peso / (altura * altura)

    try {
      double pesoIMC =
          double.parse(pesoController.value.text.replaceAll(',', '.'));
      double alturaIMC =
          double.parse(alturaController.value.text.replaceAll(',', '.'));

      if (pesoIMC < 500 && pesoIMC > 0) {
        if (alturaIMC <= 2.5 && alturaIMC >= 0.5) {
          double valorIMC = pesoIMC / (alturaIMC * alturaIMC);
          return valorIMC;
        }
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String _obterMensagemIMC(double valorIMC) {
    if (valorIMC < 16) {
      return 'Baixo peso muito grave';
    } else if (valorIMC <= 16.99) {
      return 'Baixo peso grave';
    } else if (valorIMC <= 18.49) {
      return 'Baixo peso';
    } else if (valorIMC <= 24.99) {
      return 'Peso normal';
    } else if (valorIMC <= 29.99) {
      return 'Sobrepeso';
    } else if (valorIMC <= 34.99) {
      return 'Obesidade grau I';
    } else if (valorIMC <= 39.99) {
      return 'Obesidade grau II';
    } else {
      return 'Obesidade grau III (obesidade mórbida)';
    }
  }
  // String _obterMensagemIMC(double valorIMC) {
  //   if (valorIMC < 16) {
  //     return 'Baixo peso muito grave\nabaixo de 16 kg/m²';
  //   } else if (valorIMC <= 16.99) {
  //     return 'Baixo peso grave\nentre 16 e 16,99 kg/m²';
  //   } else if (valorIMC <= 18.49) {
  //     return 'Baixo peso\nentre 17 e 18,49 kg/m²';
  //   } else if (valorIMC <= 24.99) {
  //     return 'Peso normal\nentre 18,50 e 24,99 kg/m²';
  //   } else if (valorIMC <= 29.99) {
  //     return 'Sobrepeso\nentre 25 e 29,99 kg/m²';
  //   } else if (valorIMC <= 34.99) {
  //     return 'Obesidade grau I\nentre 30 e 34,99 kg/m²';
  //   } else if (valorIMC <= 39.99) {
  //     return 'Obesidade grau II\nentre 35 e 39,99 kg/m²';
  //   } else {
  //     return 'Obesidade grau III (obesidade mórbida)\nmaior que 40 kg/m²';
  //   }
  // }
}
