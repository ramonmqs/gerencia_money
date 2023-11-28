// receitas_page.dart
import 'package:flutter/material.dart';
import 'transacao_helper.dart';

class ReceitasPage extends StatelessWidget {
  final List<Transacao> receitas;
  final Function(Transacao) onRemoveTransaction;

  const ReceitasPage({Key? key, required this.receitas, required this.onRemoveTransaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
      ),
      body: buildTransacaoList(receitas),
    );
  }

  Widget buildTransacaoItem(Transacao transacao) {
    String dataFormatada =
        "${transacao.data.day.toString().padLeft(2, '0')}-${transacao.data.month.toString().padLeft(2, '0')}-${transacao.data.year}";

    String valorFormatado = transacao.valor.toStringAsFixed(2);

    return ListTile(
      title: Text(transacao.descricao),
      subtitle: Text(
        dataFormatada,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'R\$ $valorFormatado',
            style: TextStyle(
              color: transacao.valor >= 0 ? Colors.green : Colors.red,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              onRemoveTransaction(transacao);
            },
          ),
        ],
      ),
      tileColor: transacao.valor >= 0 ? Colors.green[50] : Colors.red[50],
      onTap: () {

      },
    );
  }

  Widget buildTransacaoList(List<Transacao> transacoes) {
    return ListView.builder(
      itemCount: transacoes.length,
      itemBuilder: (context, index) {
        return Card(
          child: buildTransacaoItem(transacoes[index]),
        );
      },
    );
  }
}





