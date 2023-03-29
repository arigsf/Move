import 'package:flutter/material.dart';
import 'package:move/modules/profissionais/pages/detalhes_profissional_page.dart';
import 'package:move/modules/profissionais/pages/favoritos.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/modules/usuario/repositories/auth_service.dart';
import 'package:move/shared/models/profissional.dart';
import 'package:provider/provider.dart';

class PesquisarPage extends StatefulWidget {
  const PesquisarPage({super.key});

  @override
  State<PesquisarPage> createState() => _PesquisarPageState();
}

class _PesquisarPageState extends State<PesquisarPage> {
  List<Profissional> pesquisa = [];
  var isPesquisa = false;
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
  List<String> selecionadas = [];

  pesquisarProfissional(String value, List<Profissional> profissionais) {
    setState(() {
      isPesquisa = true;
      if (value.isEmpty) {
        isPesquisa = false;
      }

      if (pesquisa.isEmpty) {
        pesquisa = profissionais
            .where((element) =>
                element.nome!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        pesquisa = pesquisa
            .where((element) =>
                element.nome!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  categoriaProfissional(List<Profissional> profissionais) {
    isPesquisa = true;
    if (selecionadas.isEmpty) {
      isPesquisa = false;
    }

    if (pesquisa.isEmpty) {
      if (selecionadas.isNotEmpty) {
        for (Profissional profissional in profissionais) {
          for (String categoria in selecionadas) {
            if (profissional.categoria.toLowerCase() ==
                categoria.toLowerCase()) {
              pesquisa.add(profissional);
            }
          }
        }
      }
    } else {
      if (selecionadas.isNotEmpty) {
        List<Profissional> auxiliar = [];
        for (Profissional profissional in pesquisa) {
          for (String categoria in selecionadas) {
            if (profissional.categoria.toLowerCase() ==
                categoria.toLowerCase()) {
              auxiliar.add(profissional);
            }
          }
        }
        pesquisa = auxiliar;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Profissional> profissionais =
        context.read<ProfissionalRepository>().todos;
    var isLoading = context.watch<ProfissionalRepository>().isLoading;

    if (isLoading == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pesquisar'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoritosPage(),
                    ),
                  );
                },
                icon: Icon(Icons.bookmark))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                onChanged: (value) =>
                    pesquisarProfissional(value, profissionais),
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  hintText: "Encontre um profissional perto de você...",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Wrap(
                spacing: 5,
                children: [
                  for (String categoria in categorias)
                    FilterChip(
                        label: Text(categoria),
                        selected: selecionadas.contains(categoria),
                        selectedColor: Colors.indigo[50],
                        shadowColor: Colors.indigo[50],
                        backgroundColor: Colors.indigo[50],
                        surfaceTintColor: Colors.indigo[50],
                        selectedShadowColor: Colors.indigo[50],
                        onSelected: (bool value) {
                          setState(() {
                            (selecionadas.contains(categoria))
                                ? selecionadas.remove(categoria)
                                : selecionadas.add(categoria);
                          });
                          categoriaProfissional(profissionais);
                        }),
                ],
              ),
            ),
            (isPesquisa && pesquisa.isEmpty)
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Nenhum profissional encontrado!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Center(),
            (profissionais.isEmpty)
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Nenhum profissional encontrado!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount:
                          (isPesquisa) ? pesquisa.length : profissionais.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            leading: ClipOval(
                              child: Image.network(
                                (isPesquisa)
                                    ? pesquisa[index].foto.toString()
                                    : profissionais[index].foto.toString(),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                            title: Text(
                              (isPesquisa)
                                  ? pesquisa[index].nome.toString()
                                  : profissionais[index].nome.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text((isPesquisa)
                                  ? pesquisa[index].categoria.toString()
                                  : profissionais[index].categoria.toString()),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesProfissionalPage(
                                      profissional: profissionais[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Procurar'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
