import 'package:flutter/material.dart';
import 'package:gerencia_money/receita_form_page.dart';
import 'package:gerencia_money/despesa_form_page.dart';
import 'package:gerencia_money/transacao_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'despesas_page.dart';
import 'receitas_page.dart';


class HomePage extends StatefulWidget {
  final List<Transacao> transacoes;

  const HomePage({Key? key, required this.transacoes}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _saldo = 0.0;
  double _despesas = 0.0;
  double _receitas = 0.0;
  List<Transacao> transacoes = [];

  final _formKey = GlobalKey<FormState>();
  String _descricao = '';
  double _valor = 0.0;
  DateTime _data = DateTime.now();

  @override
  void initState() {
    super.initState();
    carregarTransacoesDoSharedPreferences();
  }

  Future<void> salvarTransacoesNoSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> transacoesString = transacoes.map((transacao) {
      return '${transacao.descricao},${transacao.valor},${transacao.data.toIso8601String()}';
    }).toList();

    await prefs.setStringList('transacoes', transacoesString);
  }

  Future<void> carregarTransacoesDoSharedPreferences() async {
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

      // Atualizar as variáveis relacionadas à UI aqui
      _despesas = transacoes.where((t) => t.valor < 0).fold(0.0, (acc, t) => acc + t.valor);
      _receitas = transacoes.where((t) => t.valor >= 0).fold(0.0, (acc, t) => acc + t.valor);
      _saldo = _receitas + _despesas;
    });
  }

  void adicionarTransacao(String descricao, double valor, DateTime data) {
    setState(() {
      Transacao transacao = Transacao(descricao: descricao, valor: valor, data: data);
      transacoes.add(transacao);

      if (transacao.valor < 0) {
        _despesas += transacao.valor;
      }

      if (transacao.valor >= 0) {
        _receitas += transacao.valor;
      }

      _saldo = _receitas + _despesas;

      salvarTransacoesNoSharedPreferences();
    });
  }


  void _removerTransacao(Transacao transacao) {
    setState(() {
      transacoes.remove(transacao);

      if (transacao.valor < 0) {
        _despesas -= transacao.valor;
      } else {
        _receitas -= transacao.valor;
      }
      _saldo = _receitas + _despesas;

      salvarTransacoesNoSharedPreferences();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(transacao.valor < 0
            ? 'Despesa excluída com sucesso!'
            : 'Receita excluída com sucesso!'),
      ),
    );
  }


    Widget buildTransacaoItem(Transacao transacao) {
      String dataFormatada =
          "${transacao.data.day.toString().padLeft(2, '0')}-${transacao.data
          .month.toString().padLeft(2, '0')}-${transacao.data.year}";

      String valorFormatado = transacao.valor.toStringAsFixed(2);

      return ListTile(
        title: Text(transacao.descricao),
        subtitle: Text(
          dataFormatada,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: Text(
          'R\$ $valorFormatado',
          style: TextStyle(
            color: transacao.valor >= 0 ? Colors.green : Colors.red,
          ),
        ),
        tileColor: transacao.valor >= 0 ? Colors.green[50] : Colors.red[50],
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Detalhes da Transação'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('Descrição'),
                      subtitle: Text(transacao.descricao),
                    ),
                    ListTile(
                      title: Text('Data'),
                      subtitle: Text(dataFormatada),
                    ),
                    ListTile(
                      title: Text('Valor'),
                      subtitle: Text('R\$ $valorFormatado'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget buildTransacaoList(List<Transacao> transacoes) {
      return Expanded(
        child: ListView.builder(
          itemCount: transacoes.length,
          itemBuilder: (context, index) {
            return Card(
              child: buildTransacaoItem(transacoes[index]),
            );
          },
        ),
      );
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Saldo',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$ ${_saldo.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 36.0,
                        color: _saldo >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const Text(
                          'Receitas',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${_receitas.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const Text(
                          'Despesas',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${_despesas.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            buildTransacaoList(transacoes),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Despesas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Receitas',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0: // Início
              // Navegar para a HomePage (se necessário)
                break;
              case 1: // Despesas
                List<Transacao> despesas = transacoes.where((t) => t.valor < 0)
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DespesasPage(despesas: despesas,
                        onRemoveTransaction: _removerTransacao),
                  ),
                );
                break;
              case 2: // Receitas
                List<Transacao> receitas = transacoes.where((t) => t.valor >= 0)
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceitasPage(receitas: receitas,
                        onRemoveTransaction: _removerTransacao),
                  ),
                );
                break;
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
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
                            MaterialPageRoute(builder: (context) =>
                                DespesaFormPage(onSubmit: adicionarTransacao)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text('Receita'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReceitaFormPage(
                                    onSubmit: adicionarTransacao)),
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


