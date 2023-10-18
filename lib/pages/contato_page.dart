import 'package:appagenda/model/contato_model.dart';
import 'package:appagenda/pages/home_page.dart';
import 'package:appagenda/repository/back4app/contato_repository.dart';
import 'package:appagenda/shared/widgets/text_label.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'dart:io';

class ContatoPage extends StatefulWidget {
  final bool alteracao;
  final UmContatoModel umContatoModel;
  const ContatoPage(
      {super.key, required this.alteracao, required this.umContatoModel});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  var nomeController = TextEditingController(text: "");
  var dataNascimentoController = TextEditingController(text: "");
  var fotoController = TextEditingController(text: "");
  var telefoneController = TextEditingController(text: "");
  String pathfoto = "";
  ContatoRepository contatoRepository = ContatoRepository();
  XFile? photo;
  static String get notfoto => "lib/imagens/notfoto.png";
  bool salvando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.alteracao) {
      nomeController.text = widget.umContatoModel.nome;
      dataNascimentoController.text = widget.umContatoModel.datanascimento;
      fotoController.text = widget.umContatoModel.foto;
      telefoneController.text = widget.umContatoModel.telefone;
      pathfoto = widget.umContatoModel.foto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("Contato")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextLabel(texto: "Nome:"),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(hintText: "Nome Usuario"),
                controller: nomeController,
              )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextLabel(texto: "Data de Nascimento:"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: dataNascimentoController,
              readOnly: true,
              onTap: () async {
                var data = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910, 1, 1),
                    lastDate: DateTime.now());
                if (data != null) {
                  //  dataNascimentoController.text = data.toString();
                  dataNascimentoController.text =
                      DateFormat("dd/MM/yyyy").format(data);
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextLabel(texto: "Telefone:"),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Telefone"),
                controller: telefoneController,
              )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextLabel(texto: "Foto:"),
          ),
          pathfoto.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.file(
                    File(pathfoto),
                    width: 100,
                    height: 100,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    notfoto,
                    width: 100,
                    height: 100,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text("Camera"),
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                photo = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (photo != null) {
                                  String path = (await path_provider
                                          .getApplicationDocumentsDirectory())
                                      .path;
                                  String name = basename(photo!.path);
                                  await photo!.saveTo("$path/$name");
                                  await GallerySaver.saveImage(photo!.path);
                                  if (photo != null) {
                                    pathfoto = photo!.path;
                                  } else {
                                    pathfoto = "";
                                  }
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.edit_document),
                              title: const Text("Galeria"),
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                photo = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (photo != null) {
                                  pathfoto = photo!.path;
                                } else {
                                  pathfoto = "";
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                            )
                          ],
                        );
                      });
                },
                child: const Text(
                  "Inserir foto",
                  style: TextStyle(color: Colors.black),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.lightBlueAccent),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.black),
                  )),
              const SizedBox(width: 40),
              TextButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.lightBlueAccent),
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (nomeController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Atenção!",
                                  style: TextStyle(color: Colors.red)),
                              content: const Text("Nome inválido!",
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                              actions: [
                                TextButton(
                                    style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.grey),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            );
                          });
                      return;
                    }
                    if (widget.alteracao) {
                      widget.umContatoModel.nome = nomeController.text;
                      widget.umContatoModel.datanascimento =
                          dataNascimentoController.text;
                      widget.umContatoModel.telefone = telefoneController.text;
                      widget.umContatoModel.foto = pathfoto;
                      await contatoRepository.atualizar(widget.umContatoModel);
                    } else {
                      await contatoRepository.criar(UmContatoModel.criar(
                          nomeController.text,
                          dataNascimentoController.text,
                          telefoneController.text,
                          pathfoto));
                    }
                    Navigator.pop(context, "OK");
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
