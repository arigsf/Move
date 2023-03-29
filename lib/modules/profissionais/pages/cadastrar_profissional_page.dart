import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/modules/usuario/pages/perfil_page.dart';
import 'package:move/shared/models/profissional.dart';
import 'package:provider/provider.dart';

class CadastrarProfissionalPage extends StatefulWidget {
  const CadastrarProfissionalPage({super.key});

  @override
  State<CadastrarProfissionalPage> createState() =>
      _CadastrarProfissionalPageState();
}

class _CadastrarProfissionalPageState extends State<CadastrarProfissionalPage> {
  List<String> categorias = [
    "Academia",
    "Clube",
    "Comida saudável",
    "Crossfit",
    "Esporte",
    "Fisioterapia",
    "Nutrição",
    "Personal"
  ];

  final formKey = GlobalKey<FormState>();
  final rua = TextEditingController();
  final numero = TextEditingController();
  final bairro = TextEditingController();
  final complemento = TextEditingController();
  final cidade = TextEditingController();
  final estado = TextEditingController();
  final telefone = TextEditingController();
  final categoria = TextEditingController();
  bool loading = false;

  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      cadastrar(posicao.latitude, posicao.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error(
          "A Move utiliza a sua localização para mostrar aos usuários mais próximos de você o seu perfil profissional. Por favor, habilite a localização no seu smartphone.");
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        return Future.error(
            "A Move utiliza a sua localização para mostrar aos usuários mais próximos de você o seu perfil profissional. Por favor, autorize o acesso a sua localização.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  cadastrar(double latitude, double longitude) async {
    setState(() => loading = true);
    try {
      await context.read<ProfissionalRepository>().cadastrar(Profissional(
          rua: rua.text,
          numero: int.parse(numero.text),
          bairro: bairro.text,
          complemento: complemento.text,
          cidade: cidade.text,
          estado: estado.text,
          telefone: telefone.text,
          categoria: categoria.text,
          latitude: latitude,
          longitude: longitude));
      setState(() => loading = false);
      Navigator.of(context)
          .pop(MaterialPageRoute(builder: (context) => const PerfilPage()));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Mudança realizada com sucesso! Você entrou para o time profissional da Move!"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Time profissional Move',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Movimente você também',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Sua localização'),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: rua,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rua',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe a rua do seu endereço.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: numero,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Número',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o número do seu endereço.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: bairro,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bairro',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o bairro do seu endereço.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: complemento,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Complemento',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o complemento do seu endereço.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: cidade,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cidade',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe a cidade do seu endereço.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: estado,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Estado',
                    ),
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o estado do seu endereço.';
                      } else if (value.length > 2) {
                        return 'Informe a sigla do estado.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ListTile(
                    leading: Icon(Icons.contact_page),
                    title: Text('Seu contato'),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: telefone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefone',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe seu telefone.';
                      }
                      return null;
                    },
                  ),
                ),                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Sua categoria'),
                    subtitle: Text('Categorias válidas: Academia, Clube, Comida saudável, Crossfit, Esporte, Fisioterapia, Nutrição, Personal'),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: categoria,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Categoria',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe sua categoria.';
                      } else if (!categorias.contains(value)) {
                        return 'Informe uma categoria válida.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        getPosicao();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              Icon(Icons.check),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Cadastrar',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(MaterialPageRoute(
                        builder: (context) => const PerfilPage()));
                    Navigator.of(context).pop();
                  },
                  child: Text('Quero continuar com minha conta pessoal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
