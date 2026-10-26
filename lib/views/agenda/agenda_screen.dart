import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/agenda_viewmodel.dart';
import '../../viewmodels/turno_viewmodel.dart';
import '../../models/turno.dart';
import '../../data/mock_data.dart';

class AgendaScreen extends StatefulWidget {
  final TurnoViewModel turnoVM;
  final AgendaViewModel agendaVM;
  final String? estilistaIdInicial;
  final Function(ThemeMode)? onCambiarTema;

  const AgendaScreen({
    super.key,
    required this.turnoVM,
    required this.agendaVM,
    this.estilistaIdInicial,
    this.onCambiarTema,
  });

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.estilistaIdInicial != null) {
      widget.agendaVM.cambiarFiltroEstilista(widget.estilistaIdInicial);
    }
  }

  @override
  void didUpdateWidget(covariant AgendaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.estilistaIdInicial != null &&
        widget.estilistaIdInicial != oldWidget.estilistaIdInicial) {
      widget.agendaVM.cambiarFiltroEstilista(widget.estilistaIdInicial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.turnoVM, widget.agendaVM]),
      builder: (context, _) {
        final turnos = widget.turnoVM.turnosDelDia(
          fecha: widget.agendaVM.fechaSeleccionada,
          estilistaId: widget.agendaVM.filtroEstilistaId,
          estado: widget.agendaVM.filtroEstado,
        );

        final turnosDelDiaSinFiltroEstado = widget.turnoVM.turnosDelDia(
          fecha: widget.agendaVM.fechaSeleccionada,
          estilistaId: widget.agendaVM.filtroEstilistaId,
        );
        final programados = turnosDelDiaSinFiltroEstado
            .where((t) => t.estado == EstadoTurno.programado)
            .length;
        final completados = turnosDelDiaSinFiltroEstado
            .where((t) => t.estado == EstadoTurno.completado)
            .length;
        final ingreso = turnosDelDiaSinFiltroEstado
            .where((t) =>
                t.estado == EstadoTurno.programado ||
                t.estado == EstadoTurno.completado)
            .fold<double>(0.0, (s, t) => s + t.precioTotal);

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: const Text(
              'Turco',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Cambiar tema'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Claro'),
                            onTap: () {
                              widget.onCambiarTema?.call(ThemeMode.light);
                              Navigator.pop(ctx);
                            },
                          ),
                          ListTile(
                            title: const Text('Oscuro'),
                            onTap: () {
                              widget.onCambiarTema?.call(ThemeMode.dark);
                              Navigator.pop(ctx);
                            },
                          ),
                          ListTile(
                            title: const Text('Sistema'),
                            onTap: () {
                              widget.onCambiarTema?.call(ThemeMode.system);
                              Navigator.pop(ctx);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Resumen del día
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Prog: $programados',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                    Text('Comp: $completados',
                        style: TextStyle(
                            color: colorScheme.tertiary,
                            fontWeight: FontWeight.bold)),
                    Text('Ingreso: \$${ingreso.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Tira de días de la semana (ListView.builder obligatorio)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: 7, // Lunes a Domingo
                  itemBuilder: (context, index) {
                    // Calculamos el lunes de la semana de la fecha seleccionada
                    final lunesDeSemana = widget.agendaVM.fechaSeleccionada
                        .subtract(Duration(
                            days: widget.agendaVM.fechaSeleccionada.weekday -
                                1));
                    final dia = lunesDeSemana.add(Duration(days: index));
                    final esSeleccionado = dia.year ==
                            widget.agendaVM.fechaSeleccionada.year &&
                        dia.month == widget.agendaVM.fechaSeleccionada.month &&
                        dia.day == widget.agendaVM.fechaSeleccionada.day;
                    final esDomingo = dia.weekday == DateTime.sunday;

                    return GestureDetector(
                      onTap: () => widget.agendaVM.cambiarFecha(dia),
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: esSeleccionado
                              ? colorScheme.primaryContainer
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: esSeleccionado
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _nombreDia(dia.weekday),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: esDomingo
                                    ? colorScheme.error
                                    : colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${dia.day}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: esSeleccionado
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Botones de navegación por semana
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => widget.agendaVM.cambiarFecha(
                        widget.agendaVM.fechaSeleccionada
                            .subtract(const Duration(days: 7))),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      '${widget.agendaVM.fechaSeleccionada.day}/'
                      '${widget.agendaVM.fechaSeleccionada.month}/'
                      '${widget.agendaVM.fechaSeleccionada.year}',
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: widget.agendaVM.fechaSeleccionada,
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365)),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        widget.agendaVM.cambiarFecha(picked);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => widget.agendaVM.cambiarFecha(
                        widget.agendaVM.fechaSeleccionada
                            .add(const Duration(days: 7))),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Filtro por estilista
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Todos'),
                      selected: widget.agendaVM.filtroEstilistaId == null,
                      onSelected: (_) =>
                          widget.agendaVM.cambiarFiltroEstilista(null),
                    ),
                    const SizedBox(width: 8),
                    ...MockData.estilistas.map((e) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(e.nombre.split(' ')[0]),
                            selected:
                                widget.agendaVM.filtroEstilistaId == e.id,
                            onSelected: (_) =>
                                widget.agendaVM.cambiarFiltroEstilista(e.id),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Filtro por estado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<EstadoTurno?>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(
                        value: EstadoTurno.programado,
                        label: Text('Program.')),
                    ButtonSegment(
                        value: EstadoTurno.completado,
                        label: Text('Complet.')),
                    ButtonSegment(
                        value: EstadoTurno.cancelado,
                        label: Text('Cancel.')),
                  ],
                  selected: {widget.agendaVM.filtroEstado},
                  onSelectionChanged: (Set<EstadoTurno?> newSelection) {
                    widget.agendaVM.cambiarFiltroEstado(newSelection.first);
                  },
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Lista de turnos
              Expanded(
                child: turnos.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 64),
                              SizedBox(height: 16),
                              Text(
                                'No hay turnos para este día o filtros.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: turnos.length,
                        itemBuilder: (context, index) {
                          final turno = turnos[index];
                          return GestureDetector(
                            onTap: () => context.push('/turno/${turno.id}'),
                            onLongPress: () {
                              if (turno.estado == EstadoTurno.programado) {
                                _mostrarAcciones(context, turno);
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(
                                  turno.cliente.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${turno.fechaHoraInicio.hour.toString().padLeft(2, '0')}:'
                                  '${turno.fechaHoraInicio.minute.toString().padLeft(2, '0')} '
                                  '- ${turno.servicios.map((s) => s.nombre).join(', ')}',
                                ),
                                trailing: Text(
                                  turno.estado.name,
                                  style: TextStyle(
                                    color: turno.estado ==
                                            EstadoTurno.cancelado
                                        ? Colors.red
                                        : turno.estado ==
                                                EstadoTurno.completado
                                            ? Colors.blue
                                            : colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final resultado = await context.push<Turno>(
                '/turno/nuevo',
                extra: widget.agendaVM.fechaSeleccionada,
              );
              if (resultado != null && mounted) {
                widget.agendaVM.cambiarFecha(resultado.fechaHoraInicio);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Turno guardado para ${resultado.cliente.nombre}'),
                  ),
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _nombreDia(int dia) {
    const dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return dias[dia - 1];
  }

  void _mostrarAcciones(BuildContext context, Turno turno) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check, color: Colors.green),
              title: const Text('Completar turno'),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await _confirmar(
                    context, '¿Marcar como completado?');
                if (ok == true) {
                  widget.turnoVM
                      .cambiarEstado(turno.id, EstadoTurno.completado);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancelar turno'),
              onTap: () async {
                Navigator.pop(ctx);
                final ok =
                    await _confirmar(context, '¿Cancelar este turno?');
                if (ok == true) {
                  widget.turnoVM
                      .cambiarEstado(turno.id, EstadoTurno.cancelado);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmar(BuildContext context, String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text(mensaje),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sí')),
        ],
      ),
    );
  }
}