import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/cliente_viewmodel.dart';
import '../../models/cliente.dart';
import 'cliente_form_sheet.dart';

class ClientesScreen extends StatefulWidget {
  final ClienteViewModel clienteVM;

  const ClientesScreen({super.key, required this.clienteVM});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.clienteVM,
      builder: (context, _) {
        final clientes = widget.clienteVM.clientesFiltrados;
        return Scaffold(
          appBar: AppBar(title: const Text('Clientes')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: widget.clienteVM.cambiarBusqueda,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<Genero?>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(
                        value: Genero.mujer, label: Text('Mujeres')),
                    ButtonSegment(
                        value: Genero.hombre, label: Text('Hombres')),
                  ],
                  selected: {widget.clienteVM.filtroGenero},
                  onSelectionChanged: (s) {
                    widget.clienteVM.cambiarFiltroGenero(s.first);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ${widget.clienteVM.totalClientes}'),
                    Text(
                        'M: ${widget.clienteVM.totalMujeres} | H: ${widget.clienteVM.totalHombres}'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: clientes.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'No hay clientes registrados o la búsqueda no devuelve resultados.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: clientes.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final c = clientes[i];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(c.nombre.isNotEmpty
                                  ? c.nombre[0].toUpperCase()
                                  : '?'),
                            ),
                            title: Text(c.nombre),
                            subtitle:
                                Text('${c.telefono} · ${c.genero.name}'),
                            trailing: Text(
                              '${widget.clienteVM.obtenerTurnosCliente(c.id)} turnos',
                            ),
                            onTap: () => _abrirDetalleCliente(c),
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
                builder: (_) =>
                    ClienteFormSheet(clienteVM: widget.clienteVM),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _abrirDetalleCliente(Cliente c) {
    final screenContext = context;
    showModalBottomSheet(
      context: screenContext,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(c.nombre,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Teléfono: ${c.telefono}'),
              Text('Género: ${c.genero.name}'),
              if (c.correo != null) Text('Correo: ${c.correo}'),
              const SizedBox(height: 16),
              const Text('Historial de turnos:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...widget.clienteVM
                  .historialCliente(c.id)
                  .map((t) => ListTile(
                        dense: true,
                        title: Text(
                            '${t.fechaHoraInicio.day}/${t.fechaHoraInicio.month}/${t.fechaHoraInicio.year}'),
                        subtitle: Text(t.estado.name),
                        trailing: Text('\$${t.precioTotal}'),
                      )),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  screenContext.push('/turno/nuevo', extra: c);
                },
                icon: const Icon(Icons.add),
                label: const Text('Nuevo turno'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  showModalBottomSheet(
                    context: screenContext,
                    isScrollControlled: true,
                    builder: (_) => ClienteFormSheet(
                        clienteVM: widget.clienteVM,
                        clienteAEditar: c),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  if (widget.clienteVM.tieneTurnosProgramados(c.id)) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(screenContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'No se puede eliminar: tiene turnos programados.'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  final ok = await showDialog<bool>(
                    context: screenContext,
                    builder: (dCtx) => AlertDialog(
                      title: const Text('¿Eliminar cliente?'),
                      content:
                          const Text('Se eliminará también su historial.'),
                      actions: [
                        TextButton(
                            onPressed: () =>
                                Navigator.pop(dCtx, false),
                            child: const Text('No')),
                        TextButton(
                            onPressed: () =>
                                Navigator.pop(dCtx, true),
                            child: const Text('Sí')),
                      ],
                    ),
                  );
                  // AÑADIDO: verificar que el widget siga montado antes de usar el VM
                  if (ok == true && mounted) {
                    widget.clienteVM.eliminarCliente(c.id);
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Eliminar',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}