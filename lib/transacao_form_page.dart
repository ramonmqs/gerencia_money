import 'package:flutter/material.dart';

class TransacaoFormPage extends StatefulWidget {
  final String tipo;
  final Function(String, double, DateTime) onSubmit;

  TransacaoFormPage({required this.tipo, required this.onSubmit});

  @override
  _TransacaoFormPageState createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _descricao = '';
  double _valor = 0.0;
  DateTime _data = DateTime.now();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onSubmit(_descricao, _valor, _data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar ${widget.tipo}'),
        backgroundColor: widget.tipo == 'Despesa' ? Colors.red :
        Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, insira a descrição';
                }
                return null;
              },
              onSaved: (value) {
                _descricao = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor'),
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

