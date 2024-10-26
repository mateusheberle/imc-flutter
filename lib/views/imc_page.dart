import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calcule seu IMC',
          style: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      height: size / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Peso (kilogramas)',
                              style: TextStyle(
                                fontFamily: GoogleFonts.nunito().fontFamily,
                                fontSize: 16,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: ValueListenableBuilder(
                              valueListenable: imcController.erroPeso,
                              builder: (context, value, _) {
                                return CustomTextField(
                                  controller: imcController.pesoController,
                                  onChanged: (valor) =>
                                      imcController.validarPeso(valor),
                                  isError: value,
                                  focusNode: _pesoFocusNode,
                                  onSubmitted: (value) {
                                    _pesoFocusNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_alturaFocusNode);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      height: size / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Altura (metros)',
                              style: TextStyle(
                                fontFamily: GoogleFonts.nunito().fontFamily,
                                fontSize: 16,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: ValueListenableBuilder(
                              valueListenable: imcController.erroAltura,
                              builder: (context, value, _) {
                                return CustomTextField(
                                  controller: imcController.alturaController,
                                  onChanged: (valor) =>
                                      imcController.validarAltura(valor),
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
                    ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: imcController.botaoProcessar,
                  builder: (context, value, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: !value
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                _animationController.forward();
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Calcular IMC',
                              style: TextStyle(
                                  color: Colors.grey[100],
                                  fontFamily: GoogleFonts.nunito().fontFamily)),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                      descricao: 'Peso',
                      valorImc: imcModel.peso,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      descricao: 'Altura',
                      valorImc: imcModel.altura,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      descricao: 'IMC',
                      valorImc: imcController.resultadoImc,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    MensagemIMC(imcModel: imcModel),
                    SizedBox(
                      height: 240,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            startAngle: 180,
                            endAngle: 0,
                            minimum: 10,
                            maximum: 40,
                            pointers: <GaugePointer>[
                              NeedlePointer(value: imcController.resultadoImc),
                            ],
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 18.49,
                                  color: Colors.grey[300]),
                              GaugeRange(
                                  startValue: 18.5,
                                  endValue: 25,
                                  color: Colors.grey[500]),
                              GaugeRange(
                                  startValue: 25,
                                  endValue: 40,
                                  color: Colors.grey[800]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
