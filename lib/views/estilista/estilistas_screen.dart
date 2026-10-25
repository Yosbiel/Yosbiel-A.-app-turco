import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/estilista_viewmodel.dart';

class EstilistasScreen extends StatefulWidget {
  const EstilistasScreen({super.key});
  @override
  State<EstilistasScreen> createState() => _EstilistasScreenState();
}

class _EstilistasScreenState extends State<EstilistasScreen> {
  final EstilistaViewModel _viewModel = EstilistaViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Estilistas'),
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Icon(Icons.people, size: 80, color: Colors.white30),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final e = _viewModel.estilistas[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(e.nombre[0])),
                  title: Text(e.nombre),
                  subtitle: Text('${_viewModel.turnosHoy(e)} turnos hoy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/agenda?estilista=${e.id}'),
                );
              },
              childCount: _viewModel.estilistas.length,
            ),
          ),
        ],
      ),
    );
  }
}