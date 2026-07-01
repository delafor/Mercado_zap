import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mercado_zap/models/address.dart';
import 'package:mercado_zap/widgets/customformfield.dart';

class AddressPage extends StatefulWidget {
  
  final Address? address;


  final int? index;

  const AddressPage({super.key, this.address, this.index});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  final nameController = TextEditingController();

  final ruaController = TextEditingController();

  final numberCasaController = TextEditingController();
  final numberTelController = TextEditingController();
  final bairroController = TextEditingController();
  String? _erroTelefone;
  String? _erroNumberCasa;

  @override
  void initState() {
    super.initState();

  
    if (widget.address != null) {
  
      nameController.text = widget.address!.name;
      ruaController.text = widget.address!.nameRua;
      numberCasaController.text = widget.address!.numberCasa;
      numberTelController.text = widget.address!.numberTel;

      bairroController.text = widget.address!.bairro;
    }
  }

  @override
  void dispose() {
  
    nameController.dispose();
    numberCasaController.dispose();
    numberTelController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    super.dispose();
  }

  Future<void> salvarEndereco() async {
    
    final box = Hive.box('appBox');


    final data = List<Map<String, dynamic>>.from(
      box.get('addresses', defaultValue: []),
    );

  
    final endereco = Address(
      nameRua: ruaController.text,
      numberCasa: numberCasaController.text,
      bairro: bairroController.text,
      name: nameController.text,

      numberTel: numberTelController.text,
      complemento: '',
    );

   
    if (widget.address != null && widget.index != null) {
     
      data[widget.index!] = endereco.toMap();
    } else {
    
      data.add(endereco.toMap());
    }


    await box.put('addresses', data);


    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
   
    final editando = widget.address != null;

    return Scaffold(
      appBar: AppBar(
       
        title: Text(editando ? 'Editar endereço' : 'Novo endereço'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomText(text: 'Rua / Avenida'),
              CustomTextField(
                controller: ruaController,

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
                controller: bairroController,

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
                      controller: numberCasaController,
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
                ],
              ),

              // const SizedBox(height: 35),
              CustomText(
                text: 'Dados de contato',

                value:
                    'Se houver algum problema no envio, você receberá uma\nligação neste número',
              ),
              const SizedBox(height: 30),
              CustomText(text: 'Nome Completo'),

              CustomTextField(
                controller: nameController,

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
                controller: numberTelController,
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

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Theme.of(context).colorScheme.onSurface,
                    elevation: 5,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: salvarEndereco,
                  child: Text(
                    editando ? 'Atualizar endereço' : 'Salvar endereço',
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
