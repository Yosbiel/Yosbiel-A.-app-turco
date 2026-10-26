import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/estilista_viewmodel.dart';
import '../../models/servicio.dart';

class EstilistasScreen extends StatelessWidget {
  final EstilistaViewModel estilistaVM;

  const EstilistasScreen({super.key, required this.estilistaVM});

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
                final e = estilistaVM.estilistas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(e.rutaAvatar), // Carga la foto
                    onBackgroundImageError: (_, __) {}, // Evita crash si falta la foto
                  ),
                  title: Text(e.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${estilistaVM.turnosHoy(e)} turnos hoy'),
                      const SizedBox(height: 4),
                      // Agrupación de servicios por categoría
                      ...CategoriaServicio.values.map((cat) {
                        final serviciosCat = e.serviciosQueRealiza
                            .where((s) => s.categoria == cat)
                            .toList();
                        if (serviciosCat.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Wrap(
                            spacing: 4,
                            children: serviciosCat
                                .map((s) => Chip(
                                      label: Text(s.nombre,
                                          style: const TextStyle(fontSize: 10)),
                                      visualDensity: VisualDensity.compact,
                                    ))
                                .toList(),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/agenda?estilista=${e.id}'),
                );
              },
              childCount: estilistaVM.estilistas.length,
            ),
          ),
        ],
      ),
    );
  }
}