import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colecciones/usuario.dart';
import '../services/firebase_user_service.dart';

class UserProvider extends ChangeNotifier {
  final _service = UserService();
  Usuario? _usuario;
  bool _isLoaded = false;

  Usuario? get usuario => _usuario;
  bool get isLoaded => _isLoaded;

  Future<void> refresh() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Carga inicial (solo una vez)
    _usuario = await _service.getUserData(uid);
    _isLoaded = true;
    debugPrint("USUARIO LEIDO: ${_usuario?.nombre}");
    notifyListeners();
  }
}
