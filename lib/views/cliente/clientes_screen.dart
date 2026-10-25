import 'package:flutter/material.dart';
import '../../viewmodels/cliente_viewmodel.dart';
import 'cliente_form_sheet.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});
  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final _viewModel = ClienteViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Clientes')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Buscar...', border: OutlineInputBorder()),
                  onChanged: _viewModel.cambiarBusqueda,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _viewModel.clientesFiltrados.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final c = _viewModel.clientesFiltrados[index];
                    return ListTile(
                      title: Text(c.nombre),
                      subtitle: Text(c.telefono),
                      trailing: Text('${_viewModel.obtenerTurnosCliente(c.id)} turnos'),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const ClienteFormSheet(),
              );
              // Forzamos la actualización al cerrar la hoja
              _viewModel.cambiarBusqueda('');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}