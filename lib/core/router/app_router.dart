import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/agenda/agenda_screen.dart';
import '../../views/cliente/clientes_screen.dart';
import '../../views/servicio/servicios_screen.dart';
import '../../views/estilista/estilistas_screen.dart';
import '../../views/turno/detalle_turno_screen.dart';
import '../../views/turno/formulario_turno_screen.dart';
import '../../data/mock_data.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  // Recibimos la función del main
  static GoRouter router(Function(ThemeMode) cambiarTema) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/agenda',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) => navigationShell.goBranch(index),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
                  BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
                  BottomNavigationBarItem(icon: Icon(Icons.cut), label: 'Servicios'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Estilistas'),
                ],
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/agenda',
                  builder: (context, state) {
                    final estilistaId = state.uri.queryParameters['estilista'];
                    // Le pasamos la función a la Agenda
                    return AgendaScreen(estilistaIdInicial: estilistaId, onCambiarTema: cambiarTema);
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/clientes', builder: (context, state) => const ClientesScreen())],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/servicios', builder: (context, state) => const ServiciosScreen())],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/estilistas', builder: (context, state) => const EstilistasScreen())],
            ),
          ],
        ),
        GoRoute(
          path: '/turno/nuevo',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const FormularioTurnoScreen(),
        ),
        GoRoute(
          path: '/turno/:id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final idTurno = state.pathParameters['id']!;
            return DetalleTurnoScreen(turnoId: idTurno);
          },
        ),
        GoRoute(
          path: '/turno/:id/editar',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final idTurno = state.pathParameters['id']!;
            // BUSCAMOS EL TURNO PARA EDITARLO
            final turno = MockData.turnos.firstWhere((t) => t.id == idTurno, orElse: () => MockData.turnos.first);
            return FormularioTurnoScreen(turnoAEditar: turno);
          },
        ),
      ],
    );
  }
}