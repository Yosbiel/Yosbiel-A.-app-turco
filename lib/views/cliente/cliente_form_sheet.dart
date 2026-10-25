import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../viewmodels/cliente_viewmodel.dart';

class ClienteFormSheet extends StatefulWidget {
  final ClienteViewModel clienteVM;
  final Cliente? clienteAEditar;

  const ClienteFormSheet({
    super.key,
    required this.clienteVM,
    this.clienteAEditar,
  });

  @override
  State<ClienteFormSheet> createState() => _ClienteFormSheetState();
}

class _ClienteFormSheetState extends State<ClienteFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  final _correo = TextEditingController();
  Genero _genero = Genero.mujer;

  @override
  void initState() {
    super.initState();
    if (widget.clienteAEditar != null) {
      _nombre.text = widget.clienteAEditar!.nombre;
      _telefono.text = widget.clienteAEditar!.telefono;
      _correo.text = widget.clienteAEditar!.correo ?? '';
      _genero = widget.clienteAEditar!.genero;
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _correo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.clienteAEditar != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                esEdicion ? 'Editar cliente' : 'Nuevo cliente',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  final v = val?.trim() ?? '';
                  if (v.length < 3) return 'Mínimo 3 caracteres';
                  if (v.length > 60) return 'Máximo 60 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (8 dígitos)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  final v = val ?? '';
                  if (v.length != 8) return 'Debe tener 8 dígitos';
                  if (int.tryParse(v) == null) return 'Solo números';
                  if (widget.clienteVM.telefonoExiste(v,
                      excluirClienteId: widget.clienteAEditar?.id)) {
                    return 'Ese teléfono ya está registrado';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Genero>(
                value: _genero,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: Genero.mujer, child: Text('Mujer')),
                  DropdownMenuItem(
                      value: Genero.hombre, child: Text('Hombre')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _genero = val);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _correo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo (opcional)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  final v = val?.trim() ?? '';
                  if (v.isEmpty) return null;
                  final regex = RegExp(
                      r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                  if (!regex.hasMatch(v)) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final cliente = Cliente(
                    id: widget.clienteAEditar?.id ??
                        'c_${DateTime.now().millisecondsSinceEpoch}',
                    nombre: _nombre.text.trim(),
                    telefono: _telefono.text.trim(),
                    genero: _genero,
                    correo: _correo.text.trim().isEmpty
                        ? null
                        : _correo.text.trim(),
                    fechaRegistro:
                        widget.clienteAEditar?.fechaRegistro ??
                            DateTime.now(),
                  );
                  if (esEdicion) {
                    widget.clienteVM.actualizarCliente(cliente);
                  } else {
                    widget.clienteVM.agregarCliente(cliente);
                  }
                  Navigator.pop(context, cliente);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}