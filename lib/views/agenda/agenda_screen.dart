import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/agenda_viewmodel.dart';
import '../../viewmodels/turno_viewmodel.dart';
import '../../models/turno.dart';
import '../../data/mock_data.dart';

class AgendaScreen extends StatefulWidget {
  final String? estilistaIdInicial;
  final Function(ThemeMode)? onCambiarTema;

  const AgendaScreen({super.key, this.estilistaIdInicial, this.onCambiarTema});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final AgendaViewModel _viewModel = AgendaViewModel();
  final TurnoViewModel _turnoVM = TurnoViewModel();

  @override
  void initState() {
    super.initState();
    if (widget.estilistaIdInicial != null) {
      _viewModel.cambiarFiltroEstilista(widget.estilistaIdInicial);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _turnoVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListenableBuilder(
      listenable: Listenable.merge([_viewModel, _turnoVM]),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text('Turco', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cambiar tema'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(title: const Text('Claro'), onTap: () {
                            widget.onCambiarTema?.call(ThemeMode.light);
                            Navigator.pop(context);
                          }),
                          ListTile(title: const Text('Oscuro'), onTap: () {
                            widget.onCambiarTema?.call(ThemeMode.dark);
                            Navigator.pop(context);
                          }),
                          ListTile(title: const Text('Sistema'), onTap: () {
                            widget.onCambiarTema?.call(ThemeMode.system);
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Prog: ${_viewModel.cantidadProgramados}', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                    Text('Comp: ${_viewModel.cantidadCompletados}', style: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.bold)),
                    Text('Ingreso: \$${_viewModel.ingresoEstimado}', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Todos'),
                      selected: _viewModel.filtroEstilistaId == null,
                      onSelected: (_) => _viewModel.cambiarFiltroEstilista(null),
                    ),
                    const SizedBox(width: 8),
                    ...MockData.estilistas.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(e.nombre.split(' ')[0]),
                        selected: _viewModel.filtroEstilistaId == e.id,
                        onSelected: (_) => _viewModel.cambiarFiltroEstilista(e.id),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<EstadoTurno?>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(value: EstadoTurno.programado, label: Text('Program.')),
                    ButtonSegment(value: EstadoTurno.completado, label: Text('Complet.')),
                    ButtonSegment(value: EstadoTurno.cancelado, label: Text('Cancel.')),
                  ],
                  selected: {_viewModel.filtroEstado},
                  onSelectionChanged: (Set<EstadoTurno?> newSelection) {
                    _viewModel.cambiarFiltroEstado(newSelection.first);
                  },
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: _viewModel.turnosDelDia.isEmpty
                    ? const Center(child: Text('No hay turnos para este día'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _viewModel.turnosDelDia.length,
                        itemBuilder: (context, index) {
                          final turno = _viewModel.turnosDelDia[index];
                          return GestureDetector(
                            onTap: () {
                              // Al volver del detalle, forzamos actualización
                              context.push('/turno/${turno.id}').then((_) {
                                setState(() {});
                              });
                            },
                            onLongPress: () {
                              if (turno.estado == EstadoTurno.programado) {
                                _mostrarAcciones(turno);
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(turno.cliente.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${turno.fechaHoraInicio.hour}:00 - ${turno.servicios.map((s) => s.nombre).join(', ')}'),
                                trailing: Text(turno.estado.name, style: TextStyle(
                                  color: turno.estado == EstadoTurno.cancelado ? Colors.red : (turno.estado == EstadoTurno.completado ? Colors.blue : colorScheme.primary)
                                )),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Al volver del formulario, forzamos actualización
              context.push('/turno/nuevo').then((_) {
                setState(() {});
              });
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _mostrarAcciones(Turno turno) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.check, color: Colors.green),
            title: const Text('Completar turno'),
            onTap: () {
              _turnoVM.cambiarEstado(turno.id, EstadoTurno.completado);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.red),
            title: const Text('Cancelar turno'),
            onTap: () {
              _turnoVM.cambiarEstado(turno.id, EstadoTurno.cancelado);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}