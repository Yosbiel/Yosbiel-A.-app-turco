import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/turno.dart';
import '../../models/cliente.dart';
import '../../models/servicio.dart';
import '../../models/estilista.dart';
import '../../data/mock_data.dart';
import '../../viewmodels/turno_viewmodel.dart';
import '../cliente/cliente_form_sheet.dart';

class FormularioTurnoScreen extends StatefulWidget {
  final Turno? turnoAEditar;
  const FormularioTurnoScreen({super.key, this.turnoAEditar});

  @override
  State<FormularioTurnoScreen> createState() => _FormularioTurnoScreenState();
}

class _FormularioTurnoScreenState extends State<FormularioTurnoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TurnoViewModel _viewModel = TurnoViewModel();
  
  Cliente? _cliente;
  List<Servicio> _servicios = [];
  Estilista? _estilista;
  DateTime _fecha = DateTime.now();
  DateTime? _hora;
  bool _hayCambios = false;
  
  final _notasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.turnoAEditar != null) {
      _cliente = widget.turnoAEditar!.cliente;
      _servicios = List.from(widget.turnoAEditar!.servicios);
      _estilista = widget.turnoAEditar!.estilista;
      _fecha = widget.turnoAEditar!.fechaHoraInicio;
      _hora = widget.turnoAEditar!.fechaHoraInicio;
      _notasController.text = widget.turnoAEditar!.notas ?? '';
    }
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _marcarCambio() {
    if (!_hayCambios) setState(() => _hayCambios = true);
  }

  @override
  Widget build(BuildContext context) {
    final estilistasDisponibles = MockData.estilistas.where((e) {
      for (var s in _servicios) {
        if (!e.realizaServicio(s)) return false;
      }
      return true;
    }).toList();

    return PopScope(
      canPop: !_hayCambios,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Descartar cambios?'),
            content: const Text('Si sales ahora se perderán.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Seguir editando')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Descartar', style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        if (confirmar == true && mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.turnoAEditar == null ? 'Nuevo turno' : 'Editar turno')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DropdownButtonFormField<Cliente>(
                value: _cliente,
                decoration: const InputDecoration(labelText: 'Cliente', border: OutlineInputBorder()),
                items: MockData.clientes.map((c) => DropdownMenuItem(value: c, child: Text(c.nombre))).toList(),
                onChanged: (val) {
                  setState(() => _cliente = val);
                  _marcarCambio();
                },
                validator: (val) => val == null ? 'Selecciona un cliente' : null,
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const ClienteFormSheet(),
                  ).then((_) => setState(() {}));
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Crear cliente nuevo'),
              ),
              const SizedBox(height: 16),

              const Text('Servicios (elige al menos uno):', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: MockData.servicios.map((s) => FilterChip(
                  label: Text(s.nombre),
                  selected: _servicios.contains(s),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) _servicios.add(s);
                      else _servicios.remove(s);
                      _hora = null;
                      _estilista = null;
                    });
                    _marcarCambio();
                  },
                )).toList(),
              ),
              if (_servicios.isEmpty && _formKey.currentState?.validate() == false)
                const Text('Debes elegir al menos un servicio', style: TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 16),

              DropdownButtonFormField<Estilista>(
                value: _estilista,
                decoration: const InputDecoration(labelText: 'Estilista', border: OutlineInputBorder()),
                items: estilistasDisponibles.map((e) => DropdownMenuItem(value: e, child: Text(e.nombre))).toList(),
                onChanged: (val) {
                  setState(() {
                    _estilista = val;
                    _hora = null;
                  });
                  _marcarCambio();
                },
                validator: (val) => val == null ? 'Selecciona un estilista' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: const Text('Fecha'),
                subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
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

              if (_servicios.isNotEmpty && _estilista != null) ...[
                const SizedBox(height: 10),
                const Text('Horas disponibles:', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildHoras(),
              ],
              const SizedBox(height: 16),

              TextFormField(
                controller: _notasController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notas (opcional)', border: OutlineInputBorder()),
                onChanged: (_) => _marcarCambio(),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _hora != null && _servicios.isNotEmpty) {
                    final nuevo = Turno(
                      id: widget.turnoAEditar?.id ?? DateTime.now().toString(),
                      cliente: _cliente!,
                      estilista: _estilista!,
                      servicios: _servicios,
                      fechaHoraInicio: _hora!,
                      notas: _notasController.text,
                      estado: EstadoTurno.programado,
                      fechaCreacion: DateTime.now(),
                      fechaModificacion: DateTime.now(),
                    );
                    _viewModel.guardarTurno(nuevo);
                    context.pop();
                  }
                },
                child: const Text('Guardar turno'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoras() {
    final horas = _viewModel.obtenerHorasDisponibles(_fecha, _estilista!, _cliente, _servicios);
    if (horas.isEmpty) return const Text('No hay horas disponibles');

    return Wrap(
      spacing: 8,
      children: horas.map((h) => ChoiceChip(
        label: Text('${h.hour}:00'),
        selected: _hora == h,
        onSelected: (selected) {
          setState(() => _hora = selected ? h : null);
          _marcarCambio();
        },
      )).toList(),
    );
  }
}