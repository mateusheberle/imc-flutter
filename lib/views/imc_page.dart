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

class _ImcPageState extends State<ImcPage> with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 500);

  ImcController imcController = ImcController();

  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Size> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );

    _animationController.addListener(() async {
      if (_animationController.isCompleted) {
        await Future.delayed(_duration);
        _animationController.reverse();
        // await Future.delayed(_duration);
        mostrarDialogoIMC(context);
      }
    });

    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ).animate(_animationController);

    _sizeAnimation = Tween(begin: const Size(0, 0), end: const Size(100, 100))
        .animate(_animationController);
  }

  @override
  void dispose() {
    imcController.pesoController.dispose();
    imcController.alturaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final FocusNode _pesoFocusNode = FocusNode();
  final FocusNode _alturaFocusNode = FocusNode();

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
                        focusNode: _pesoFocusNode,
                        onSubmitted: (value) {
                          _pesoFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_alturaFocusNode);
                        },
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
                        focusNode: _alturaFocusNode,
                        onSubmitted: (value) {
                          _alturaFocusNode.unfocus();
                          _animationController.forward();
                        },
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
                                FocusScope.of(context).unfocus();
                                _animationController.forward();
                              },
                        child: Text('Calcular IMC',
                            style: TextStyle(color: Colors.grey[800])),
                      );
                    },
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: _alignmentAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: _sizeAnimation.value.width,
                    height: _sizeAnimation.value.height,
                    child: CircularProgressIndicator(
                      //value: _animationController.value,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey[800]!),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void mostrarDialogoIMC(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        ImcModel imcModel = imcController.processarIMC();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          titlePadding: const EdgeInsets.symmetric(horizontal: 0),
          title: const AlertTitle(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          content: imcController.resultadoImc == 0
              ? Center(
                  heightFactor: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.grey[800],
                      ),
                      const Padding(
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
        );
      },
    );
  }
}
