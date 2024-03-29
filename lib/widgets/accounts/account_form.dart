import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/services/account_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/accounts.dart';

class AccountForm extends ConsumerStatefulWidget {
  final Account? account;

  AccountForm({super.key, required this.account});

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<AccountForm> {
  final _formKey = GlobalKey<FormState>();

  var accountId = '';
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _iconController = TextEditingController();
  IconData? icon;
  Color? color;

  var saving = false;

  _pickIcon() async {
    icon = await showIconPicker(
      context,
      adaptiveDialog: true,
      showTooltips: false,
      showSearchBar: true,
      iconPickerShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      iconPackModes: [
        (Platform.isIOS) ? IconPack.cupertino : IconPack.material
      ],
    );

    if (icon != null) {
      setState(() {
        _iconController.text = jsonEncode(serializeIcon(icon!));
      });
    }
  }

  _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Colors.white,
              onColorChanged: (Color color) {
                _colorController.text = color.value.toRadixString(16);
                this.color = color;
                setState(() {});
                Navigator.of(context).pop();
              },
              enableLabel: true,
              portraitOnly: true,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      accountId = widget.account!.id;
      _nameController.text = widget.account!.name;
      _colorController.text = widget.account!.color;
      _iconController.text = widget.account!.icon;
      icon = deserializeIcon(
        Map<String, dynamic>.from(jsonDecode(widget.account!.icon)),
        iconPack: IconPack.allMaterial,
      );
      color = Color(int.parse(widget.account!.color, radix: 16));
    }
  }

  void _submitForm() async {
    setState(() {
      saving = true;
    });
    bool error = false;
    String errorMessage = '';
    if (_colorController.text.isEmpty) {
      error = true;
      errorMessage = 'Please select a color';
    }
    if (_iconController.text.isEmpty) {
      error = true;
      errorMessage = 'Please select an icon';
    }
    if (!error && _formKey.currentState!.validate()) {
      final newAccount = Account(
        name: _nameController.text,
        color: _colorController.text,
        icon: _iconController.text,
      );
      if (accountId.isNotEmpty) {
        newAccount.id = accountId;
        await AccountService().updateAccount(newAccount);
        ref.read(accountsProvider.notifier).updateAccount(newAccount);
      } else {
        final response = await AccountService().addAccount(newAccount);
        newAccount.id = response.body;
        ref.read(accountsProvider.notifier).addAccount(newAccount);
      }
      setState(() {
        saving = false;
      });
      Navigator.of(context).pop();
    } else if (errorMessage.isNotEmpty) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid data'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (color != null)
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: color,
                      ),
                      margin: const EdgeInsets.only(right: 16),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _pickColor,
                  child: Text(color != null ? 'Change Color' : 'Select Color'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (icon != null)
                  GestureDetector(
                      onTap: _pickIcon, child: Icon(icon, size: 40)),
                if (icon != null) const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickIcon,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(icon != null ? 'Change Icon' : 'Select Icon'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (Platform.isIOS)
              CupertinoButton.filled(
                onPressed: _submitForm,
                child: (saving)
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Save account',
                        style: TextStyle(color: Colors.white),
                      ),
              )
            else
              ElevatedButton(
                onPressed: _submitForm,
                child: (saving)
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Save account',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
