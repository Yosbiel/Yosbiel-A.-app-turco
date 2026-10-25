import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/agenda/agenda_screen.dart';
import '../../views/cliente/clientes_screen.dart';
import '../../views/servicio/servicios_screen.dart';
import '../../views/estilista/estilistas_screen.dart';
import '../../views/turno/detalle_turno_screen.dart';
import '../../views/turno/formulario_turno_screen.dart';
import '../../models/servicio.dart';
import '../../models/cliente.dart';
import '../../viewmodels/turno_viewmodel.dart';
import '../../viewmodels/agenda_viewmodel.dart';
import '../../viewmodels/cliente_viewmodel.dart';
import '../../viewmodels/servicio_viewmodel.dart';
import '../../viewmodels/estilista_viewmodel.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static GoRouter router(
    Function(ThemeMode) cambiarTema, {
    required TurnoViewModel turnoVM,
    required AgendaViewModel agendaVM,
    required ClienteViewModel clienteVM,
    required ServicioViewModel servicioVM,
    required EstilistaViewModel estilistaVM,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/agenda',
      routes: [
        // ================== SHELL PRINCIPAL ==================
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) => navigationShell.goBranch(index),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today), label: 'Agenda'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: 'Clientes'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.cut), label: 'Servicios'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Estilistas'),
                ],
              ),
            );
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/agenda',
                builder: (context, state) {
                  final estilistaId =
                      state.uri.queryParameters['estilista'];
                  return AgendaScreen(
                    turnoVM: turnoVM,
                    agendaVM: agendaVM,
                    estilistaIdInicial: estilistaId,
                    onCambiarTema: cambiarTema,
                  );
                },
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/clientes',
                builder: (context, state) =>
                    ClientesScreen(clienteVM: clienteVM),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/servicios',
                builder: (context, state) =>
                    ServiciosScreen(servicioVM: servicioVM),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/estilistas',
                builder: (context, state) =>
                    EstilistasScreen(estilistaVM: estilistaVM),
              ),
            ]),
          ],
        ),

        // ================== RUTAS FUERA DEL SHELL ==================

        // NUEVO TURNO
        GoRoute(
          path: '/turno/nuevo',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra;
            Servicio? servicioInicial;
            Cliente? clienteInicial;
            DateTime? fechaInicial;

            if (extra is Servicio) servicioInicial = extra;
            if (extra is Cliente) clienteInicial = extra;
            if (extra is DateTime) fechaInicial = extra;

            return FormularioTurnoScreen(
              turnoVM: turnoVM,
              clienteVM: clienteVM,
              servicioInicial: servicioInicial,
              clienteInicial: clienteInicial,
              fechaInicial: fechaInicial,
            );
          },
        ),

        // DETALLE
        GoRoute(
          path: '/turno/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => DetalleTurnoScreen(
            turnoId: state.pathParameters['id']!,
            turnoVM: turnoVM,
          ),
        ),

        // EDITAR
        GoRoute(
          path: '/turno/:id/editar',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final idTurno = state.pathParameters['id']!;
            final turno = turnoVM.buscarTurno(idTurno);
            if (turno == null) {
              return _TurnoNoEncontrado(
                onVolver: () => context.pop(),
              );
            }
            return FormularioTurnoScreen(
              turnoVM: turnoVM,
              clienteVM: clienteVM,
              turnoAEditar: turno,
            );
          },
        ),
      ],
    );
  }
}

// ===== Pantalla de error para ruta inválida =====
class _TurnoNoEncontrado extends StatelessWidget {
  final VoidCallback onVolver;
  const _TurnoNoEncontrado({required this.onVolver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turno')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text(
                'El turno no existe o fue eliminado.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onVolver,
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}