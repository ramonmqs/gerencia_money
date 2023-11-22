import 'package:flutter/material.dart';
import 'package:gerencia_money/receita_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'despesa_form_page.dart';

class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;

  Transacao({required this.descricao, required this.valor, required this.data});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double saldo = 0.0;
  double despesas = 0.0;
  double receitas = 0.0;

  List<Transacao> transacoes = [];

  void salvarTransacoes() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> transacoesString = transacoes.map((transacao) {
      return '${transacao.descricao},${transacao.valor},${transacao.data.toIso8601String()}';
    }).toList();

    await prefs.setStringList('transacoes', transacoesString);
  }

  void carregarTransacoes() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> transacoesString = prefs.getStringList('transacoes') ?? [];

    setState(() {
      transacoes = transacoesString.map((transacaoString) {
        List<String> partes = transacaoString.split(',');
        String descricao = partes[0];
        double valor = double.parse(partes[1]);
        DateTime data = DateTime.parse(partes[2]);

        return Transacao(descricao: descricao, valor: valor, data: data);
      }).toList();
    });
  }


  void adicionarTransacao(String descricao, double valor, DateTime data) {
    setState(() {
      transacoes.add(Transacao(descricao: descricao, valor: valor, data: data));

      if (valor < 0) {
        despesas += valor;
      } else {
        receitas += valor;
      }

      saldo += valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Saldo',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'R\$ ${saldo.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 48.0,
                      color: saldo >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${receitas.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Despesas',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${despesas.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Aqui você pode adicionar a lista de despesas e receitas
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Receitas',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Cadastrar'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.money_off),
                        title: Text('Despesa'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DespesaFormPage(onSubmit: adicionarTransacao)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.money),
                        title: Text('Receita'),
                        onTap: (){
                          Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context) => ReceitaFormPage(onSubmit: adicionarTransacao)),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    }
}

