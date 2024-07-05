class ImcModel {
  final double peso;
  final double altura;
  final String mensagem;

  ImcModel({
    required this.peso,
    required this.altura,
    required this.mensagem,
  });

  factory ImcModel.fromJson(Map json) {
    return ImcModel(
      peso: json['peso'],
      altura: json['altura'],
      mensagem: json['mensagem'],
    );
  }

  @override
  String toString() {
    return 'Peso: $peso, Altura: $altura, Mensagem: $mensagem';
  }
}
