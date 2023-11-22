import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final List<String> subcategorias;

  Categoria({required this.nome, required this.subcategorias});
}

class CategoriasPage extends StatefulWidget {
  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  List<Categoria> categorias = [
    Categoria(nome: 'Alimentação', subcategorias: ['Restaurante', 'Supermercado']),
    Categoria(nome: 'Transporte', subcategorias: ['Ônibus', 'Combustível']),
    // Adicione mais categorias aqui
  ];

  void _criarCategoria() {
    // Aqui você pode adicionar a lógica para criar uma nova categoria
  }

  void _criarSubcategoria(Categoria categoria) {
    // Aqui você pode adicionar a lógica para criar uma nova subcategoria
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
      ),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categorias[index].nome),
            subtitle: Text(categorias[index].subcategorias.join(', ')),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _criarSubcategoria(categorias[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _criarCategoria,
      ),
    );
  }
}
