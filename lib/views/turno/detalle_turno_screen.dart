import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../models/turno.dart';
import '../../viewmodels/turno_viewmodel.dart';

class DetalleTurnoScreen extends StatefulWidget {
  final String turnoId;
  const DetalleTurnoScreen({super.key, required this.turnoId});

  @override
  State<DetalleTurnoScreen> createState() => _DetalleTurnoScreenState();
}

class _DetalleTurnoScreenState extends State<DetalleTurnoScreen> {
  Turno? _turno;
  final TurnoViewModel _viewModel = TurnoViewModel();

  @override
  void initState() {
    super.initState();
    try {
      _turno = MockData.turnos.firstWhere((t) => t.id == widget.turnoId);
    } catch (e) {
      _turno = null;
    }
  }

  void _cambiarEstado(EstadoTurno nuevo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Cambiar a estado ${nuevo.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí')),
        ],
      ),
    );

    if (confirmar == true) {
      _viewModel.cambiarEstado(_turno!.id, nuevo);
      setState(() {
        _turno = MockData.turnos.firstWhere((t) => t.id == widget.turnoId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_turno == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Turno no encontrado')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Turno')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: Text(_turno!.cliente.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('Tel: ${_turno!.cliente.telefono}'),
              trailing: Text(_turno!.estado.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Fecha'),
                  subtitle: Text('${_turno!.fechaHoraInicio.day}/${_turno!.fechaHoraInicio.month}/${_turno!.fechaHoraInicio.year}'),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Hora'),
                  subtitle: Text('${_turno!.fechaHoraInicio.hour}:00 a ${_turno!.fechaHoraFin.hour}:00'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Estilista'),
                  subtitle: Text(_turno!.estilista.nombre),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Servicios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                ..._turno!.servicios.map((s) => ListTile(
                  title: Text(s.nombre),
                  trailing: Text('\$${s.precio}'),
                )),
                const Divider(),
                ListTile(
                  title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('\$${_turno!.precioTotal}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                )
              ],
            ),
          ),
          if (_turno!.notas != null && _turno!.notas!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Notas'),
                subtitle: Text(_turno!.notas!),
              ),
            ),
          ],
          const SizedBox(height: 20),
          
          // Botones de acción
          if (_turno!.estado == EstadoTurno.programado) ...[
            ElevatedButton.icon(
              onPressed: () => context.push('/turno/${_turno!.id}/editar'),
              icon: const Icon(Icons.edit),
              label: const Text('Editar Turno'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _cambiarEstado(EstadoTurno.completado),
              icon: const Icon(Icons.check),
              label: const Text('Completar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _cambiarEstado(EstadoTurno.cancelado),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ] else ...[
            const Center(child: Text('Este turno ya no se puede modificar', style: TextStyle(color: Colors.grey)))
          ]
        ],
      ),
    );
  }
}