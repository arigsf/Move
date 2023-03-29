import 'package:flutter/material.dart';
import 'package:move/core/app.dart';
import 'package:move/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:move/modules/profissionais/repositories/profissional_repository.dart';
import 'package:move/modules/usuario/repositories/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProfissionalRepository(auth: context.read<AuthService>())),
      ],
      child: const MyApp(),
    ),
  );
}
