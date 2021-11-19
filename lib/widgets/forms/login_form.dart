import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends HookConsumerWidget {
  LoginForm({Key? key, required this.loginEntry, required this.remember})
      : super(key: key);
  final ValueNotifier remember;
  final ValueNotifier loginEntry;
  // final Function(Map<String, String> entries) login;

  final _formKey = GlobalKey<FormState>();
  // late TextEditingController _usernameController;
  // late TextEditingController _passController;

  String? _passwordValidator(String? entry, BuildContext context) {
    String? _err = _filledValidator(entry, context);
    if (_err == null && (entry!.length > 15 || entry.length < 6)) {
      _err = AppLocalizations.of(context)!.passwordLengthError;
    }
    return _err;
  }

  String? _filledValidator(String? entry, BuildContext context) {
    if (entry == null || entry.isEmpty) {
      return AppLocalizations.of(context)!.userNameFillError;
    }
    return null;
  }

  String? _emailValidator(String? entry, BuildContext context) {
    String? _err = _filledValidator(entry, context);
    if (_err == null) {
      if (!EmailValidator.validate(entry!)) {
        _err = AppLocalizations.of(context)!.emailFormatError;
      }
    }
    return _err;
  }

  Widget getFormField(bool isPass, BuildContext context,
      {required TextEditingController usernameController,
      required TextEditingController passController}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        const Size(300, 90),
      ),
      child: TextFormField(
        validator: isPass
            ? (entry) => _passwordValidator(entry, context)
            : (entry) => _emailValidator(entry, context),
        controller: isPass ? passController : usernameController,
        decoration: InputDecoration(
          labelText: isPass
              ? AppLocalizations.of(context)!.passLabel
              : AppLocalizations.of(context)!.usernameLabel,
        ),
        obscureText: isPass,
      ),
    );
  }

  void rememberChanged(bool? newValue) {
    if (newValue == null) {
      remember.value = false;
    } else {
      remember.value = newValue;
    }
  }

  void _onSubmit({required String username, required String pass}) {
    if (_formKey.currentState!.validate()) {
      Map<String, String> loginEntries = {
        'email': username,
        'password': pass,
      };
      loginEntry.value = loginEntries;
      // login(loginEntries);
    }
  }

  Widget getRememberCheckbox(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        const Size(300, 50),
      ),
      child: CheckboxListTile(
        title: Text(AppLocalizations.of(context)!.rememberCB),
        value: remember.value,
        onChanged: rememberChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _usernameController = useTextEditingController();
    final _passController = useTextEditingController();
    if (loginEntry.value.keys.isNotEmpty) {
      _usernameController.text = loginEntry.value['email'];
      _passController.text = loginEntry.value['password'];
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              getFormField(false, context,
                  usernameController: _usernameController,
                  passController: _passController),
              const SizedBox(
                height: 14,
              ),
              getFormField(true, context,
                  usernameController: _usernameController,
                  passController: _passController),
              const SizedBox(
                height: 14,
              ),
              getRememberCheckbox(context),
              const SizedBox(
                height: 14,
              ),
              ElevatedButton(
                onPressed: () => _onSubmit(
                    username: _usernameController.text,
                    pass: _passController.text),
                child: Text(AppLocalizations.of(context)!.loginLabel),
              )
            ],
          ),
        ),
      ),
    );
  }
}
