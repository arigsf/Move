import 'package:flutter/material.dart';
import 'package:move/modules/chat/pages/chat_page.dart';
import 'package:move/modules/espaco/pages/mapa_page.dart';
import 'package:move/modules/home/pages/home_page.dart';
import 'package:move/modules/profissionais/pages/pesquisar_page.dart';
import 'package:move/modules/usuario/pages/perfil_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int page = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: page);
  }

  setPaginaAtual(newPage) {
    setState(() {
      page = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: const [
          HomePage(),
          MapaPage(),
          PesquisarPage(),
          ChatPage(),
          PerfilPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: page,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisar'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Perfil'),
        ],
        backgroundColor: Colors.grey[100],
        onTap: (newPage) {
          pc.animateToPage(
            newPage,
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
