import 'package:shared_preferences/shared_preferences.dart';

class Transacao {
  final String descricao;
  final double valor;
  final DateTime data;

  Transacao({required this.descricao, required this.valor, required this.data});
}

class TransacaoHelper {
  static const String chaveTransacoes = 'transacoes';

  static Future<List<Transacao>> carregarTransacoes() async {
    final prefs = await SharedPreferences.getInstance();
    final transacoesString = prefs.getStringList(chaveTransacoes) ?? [];

    List<Transacao> transacoes = transacoesString.map((transacaoString) {
      List<String> partes = transacaoString.split(',');
      String descricao = partes[0];
      double valor = double.parse(partes[1]);
      DateTime data = DateTime.parse(partes[2]);

      return Transacao(descricao: descricao, valor: valor, data: data);
    }).toList();

    return transacoes;
  }

  static Future<void> salvarTransacoes(List<Transacao> transacoes) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> transacoesString = transacoes.map((transacao) {
      return '${transacao.descricao},${transacao.valor},${transacao.data.toIso8601String()}';
    }).toList();

    await prefs.setStringList(chaveTransacoes, transacoesString);
  }
}
