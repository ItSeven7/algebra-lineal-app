import 'package:flutter/material.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:quickalert/quickalert.dart';

import '../colecciones/usuarios.dart';
import '../models/text_styles.dart';
import '../widgets/forms.dart';
import '../widgets/buttons.dart';
import '../services/firebase_user_service.dart';

UserService userService = UserService();
Usuario? usuario;
bool complete = true;

final TextEditingController _nameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Icon(Icons.account_circle_rounded, size: 160)),
            SizedBox(height: 30),
            Text('Información Personal:', style: AppTextStyles.bodyTitleBlack),
            SizedBox(height: 18),
            SimpleForm(
                labelText: 'Nombre',
                controller: _nameController,
                isEnable: true),
            SizedBox(height: 12),
            SimpleForm(
                labelText: 'Apellidos',
                controller: _lastNameController,
                isEnable: true),
            SizedBox(height: 12),
            SimpleForm(
                labelText: 'Correo',
                controller: _emailController,
                isEnable: true,
                readOnly: true),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SimpleButtonFilled(
                    onPressed: () {
                      _save(context);
                    },
                    text: 'Guardar cambios'),
                SizedBox(height: 14),
                SimpleButtonOutlined(
                    onPressed: () => _signOutUser(textStyles.header.color!),
                    text: 'Cerrar Sesión')
              ],
            )
          ])),
    );
  }

  void _signOutUser(Color color) {
    QuickAlert.show(
      context: context,
      animType: QuickAlertAnimType.slideInUp,
      type: QuickAlertType.confirm,
      borderRadius: 7,
      title: '¿Estás seguro?',
      text: 'Cerrarás la sesión en este dispositivo',
      confirmBtnText: 'Continuar',
      confirmBtnColor: color,
      onConfirmBtnTap: () {
        final auth = FirebaseAuth.instance;
        FirebaseUIAuth.signOut(context: context, auth: auth);

        usuario = null;
        _nameController.text = '';
        _lastNameController.text = '';
        _emailController.text = '';

        Navigator.pop(context);
      },
      cancelBtnText: 'Cancelar',
    );
  }

  void _save(BuildContext context) {
    final userFirebase = FirebaseAuth.instance.currentUser;

    userService
        .saveChanges(userFirebase!.uid, _nameController.text,
            _lastNameController.text, userFirebase.email!)
        .then((_) {
      complete = true;
    });

    if (complete == true) {
      QuickAlert.show(
        context: context,
        animType: QuickAlertAnimType.slideInUp,
        type: QuickAlertType.success,
        borderRadius: 7,
        autoCloseDuration: Duration(seconds: 1),
        showConfirmBtn: false,
        title: '¡Todo bien!',
        text: 'Cambios guardados exitosamente',
      );
    } else {
      QuickAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        animType: QuickAlertAnimType.slideInUp,
        type: QuickAlertType.error,
        borderRadius: 7,
        title: '¡Sin internet!',
        text: 'Conéctate e intentalo de nuevo',
      );
    }

    complete = false;
  }

  Future<void> _cargarDatosUsuario() async {
    final userFirebase = FirebaseAuth.instance.currentUser;
    final data = await userService.getUserData(userFirebase!.uid);

    if (!mounted) return; // Evita errores si la screen fue cerrada

    setState(() {
      usuario = data;
      _nameController.text = usuario!.nombre;
      _lastNameController.text = usuario!.apellidos;
      _emailController.text = usuario!.email;
    });
  }
}
