import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colecciones/usuario.dart';
import '../services/firebase_user_service.dart';
import '../providers/content_provider.dart';

class UserProvider extends ChangeNotifier {
  final _service = UserService();
  Usuario? _usuario;
  bool _isLoaded = false;

  Usuario? getUsuario() => _usuario;
  bool get isLoaded => _isLoaded;

  Future<void> refresh() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (_usuario != null) {
      notifyListeners();
      return;
    }

    _usuario = await _service.getUserData(uid);
    _isLoaded = true;
    debugPrint("USUARIO LEIDO: ${_usuario?.nombre}");

    notifyListeners();
  }

  Future<void> refreshProgress(ContentProvider contentProvider) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Verifica y genera progreso si no existe
    await _service.checkAndInitializeProgress(uid, contentProvider);

    notifyListeners();
  }

  /// Limpia el caché (por ejemplo, si el usuario cierra sesión)
  void clearCache() {
    _usuario = null;
    notifyListeners();
  }
}
