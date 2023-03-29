import 'package:flutter/material.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/shared/models/profissional.dart';
import 'package:provider/provider.dart';

class DetalhesProfissionalPage extends StatefulWidget {
  Profissional profissional;
  DetalhesProfissionalPage({super.key, required this.profissional});

  @override
  State<DetalhesProfissionalPage> createState() =>
      _DetalhesProfissionalPageState();
}

class _DetalhesProfissionalPageState extends State<DetalhesProfissionalPage> {
  @override
  Widget build(BuildContext context) {
    var isFavorito = false;
    List<Profissional> favoritos =
        context.watch<ProfissionalRepository>().favoritos;
    for (Profissional profissional in favoritos) {
      if (profissional.id == widget.profissional.id) {
        isFavorito = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ClipOval(
                            child: Image.network(
                                widget.profissional.foto.toString(),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                          ),
                      ),
                      Text(
                        widget.profissional.nome.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Profissional',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text(widget.profissional.categoria),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(
                '${widget.profissional.rua}, ${widget.profissional.numero}. ${widget.profissional.complemento}. ${widget.profissional.bairro}. ${widget.profissional.cidade} - ${widget.profissional.estado}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(widget.profissional.telefone),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (isFavorito)
          ? FloatingActionButton(
              onPressed: () {
                try {
                  context
                      .read<ProfissionalRepository>()
                      .desfavoritar(widget.profissional.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Profissional removido dos favoritos com sucesso!"),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.bookmark_remove),
            )
          : FloatingActionButton(
              onPressed: () {
                try {
                  context
                      .read<ProfissionalRepository>()
                      .favoritar(widget.profissional.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Profissional favoritado com sucesso!"),
                    backgroundColor: Colors.green,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.bookmark_add),
            ),
    );
  }
}
