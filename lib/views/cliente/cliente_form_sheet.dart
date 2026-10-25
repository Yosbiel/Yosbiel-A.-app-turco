import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../data/mock_data.dart';

class ClienteFormSheet extends StatefulWidget {
  const ClienteFormSheet({super.key});
  @override
  State<ClienteFormSheet> createState() => _ClienteFormSheetState();
}

class _ClienteFormSheetState extends State<ClienteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  Genero _genero = Genero.mujer;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (val) {
                if (val == null || val.trim().length < 3) return 'Mínimo 3 caracteres';
                if (val.trim().length > 60) return 'Máximo 60 caracteres';
                return null;
              },
            ),
            TextFormField(
              controller: _telefono,
              decoration: const InputDecoration(labelText: 'Teléfono (8 dígitos)'),
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.length != 8) return 'Debe tener 8 dígitos';
                if (int.tryParse(val) == null) return 'Solo números';
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Genero>(
              value: _genero,
              items: const [
                DropdownMenuItem(value: Genero.mujer, child: Text('Mujer')),
                DropdownMenuItem(value: Genero.hombre, child: Text('Hombre')),
              ],
              onChanged: (val) => setState(() => _genero = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  MockData.clientes.add(Cliente(
                    id: DateTime.now().toString(), 
                    nombre: _nombre.text, 
                    telefono: _telefono.text, 
                    genero: _genero, 
                    fechaRegistro: DateTime.now()
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}