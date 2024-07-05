import 'package:flutter/material.dart';

import '../controllers/imc_controller.dart';
import '../models/imc_model.dart';
import '../widgets/alert_title.dart';
import '../widgets/imc_alert_item.dart';
import '../widgets/mensagem_imc.dart';
import '../widgets/custom_text_field.dart';

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  ImcController imcController = ImcController();

  @override
  void dispose() {
    imcController.pesoController.dispose();
    imcController.alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: imcController.erroPeso,
                    builder: (context, value, _) {
                      return CustomTextField(
                        controller: imcController.pesoController,
                        onChanged: (valor) => imcController.validarPeso(valor),
                        label: 'Peso',
                        hintText: 'KG (kilogramas)',
                        isError: value,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: imcController.erroAltura,
                    builder: (context, value, _) {
                      return CustomTextField(
                        controller: imcController.alturaController,
                        onChanged: (valor) =>
                            imcController.validarAltura(valor),
                        label: 'Altura',
                        hintText: 'M (metros)',
                        isError: value,
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: imcController.botaoProcessar,
                    builder: (context, value, _) {
                      return ElevatedButton(
                        onPressed: !value
                            ? null
                            : () {
                                ImcModel imcModel =
                                    imcController.processarIMC();
                                mostrarDialogoIMC(context, imcModel);
                              },
                        child: Text('Processar IMC',
                            style: TextStyle(color: Colors.grey[800])),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void mostrarDialogoIMC(BuildContext context, ImcModel imcModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          titlePadding: const EdgeInsets.symmetric(horizontal: 0),
          title: const AlertTitle(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          content: imcController.resultadoImc == 0
              ? const Center(
                  heightFactor: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Os dados não foram \ninformados corretamente',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImcAlertItem(
                      icon: Icon(
                        Icons.scale,
                        size: 24,
                        color: Colors.grey[800],
                      ),
                      descricao: 'Peso',
                      valorImc: imcModel.peso,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      icon: Icon(
                        Icons.height,
                        size: 24,
                        color: Colors.grey[800],
                      ),
                      descricao: 'Altura',
                      valorImc: imcModel.altura,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      icon: Icon(
                        Icons.show_chart_outlined,
                        size: 30,
                        color: Colors.grey[800],
                      ),
                      descricao: 'IMC',
                      valorImc: imcController.resultadoImc,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    MensagemIMC(imcModel: imcModel)
                  ],
                ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar', style: TextStyle(color: Colors.grey[800])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
