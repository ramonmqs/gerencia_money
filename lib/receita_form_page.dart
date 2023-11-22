import 'package:flutter/material.dart';

class ReceitaFormPage extends StatefulWidget {
  final Function(String, double, DateTime) onSubmit;

  ReceitaFormPage({required this.onSubmit});

  @override
  _ReceitaFormPageState createState() => _ReceitaFormPageState();
}

class _ReceitaFormPageState extends State<ReceitaFormPage> {
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
        title: Text('Cadastrar Receita'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Descrição da Receita'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor, insira a descrição da receita';
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
