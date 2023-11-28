import 'package:flutter/material.dart';

class DespesaFormPage extends StatefulWidget {
  final Function(String, double, DateTime) onSubmit;

  DespesaFormPage({required this.onSubmit});

  @override
  _DespesaFormPageState createState() => _DespesaFormPageState();
}

class _DespesaFormPageState extends State<DespesaFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _descricao = '';
  double _valor = 0.0;
  DateTime _data = DateTime.now();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onSubmit(_descricao, -_valor, _data);

      // Exibir SnackBar ao cadastrar a despesa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Despesa cadastrada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Despesa'),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Descrição do gasto'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, insira a descrição do gasto';
                }
                return null;
              },
              onSaved: (value) {
                _descricao = value ?? '';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, insira o valor';
                }
                return null;
              },
              onSaved: (value) {
                _valor = double.parse(value ?? '0');
              },
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
