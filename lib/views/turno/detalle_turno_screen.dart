import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/turno.dart';
import '../../viewmodels/turno_viewmodel.dart';

class DetalleTurnoScreen extends StatelessWidget {
  final String turnoId;
  final TurnoViewModel turnoVM;

  const DetalleTurnoScreen({
    super.key,
    required this.turnoId,
    required this.turnoVM,
  });

  Future<void> _cambiarEstado(
      BuildContext context, Turno turno, EstadoTurno nuevo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Cambiar a estado ${nuevo.name}?'),
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
    if (confirmar == true) {
      turnoVM.cambiarEstado(turno.id, nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: turnoVM,
      builder: (context, _) {
        final turno = turnoVM.buscarTurno(turnoId);

        if (turno == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle del turno')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Este turno ya no existe.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle del Turno'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: ListTile(
                  title: Text(turno.cliente.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('Tel: ${turno.cliente.telefono}'),
                  trailing: Text(
                    turno.estado.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Fecha'),
                      subtitle: Text(
                          '${turno.fechaHoraInicio.day}/'
                          '${turno.fechaHoraInicio.month}/'
                          '${turno.fechaHoraInicio.year}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Hora'),
                      subtitle: Text(
                          '${turno.fechaHoraInicio.hour}:'
                          '${turno.fechaHoraInicio.minute.toString().padLeft(2, '0')}'
                          ' a ${turno.fechaHoraFin.hour}:'
                          '${turno.fechaHoraFin.minute.toString().padLeft(2, '0')}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Estilista'),
                      subtitle: Text(turno.estilista.nombre),
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
                      child: Text('Servicios',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    ...turno.servicios.map((s) => ListTile(
                          title: Text(s.nombre),
                          trailing: Text('\$${s.precio}'),
                        )),
                    const Divider(),
                    ListTile(
                      title: const Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('\$${turno.precioTotal}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ],
                ),
              ),
              if (turno.notas != null && turno.notas!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notas',
                            style:
                                TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: Text(turno.notas!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              if (turno.estado == EstadoTurno.programado) ...[
                ElevatedButton.icon(
                  onPressed: () =>
                      context.push('/turno/${turno.id}/editar'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Turno'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _cambiarEstado(
                      context, turno, EstadoTurno.completado),
                  icon: const Icon(Icons.check),
                  label: const Text('Completar'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _cambiarEstado(
                      context, turno, EstadoTurno.cancelado),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancelar'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ] else ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Este turno ya no se puede modificar.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}