import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/modules/usuario/repositories/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var isProfissional = context.watch<ProfissionalRepository>().isProfissional;
    var usuario = context.watch<AuthService>().usuario;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
      ),
      body: Column(
        children: [
          Text("Bem-vindo, ${usuario!.displayName}",),
        ],
      ),
    );
  }
}
