class ContatosModel {
  List<UmContatoModel> contatos = [];

  ContatosModel(this.contatos);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <UmContatoModel>[];
      json['results'].forEach((v) {
        contatos.add(UmContatoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contatos.map((v) => v.toJson()).toList();
    return data;
  }
}

class UmContatoModel {
  String objectId = "";
  String createdAt = "";
  String updatedAt = "";
  String nome = "";
  String datanascimento = "";
  String telefone = "";
  String foto = "";

  UmContatoModel(this.objectId, this.createdAt, this.updatedAt, this.nome,
      this.datanascimento, this.telefone, this.foto);

  UmContatoModel.criar(
      this.nome, this.datanascimento, this.telefone, this.foto);

  UmContatoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    nome = json['nome'];
    datanascimento = json['datanascimento'];
    telefone = json['telefone'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['nome'] = nome;
    data['datanascimento'] = datanascimento;
    data['telefone'] = telefone;
    data['foto'] = foto;

    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['datanascimento'] = datanascimento;
    data['telefone'] = telefone;
    data['foto'] = foto;
    return data;
  }
}
