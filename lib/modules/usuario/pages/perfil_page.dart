import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move/modules/profissionais/pages/cadastrar_profissional_page.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/modules/usuario/repositories/auth_service.dart';
import 'package:move/shared/models/profissional.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final nome = TextEditingController();
  bool loading = false;

  pegarImagemGaleria(User? usuario) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      if (usuario!.photoURL.toString() ==
          "https://firebasestorage.googleapis.com/v0/b/move-e517a.appspot.com/o/images%2Fmove.png?alt=media&token=0b4b6151-596d-4b9b-8194-d2bf64eb71f8") {
        String id = DateTime.now().millisecondsSinceEpoch.toString();

        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload = referenceDirImages.child(id);

        try {
          await referenceImageToUpload.putFile(File(file.path));
          String url = await referenceImageToUpload.getDownloadURL();
          editarImagem(url);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()), backgroundColor: Colors.red));
        }
      } else {
        Reference referenceImageToUpload =
            FirebaseStorage.instance.refFromURL(usuario.photoURL.toString());

        try {
          await referenceImageToUpload.putFile(File(file.path));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foto alterada com sucesso!"),
              backgroundColor: Colors.green));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()), backgroundColor: Colors.red));
        }
      }
    }
  }

  editarImagem(String url) async {
    try {
      await context.read<AuthService>().editarImagem(url);
      Profissional? profissional = await context
          .read<ProfissionalRepository>()
          .buscarPeloId(context.read<AuthService>().usuario!.uid);
      if (profissional != null) {
        profissional.foto = url;
        context.read<ProfissionalRepository>().atualizar(profissional);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Foto alterada com sucesso!"),
          backgroundColor: Colors.green));
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red));
    }
  }

  editarNome() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().editarNome(nome.text);
      Profissional? profissional = await context
          .read<ProfissionalRepository>()
          .buscarPeloId(context.read<AuthService>().usuario!.uid);
      if (profissional != null) {
        profissional.nome = nome.text;
        context.read<ProfissionalRepository>().atualizar(profissional);
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Nome alterado com sucesso!"),
          backgroundColor: Colors.green));
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red));
    }
  }

  editarSenha() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().editarSenha(senha.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Senha alterada com sucesso!"),
          backgroundColor: Colors.green));
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red));
    }
  }

  removerProfissional() async {
    setState(() => loading = true);
    try {
      await context.read<ProfissionalRepository>().remover();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Mudança realizada com sucesso! Você agora faz parte do pessoal da Move!"),
          backgroundColor: Colors.green));
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    var isProfissional = context.watch<ProfissionalRepository>().isProfissional;
    var isLoading = context.watch<ProfissionalRepository>().isLoading;
    User? usuario = context.watch<AuthService>().usuario;

    if (isLoading == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
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
                              usuario!.photoURL.toString(),
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
                          usuario.displayName.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: (isProfissional)
                              ? Text(
                                  'Profissional',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )
                              : Text(
                                  'Pessoal',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Minha conta'),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Alterar nome'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Alterar nome'),
                                    content: Form(
                                      key: formKey,
                                      child: TextFormField(
                                        controller: nome,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Nome',
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Informa um nome';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, null),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            editarNome();
                                            Navigator.pop(context, null);
                                            Navigator.pop(context, null);
                                          }
                                        },
                                        child: const Text('Salvar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ListTile(
                                leading: Icon(Icons.lock),
                                title: Text('Alterar senha'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Alterar senha'),
                                      content: Form(
                                        key: formKey,
                                        child: TextFormField(
                                          controller: senha,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Senha',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Informa uma senha';
                                            } else if (value.length < 6) {
                                              return 'Sua senha deve ter no mínimo 6 caracteres';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, null),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              editarSenha();
                                              Navigator.pop(context, null);
                                              Navigator.pop(context, null);
                                            }
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            (isProfissional)
                                ? ListTile(
                                    leading: Icon(Icons.change_circle),
                                    title: Text('Mudar para conta pessoal'),
                                    onTap: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Mudança de conta'),
                                          content: const Text(
                                              'Sua conta está cadastrada como profissional. Se você mudar para conta pessoal, não ficará mais disponível para visualização. Você tem certeza de que deseja mudar para conta pessoal?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () =>
                                                  Navigator.pop(context, null),
                                            ),
                                            TextButton(
                                                child: const Text('Continuar'),
                                                onPressed: () {
                                                  removerProfissional();
                                                  Navigator.pop(context, null);
                                                  Navigator.pop(context, null);
                                                }),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : ListTile(
                                    leading: Icon(Icons.change_circle),
                                    title:
                                        Text('Mudar para conta profissional'),
                                    onTap: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Mudança de conta'),
                                          content: const Text(
                                              'Se você é um clube, uma academia, um personal, um educador físico ou exerce uma função relacionada ao mundo esportivo, você pode ter uma conta profissional. Por meio dela, seu perfil ficará visível aos usuários, que podem entrar em contato com você em busca de informações sobre o seu serviço. Você tem certeza de que deseja mudar sua conta para profissional?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () =>
                                                  Navigator.pop(context, null),
                                            ),
                                            TextButton(
                                                child: const Text('Continuar'),
                                                onPressed: () {
                                                  Navigator.pop(context, null);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CadastrarProfissionalPage()),
                                                  );
                                                }),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Minha foto de perfil'),
              onTap: () {
                pegarImagemGaleria(usuario);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Sair'),
                    content: const Text('Você tem certeza de que deseja sair?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => context.read<AuthService>().logout(),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
