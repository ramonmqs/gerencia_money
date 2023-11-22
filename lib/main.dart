import 'package:flutter/material.dart';
import 'package:gerencia_money/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Despesas e Receitas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0x362559)),
            brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      home: WelcomePage(),
    );
  }
}

