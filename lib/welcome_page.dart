import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerencia_money/transacao_helper.dart';
import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  final List<Transacao> transacoes;

  const WelcomePage({Key? key, required this.transacoes}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerencia Money'),
      ),
      // Defina a cor de fundo aqui
      backgroundColor: Colors.deepPurpleAccent, // ou outra cor roxa desejada

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem-vindo ao Gerencia Money!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(transacoes: widget.transacoes)),
                );
              },
              child: Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }
}





