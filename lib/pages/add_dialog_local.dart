import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/Address.dart';
import 'package:mercado_zap/widgets/checkbox.dart';
import 'package:mercado_zap/widgets/customformfield.dart';

class AddLocalDialog extends StatefulWidget {
  const AddLocalDialog({Key? key}) : super(key: key);
  @override
  _AddLocalDialogState createState() => _AddLocalDialogState();
}

class _AddLocalDialogState extends State<AddLocalDialog> {
  late final Box _box;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _nameRua = TextEditingController();
  final _numberCasa = TextEditingController();
  final _numberTel = TextEditingController();
  final _complemento = TextEditingController();
  final _bairro = TextEditingController();
  bool _isSelected = false;
  String? _erroTelefone;
  String? _erroNumberCasa;
  void initState() {
    super.initState();
    _box = Hive.box('appBox');
  }

  @override
  void dispose() {
    _name.dispose();
    _nameRua.dispose();
    _numberCasa.dispose();
    _numberTel.dispose();
    _complemento.dispose();
    _bairro.dispose();

    super.dispose();
  }

  List<Address> _getAdresses() {
    final data = _box.get('addresses', defaultValue: <Map<String, dynamic>>[]);
    return List<Address>.from(
      (data as List).map(
        (item) => Address.fromMap(Map<String, dynamic>.from(item as Map)),
      ),
    );
  }

  Future<void> saveAddress() async {
    final endereco = Address(
      name: _name.text,
      nameRua: _nameRua.text,
      numberCasa: _numberCasa.text,
      complemento: _complemento.text,
      numberTel: _numberTel.text,
      bairro: _bairro.text,
    );

    final adresses = _box.get(
      'addresses',
      defaultValue: <Map<String, dynamic>>[],
    );

    final List<Map<String, dynamic>> updated = List<Map<String, dynamic>>.from(
      (adresses as List).map((item) => Map<String, dynamic>.from(item as Map)),
    );
    updated.add(endereco.toMap());

    await _box.put('addresses', updated);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await saveAddress();

      Navigator.pop(context, true);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Adicionar endereço'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomText(text: 'Rua / Avenida'),
              CustomTextField(
                controller: _nameRua,

                hintText: 'Ex: Rua Leones,342',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a rua ou avenida.';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 35),
              CustomText(text: 'Bairro'),
              CustomTextField(
                controller: _bairro,

                hintText: 'Ex: Centro',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome completo.';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 35),
              CustomText(text: 'Número'),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _numberCasa,
                      errorText: _erroNumberCasa,

                      hintText: 'Ex: 1234',

                      // keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          if (value.length > 5) {
                            _erroNumberCasa = 'Insira no máximo 5 dígitos';
                          } else {
                            _erroNumberCasa = null;
                          }
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Por favor, insira o número da casa.';

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 8),
                  CustomCheckbox(
                    label: 'Endereço principal',
                    value: _isSelected,

                    onChanged: (bool? newValue) {
                      setState(() {
                        _isSelected = newValue!;
                      });
                    },
                  ),
                ],
              ),

              // const SizedBox(height: 35),

              // const SizedBox(height: 35),
              CustomText(text: 'Complemento (opcional)'),

              CustomTextField(
                maxLines: 10,
                minLines: 5,
                controller: _complemento,

                hintText: 'Ex: Casa 2',
              ),
              CustomText(
                text: 'Dados de contato',

                value:
                    'Se houver algum problema no envio, você receberá uma\nligação neste número',
              ),

              CustomText(text: 'Nome Completo'),

              CustomTextField(
                controller: _name,

                hintText: 'Ex: João da Silva',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome completo.';
                  }
                  return null;
                },
              ),
              CustomText(text: 'Telefone de contato'),
              CustomTextField(
                controller: _numberTel,
                errorText: _erroTelefone,
                hintText: 'Ex: (11) 99999-9999',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                onChanged: (value) {
                  setState(() {
                    if (value.length > 11) {
                      _erroTelefone = 'Insira no máximo 11 dígitos';
                    } else {
                      _erroTelefone = null;
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Por favor, insira um telefone.';

                  return null;
                },
              ),
              // const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shadowColor: Theme.of(context).colorScheme.onSurface,
                      elevation: 5,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Salvar endereço',
                      style: TextStyle(
                        shadows: [],
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
