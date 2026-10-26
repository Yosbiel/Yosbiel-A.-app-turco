import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/turno.dart';
import '../../models/cliente.dart';
import '../../models/servicio.dart';
import '../../models/estilista.dart';
import '../../data/mock_data.dart';
import '../../viewmodels/turno_viewmodel.dart';
import '../../viewmodels/cliente_viewmodel.dart';
import '../cliente/cliente_form_sheet.dart';

class FormularioTurnoScreen extends StatefulWidget {
  final TurnoViewModel turnoVM;
  final ClienteViewModel clienteVM;
  final Turno? turnoAEditar;
  final Servicio? servicioInicial;
  final Cliente? clienteInicial;
  final DateTime? fechaInicial;

  const FormularioTurnoScreen({
    super.key,
    required this.turnoVM,
    required this.clienteVM,
    this.turnoAEditar,
    this.servicioInicial,
    this.clienteInicial,
    this.fechaInicial,
  });

  @override
  State<FormularioTurnoScreen> createState() => _FormularioTurnoScreenState();
}

class _FormularioTurnoScreenState extends State<FormularioTurnoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notasController = TextEditingController();

  Cliente? _cliente;
  final List<Servicio> _servicios = [];
  Estilista? _estilista;
  DateTime _fecha = DateTime.now();
  DateTime? _hora;
  bool _hayCambios = false;
  String? _errorHora;
  PublicoObjetivo? _filtroPublico; // Filtro de público

  @override
  void initState() {
    super.initState();
    if (widget.turnoAEditar != null) {
      final t = widget.turnoAEditar!;
      _cliente = t.cliente;
      _servicios.addAll(t.servicios);
      _estilista = t.estilista;
      _fecha = t.fechaHoraInicio;
      _hora = t.fechaHoraInicio;
      _notasController.text = t.notas ?? '';
      _filtroPublico = _generoAPublico(t.cliente.genero);
    } else {
      _cliente = widget.clienteInicial;
      if (_cliente != null) _filtroPublico = _generoAPublico(_cliente!.genero);
      if (widget.servicioInicial != null) {
        _servicios.add(widget.servicioInicial!);
      }
      if (widget.fechaInicial != null) _fecha = widget.fechaInicial!;
    }
  }

  PublicoObjetivo _generoAPublico(Genero g) =>
      g == Genero.mujer ? PublicoObjetivo.mujeres : PublicoObjetivo.hombres;

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _marcarCambio() {
    if (!_hayCambios) setState(() => _hayCambios = true);
  }

  Future<void> _guardar() async {
    final validForm = _formKey.currentState?.validate() ?? false;

    if (_servicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes elegir al menos un servicio')),
      );
      return;
    }
    if (_hora == null) {
      setState(() => _errorHora = 'Selecciona una hora');
      return;
    }
    if (!validForm) return;

    setState(() => _errorHora = null);

    final esEdicion = widget.turnoAEditar != null;
    final turnoGuardado = Turno(
      id: esEdicion
          ? widget.turnoAEditar!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      cliente: _cliente!,
      estilista: _estilista!,
      servicios: List.from(_servicios),
      fechaHoraInicio: _hora!,
      notas: _notasController.text.trim().isEmpty
          ? null
          : _notasController.text.trim(),
      estado: esEdicion
          ? widget.turnoAEditar!.estado
          : EstadoTurno.programado,
      fechaCreacion: esEdicion
          ? widget.turnoAEditar!.fechaCreacion
          : DateTime.now(),
      fechaModificacion: DateTime.now(),
    );

    widget.turnoVM.guardarTurno(turnoGuardado);
    if (mounted) context.pop(turnoGuardado);
  }

  @override
  Widget build(BuildContext context) {
    final estilistasDisponibles = MockData.estilistas.where((e) {
      for (final s in _servicios) {
        if (!e.realizaServicio(s)) return false;
      }
      return true;
    }).toList();

    // Servicios filtrados por público
    final serviciosFiltrados = MockData.servicios.where((s) {
      if (_filtroPublico == null) return true;
      return s.publico == _filtroPublico ||
          s.publico == PublicoObjetivo.unisex;
    }).toList();

    return PopScope(
      canPop: !_hayCambios,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Descartar cambios?'),
            content: const Text('Si sales ahora se perderán.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Seguir editando')),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Descartar',
                      style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        if (confirmar == true && mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.turnoAEditar == null
              ? 'Nuevo turno'
              : 'Editar turno'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DropdownButtonFormField<Cliente>(
                value: _cliente,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(),
                ),
                items: MockData.clientes
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c.nombre)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _cliente = val;
                    // Ajusta el filtro de público al género del cliente
                    if (val != null) {
                      _filtroPublico = _generoAPublico(val.genero);
                    }
                  });
                  _marcarCambio();
                },
                validator: (val) =>
                    val == null ? 'Selecciona un cliente' : null,
              ),
              TextButton.icon(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        ClienteFormSheet(clienteVM: widget.clienteVM),
                  );
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Crear cliente nuevo'),
              ),
              const SizedBox(height: 16),

              const Text('Servicios (al menos uno):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Filtro por público
              SegmentedButton<PublicoObjetivo?>(
                segments: const [
                  ButtonSegment(value: null, label: Text('Todos')),
                  ButtonSegment(value: PublicoObjetivo.mujeres, label: Text('Mujeres')),
                  ButtonSegment(value: PublicoObjetivo.hombres, label: Text('Hombres')),
                ],
                selected: {_filtroPublico},
                onSelectionChanged: (s) {
                  setState(() {
                    _filtroPublico = s.first;
                    _hora = null;
                  });
                  _marcarCambio();
                },
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: serviciosFiltrados.map((s) {
                  final selected = _servicios.any((x) => x.id == s.id);
                  return FilterChip(
                    label: Text(s.nombre),
                    selected: selected,
                    onSelected: (sel) {
                      setState(() {
                        if (sel) {
                          _servicios.add(s);
                        } else {
                          _servicios.removeWhere((x) => x.id == s.id);
                        }
                        _hora = null;
                        // Si el estilista ya no hace todos los servicios, limpiar y avisar
                        if (_estilista != null &&
                            !_servicios.every(
                                (x) => _estilista!.realizaServicio(x))) {
                          _estilista = null;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'El estilista seleccionado no realiza todos los servicios. Selecciona otro.')),
                          );
                        }
                      });
                      _marcarCambio();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<Estilista>(
                value: _estilista,
                decoration: const InputDecoration(
                  labelText: 'Estilista',
                  border: OutlineInputBorder(),
                ),
                items: estilistasDisponibles
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e.nombre)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _estilista = val;
                    _hora = null;
                  });
                  _marcarCambio();
                },
                validator: (val) =>
                    val == null ? 'Selecciona un estilista' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.outline),
                ),
                title: const Text('Fecha'),
                subtitle:
                    Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha.isBefore(DateTime.now())
                        ? DateTime.now()
                        : _fecha,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (picked != null) {
                    setState(() {
                      _fecha = picked;
                      _hora = null;
                    });
                    _marcarCambio();
                  }
                },
              ),
              const SizedBox(height: 16),

              if (_servicios.isNotEmpty && _estilista != null) ...[
                const Text('Horas disponibles:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildHoras(),
                if (_errorHora != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorHora!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _notasController,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _marcarCambio(),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar turno'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoras() {
    final horas = widget.turnoVM.obtenerHorasDisponibles(
      _fecha,
      _estilista!,
      _cliente,
      _servicios,
      idTurnoExcluir: widget.turnoAEditar?.id,
    );

    if (horas.isEmpty) {
      return const Text('No hay horas disponibles para esta combinación.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: horas.map((h) {
        final seleccionado = _hora == h;
        return ChoiceChip(
          label: Text(
              '${h.hour.toString().padLeft(2, '0')}:'
              '${h.minute.toString().padLeft(2, '0')}'),
          selected: seleccionado,
          onSelected: (sel) {
            setState(() {
              _hora = sel ? h : null;
              _errorHora = null;
            });
            _marcarCambio();
          },
        );
      }).toList(),
    );
  }
}