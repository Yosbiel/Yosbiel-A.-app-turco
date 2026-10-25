import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'viewmodels/turno_viewmodel.dart';
import 'viewmodels/agenda_viewmodel.dart';
import 'viewmodels/cliente_viewmodel.dart';
import 'viewmodels/servicio_viewmodel.dart';
import 'viewmodels/estilista_viewmodel.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const TurcoApp());
}

class TurcoApp extends StatefulWidget {
  const TurcoApp({super.key});

  @override
  State<TurcoApp> createState() => _TurcoAppState();
}

class _TurcoAppState extends State<TurcoApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // ===== VMs compartidos: se crean UNA SOLA VEZ =====
  late final TurnoViewModel turnoVM;
  late final AgendaViewModel agendaVM;
  late final ClienteViewModel clienteVM;
  late final ServicioViewModel servicioVM;
  late final EstilistaViewModel estilistaVM;

  @override
  void initState() {
    super.initState();
    turnoVM = TurnoViewModel();
    agendaVM = AgendaViewModel();
    clienteVM = ClienteViewModel();
    servicioVM = ServicioViewModel();
    estilistaVM = EstilistaViewModel();
  }

  @override
  void dispose() {
    turnoVM.dispose();
    agendaVM.dispose();
    clienteVM.dispose();
    servicioVM.dispose();
    estilistaVM.dispose();
    super.dispose();
  }

  void cambiarTema(ThemeMode nuevoModo) {
    setState(() => _themeMode = nuevoModo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Turco',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router(
        cambiarTema,
        turnoVM: turnoVM,
        agendaVM: agendaVM,
        clienteVM: clienteVM,
        servicioVM: servicioVM,
        estilistaVM: estilistaVM,
      ),
    );
  }
}