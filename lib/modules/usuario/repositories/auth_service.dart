import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String senha, String nome) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      usuario!.updateDisplayName(nome);
      usuario!.updatePhotoURL(
          "https://firebasestorage.googleapis.com/v0/b/move-e517a.appspot.com/o/images%2Fmove.png?alt=media&token=0b4b6151-596d-4b9b-8194-d2bf64eb71f8");
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado!');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email/senha incorretos!');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Email/senha incorretos');
      } else if (e.code == 'too-many-requests') {
        throw AuthException(
            'O acesso a esta conta foi temporariamente desativado, em virtude das várias tentativas de login mal-sucedidas. Redefina sua senha ou tente novamente mais tarde!');
      }
    }
  }

  editarNome(String nome) async {
    try {
      await usuario!.updateDisplayName(nome);
      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  editarImagem(String url) async {
    try {
      await usuario!.updatePhotoURL(url);
      _getUser();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  editarSenha(String senha) async {
    try {
      await usuario!.updatePassword(senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(
            'Você precisa fazer um login recente para alterar a sua senha!');
      } else {
        throw AuthException('Erro: ${e.code}');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
