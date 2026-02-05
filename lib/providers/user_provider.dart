import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../colecciones/usuario.dart';
import '../services/firebase_user_service.dart';
import '../providers/content_provider.dart';

/// Provider que maneja el estado global de los datos del [Usuario].
class UserProvider extends ChangeNotifier {
  final _service = UserService();
  Usuario? _usuario;
  bool _isLoadedData = false;
  bool _isLoadedProgress = false;

  Usuario? getUsuario() => _usuario;
  bool get isLoadedData => _isLoadedData;
  bool get isLoadedProgress => _isLoadedProgress;

  /// Carga en memoria los datos del usuario.
  /// Si los datos ya han sido cargados solo notifica.
  Future<void> refresh() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (_usuario != null) {
      notifyListeners();
      return;
    }

    _usuario = await _service.getUserData(uid);
    _isLoadedData = true;
    debugPrint("USUARIO LEIDO: ${_usuario?.nombre}");

    notifyListeners();
  }

  /// Carga en memoria el progreso del usuario, obtenido desde Firestore.
  /// Si no tiene progreso, lo inicializa.
  Future<void> refreshProgress(ContentProvider contentProvider) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    debugPrint("GET USUARIOS getUserData");

    final data = userDoc.data();
    if (data == null) {
      final userService = UserService();
      final currentUser = FirebaseAuth.instance.currentUser!;

      await userService.updatePersonalInfo(uid, '', '', currentUser.email!);
      debugPrint("USUARIO REGISTRADO: ${currentUser.email}");
    }

    // Verifica y genera progreso si no existe
    await _service.checkAndInitializeProgress(uid, contentProvider);

    _isLoadedProgress = true;
    notifyListeners();
  }

  /// Limpia el caché.
  /// Se ejecuta el cerrar sesión.
  void clearCache() {
    _usuario = null;
    notifyListeners();
  }
}
