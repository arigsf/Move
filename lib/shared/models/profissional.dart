import 'package:firebase_auth/firebase_auth.dart';

class Profissional {
  String? id;
  String? nome;
  String? foto;
  String rua;
  int numero;
  String bairro;
  String? complemento;
  String cidade;
  String estado;
  String telefone;
  String categoria;
  double? latitude;
  double? longitude;

  Profissional({
    this.id,
    this.nome,
    this.foto,
    required this.rua,
    required this.numero,
    required this.bairro,
    this.complemento,
    required this.cidade,
    required this.estado,
    required this.telefone,
    required this.categoria,
    this.latitude,
    this.longitude,
  });
}