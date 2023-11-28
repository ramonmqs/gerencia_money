import 'package:flutter/material.dart';
import 'transacao_helper.dart';

class DespesasPage extends StatelessWidget {
  final List<Transacao> despesas;
  final Function(Transacao) onRemoveTransaction;

  const DespesasPage({Key? key, required this.despesas, required this.onRemoveTransaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas'),
      ),
      body: buildTransacaoList(despesas),
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
        style: TextStyle(
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
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              // Chame a função de remoção passada por meio do construtor
              onRemoveTransaction(transacao);
            },
          ),
        ],
      ),
      tileColor: transacao.valor >= 0 ? Colors.green[50] : Colors.red[50],
      onTap: () {
        // Adicione aqui a lógica para exibir detalhes da transação, se necessário
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




