import 'package:flutter/material.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/shared/models/profissional.dart';
import 'package:provider/provider.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  @override
  Widget build(BuildContext context) {
    List<Profissional> favoritos =
        context.watch<ProfissionalRepository>().favoritos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: (favoritos.length != 0)
          ? ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(favoritos[index].foto.toString()),
                        ),
                      ),
                    ),
                    title: Text(
                      favoritos[index].nome.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(favoritos[index].categoria.toString()),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.bookmark_remove),
                      onPressed: () {
                        context
                            .read<ProfissionalRepository>()
                            .desfavoritar(favoritos[index].id.toString());
                      },
                    ),
                  ),
                );
              },
              padding: const EdgeInsets.all(16),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                      child: Text(
                    "Nenhum profissional favoritado!",
                    style: TextStyle(fontSize: 16),
                  )),
                ),
              ],
            ),
    );
  }
}
