import 'package:flutter/material.dart';
import 'package:gerencia_money/transacao_helper.dart';
import 'package:gerencia_money/welcome_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar transações ao inicializar o aplicativo
  List<Transacao> transacoes = await TransacaoHelper.carregarTransacoes();

  runApp(MyApp(transacoes: transacoes));
}


class MyApp extends StatelessWidget {
  final List<Transacao> transacoes;

  const MyApp({Key? key, required this.transacoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Despesas e Receitas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00362559)),
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      home: WelcomePage(transacoes: transacoes),
      debugShowCheckedModeBanner: false,
    );

  }
}




