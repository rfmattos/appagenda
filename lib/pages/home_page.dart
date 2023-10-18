import 'dart:io';
import 'package:appagenda/model/contato_model.dart';
import 'package:appagenda/pages/contato_page.dart';
import 'package:appagenda/repository/back4app/contato_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String titulo = "Agenda";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoRepository contatoRepository = ContatoRepository();
  var carregando = false;
  int tamanhoDaLista = 0;
  var _listaContatos = ContatosModel([]);
  static String get notfoto => "lib/imagens/notfoto.png";

  @override
  void initState() {
    super.initState();
    oberDados();
  }

  void oberDados() async {
    setState(() {
      carregando = true;
    });
    _listaContatos = await contatoRepository.obter();
    tamanhoDaLista = _listaContatos.contatos.length;
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Column(
        children: [
          carregando
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: tamanhoDaLista,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:
                              _listaContatos.contatos[index].foto.isNotEmpty
                                  ? Image.file(
                                      File(_listaContatos.contatos[index].foto),
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.asset(
                                      notfoto,
                                      width: 100,
                                      height: 100,
                                    ),
                          title: Text(_listaContatos.contatos[index].nome,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nascimento: ${_listaContatos.contatos[index].datanascimento}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "Telefone: ${_listaContatos.contatos[index].telefone}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ]),
                          trailing: PopupMenuButton<String>(
                            onSelected: (menu) async {
                              if (menu == "delete") {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text("Atenção!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600)),
                                        content: Text(
                                            "Deseja remover o contato: ${_listaContatos.contatos[index].nome}?",
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        actions: [
                                          TextButton(
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.grey),
                                              ),
                                              onPressed: () async {
                                                await contatoRepository.remover(
                                                    _listaContatos
                                                        .contatos[index]
                                                        .objectId);
                                                oberDados();
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Sim",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          TextButton(
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.grey),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Não",
                                                  style: TextStyle(
                                                      color: Colors.white)))
                                        ],
                                      );
                                    });
                              } else if (menu == "edit") {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContatoPage(
                                            alteracao: true,
                                            umContatoModel: _listaContatos
                                                .contatos[index])));
                                if (result != null) {
                                  oberDados();
                                  setState(() {});
                                }
                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                    value: "edit", child: Text("Alterar")),
                                PopupMenuItem<String>(
                                    value: "delete", child: Text("Excluir")),
                              ];
                            },
                          ),
                        );
                      }),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContatoPage(
                      alteracao: false,
                      umContatoModel: _listaContatos.contatos[0])));
          if (result != null) {
            oberDados();
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
