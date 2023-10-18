import 'package:appagenda/model/contato_model.dart';
import 'package:appagenda/repository/back4app/back4app_custon_dio.dart';

class ContatoRepository {
  final _custonDio = Back4AppCustonDio();

  ContatoRepository();

  Future<ContatosModel> obter() async {
    var url = "/contato";
    var result = await _custonDio.dio.get(url);
    return ContatosModel.fromJson(result.data);
  }

  Future<ContatosModel> obterUmCep(String objectId) async {
    var url = "/contato?where={\"objectId\":\"$objectId\"}";
    var result = await _custonDio.dio.get(url);
    return ContatosModel.fromJson(result.data);
  }

  Future<void> criar(UmContatoModel contatoModel) async {
    try {
      await _custonDio.dio.post("/contato", data: contatoModel.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizar(UmContatoModel contatoModel) async {
    try {
      await _custonDio.dio.put("/contato/${contatoModel.objectId}",
          data: contatoModel.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _custonDio.dio.delete("/contato/${objectId}");
    } catch (e) {
      throw e;
    }
  }
}
