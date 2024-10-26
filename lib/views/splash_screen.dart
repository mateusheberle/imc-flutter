import 'package:flutter/material.dart';
import 'package:imc_flutter/views/imc_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 2), () {}); // Duração da splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ImcPage(),
      ), // Substitua pelo nome da tela principal do seu app
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: SizedBox(
            width: 200,
            height: 200,
            child: Image.asset('assets/logo.png'),
          ), // Substitua pelo caminho da sua imagem
        ),
      ),
    );
  }
}
