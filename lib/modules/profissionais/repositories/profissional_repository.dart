import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move/database/db_firestore.dart';
import 'package:move/modules/usuario/repositories/auth_service.dart';
import 'package:move/shared/models/profissional.dart';

class ProfissionalRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  final List<Profissional> todos = [];
  final List<Profissional> favoritos = [];
  var isProfissional = false;
  bool isLoading = true;

  ProfissionalRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await listarTodos();
    await listarFavoritos();
    await verificarProfissional();
    isLoading = false;
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  listarTodos() async {
    todos.clear();
    try {
      final snapshot = await db.collection("profissionais").get();
      for (var doc in snapshot.docs) {
        Profissional profissional = Profissional(
          id: doc.data()['id'],
          nome: doc.data()['nome'],
          foto: doc.data()['foto'],
          rua: doc.data()['rua'],
          numero: doc.data()['numero'],
          bairro: doc.data()['bairro'],
          complemento: doc.data()['complemento'],
          cidade: doc.data()['cidade'],
          estado: doc.data()['estado'],
          telefone: doc.data()['telefone'],
          categoria: doc.data()['categoria'],
          latitude: doc.data()['latitude'],
          longitude: doc.data()['longitude'],
        );
        todos.add(profissional);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  listarFavoritos() async {
    favoritos.clear();
    try {
      final snapshot = await db
          .collection("usuarios")
          .doc(auth.usuario!.uid)
          .collection("favoritos")
          .get();
      for (var doc in snapshot.docs) {
        Profissional? profissional = await buscarPeloId(doc.data()['id']);
        if (profissional != null) {
          favoritos.add(profissional);
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Profissional?> buscarPeloId(String id) async {
    try {
      final doc = await db.collection("profissionais").doc(id.toString()).get();
      Profissional profissional = Profissional(
          id: doc.data()!['id'],
          nome: doc.data()!['nome'],
          foto: doc.data()!['foto'],
          rua: doc.data()!['rua'],
          numero: doc.data()!['numero'],
          bairro: doc.data()!['bairro'],
          complemento: doc.data()!['complemento'],
          cidade: doc.data()!['cidade'],
          estado: doc.data()!['estado'],
          telefone: doc.data()!['telefone'],
          categoria: doc.data()!['categoria'],
          latitude: doc.data()!['latitude'],
          longitude: doc.data()!['longitude'],
      );
      return profissional;
    } catch (e) {
      print(e);
      return null;
    }
  }

  cadastrar(Profissional profissional) async {
    await db.collection("profissionais").doc(auth.usuario!.uid).set({
      'id': auth.usuario!.uid,
      'nome': auth.usuario!.displayName,
      'foto': auth.usuario!.photoURL,
      'rua': profissional.rua,
      'numero': profissional.numero,
      'bairro': profissional.bairro,
      'complemento': profissional.complemento,
      'cidade': profissional.cidade,
      'estado': profissional.estado,
      'telefone': profissional.telefone,
      'categoria': profissional.categoria,
      'latitude': profissional.latitude,
      'longitude': profissional.longitude,
    });
    await verificarProfissional();
    await listarTodos();
    notifyListeners();
  }

  atualizar(Profissional profissional) async {
    await db.collection("profissionais").doc(auth.usuario!.uid).update({
      'id': auth.usuario!.uid,
      'nome': auth.usuario!.displayName,
      'foto': auth.usuario!.photoURL,
      'rua': profissional.rua,
      'numero': profissional.numero,
      'bairro': profissional.bairro,
      'complemento': profissional.complemento,
      'cidade': profissional.cidade,
      'estado': profissional.estado,
      'telefone': profissional.telefone,
      'categoria': profissional.categoria,
      'latitude': profissional.latitude,
      'longitude': profissional.longitude,
    });
    await listarTodos();
    notifyListeners();
  }

  remover() async {
    await db.collection("profissionais").doc(auth.usuario!.uid).delete();
    await verificarProfissional();
    await listarTodos();
    notifyListeners();
  }

  favoritar(String id) async {
    await db
        .collection("usuarios")
        .doc(auth.usuario!.uid)
        .collection("favoritos")
        .doc(id.toString())
        .set({
      'id': id,
    });
    await listarFavoritos();
    notifyListeners();
  }

  desfavoritar(String id) async {
    await db
        .collection("usuarios")
        .doc(auth.usuario!.uid)
        .collection("favoritos")
        .doc(id.toString())
        .delete();
    await listarFavoritos();
    notifyListeners();
  }

  verificarProfissional() async {
    final snapshot =
        await db.collection("profissionais").doc(auth.usuario!.uid).get();
    if (snapshot.data() != null) {
      isProfissional = true;
    } else {
      isProfissional = false;
    }
    notifyListeners();
  }
}
