import 'package:flutter/material.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../providers/user_provider.dart';
import '../models/text_styles.dart';
import '../services/firebase_user_service.dart';
import '../widgets/forms.dart';
import '../widgets/buttons.dart';

UserService userService = UserService();
bool saveComplete = true;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).getUsuario();
    if (user != null) {
      _nameController.text = user.nombre;
      _lastNameController.text = user.apellidos;
      _emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStyles(Theme.of(context));
    final userProvider = Provider.of<UserProvider>(context);

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
                      _save(context, userProvider);
                    },
                    text: 'Guardar cambios'),
                SizedBox(height: 14),
                SimpleButtonOutlined(
                    onPressed: () =>
                        _signOutUser(textStyles.header.color!, userProvider),
                    text: 'Cerrar Sesión')
              ],
            )
          ])),
    );
  }

  void _signOutUser(Color color, UserProvider userProvider) {
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

        _nameController.text = '';
        _lastNameController.text = '';
        _emailController.text = '';
        userProvider.clearCache();

        Navigator.pop(context);
      },
      cancelBtnText: 'Cancelar',
    );
  }

  void _save(BuildContext context, UserProvider userProvider) {
    final userFirebase = FirebaseAuth.instance.currentUser;

    userService
        .updatePersonalInfo(userFirebase!.uid, _nameController.text,
            _lastNameController.text, userFirebase.email!)
        .then((_) {
      saveComplete = true;
      userProvider.getUsuario()!.nombre = _nameController.text;
      userProvider.getUsuario()!.apellidos = _lastNameController.text;
      userProvider.refresh();
    });

    if (saveComplete == true) {
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
        context: context,
        animType: QuickAlertAnimType.slideInUp,
        type: QuickAlertType.error,
        borderRadius: 7,
        title: '¡Sin internet!',
        text: 'Conéctate e intentalo de nuevo',
      );
    }

    saveComplete = false;
  }
}
