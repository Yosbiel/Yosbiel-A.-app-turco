import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/servicio_viewmodel.dart';
import '../../models/servicio.dart';

class ServiciosScreen extends StatelessWidget {
  final ServicioViewModel servicioVM;

  const ServiciosScreen({super.key, required this.servicioVM});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: servicioVM,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Servicios')),
          body: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: servicioVM.filtroCategoria == null,
                      onSelected: (_) => servicioVM.cambiarFiltroCategoria(null),
                    ),
                    const SizedBox(width: 8),
                    ...CategoriaServicio.values.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(cat.name),
                            selected: servicioVM.filtroCategoria == cat,
                            onSelected: (_) => servicioVM.cambiarFiltroCategoria(cat),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<PublicoObjetivo?>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(value: PublicoObjetivo.mujeres, label: Text('Mujeres')),
                    ButtonSegment(value: PublicoObjetivo.hombres, label: Text('Hombres')),
                  ],
                  selected: {servicioVM.filtroPublico},
                  onSelectionChanged: (s) {
                    servicioVM.cambiarFiltroPublico(s.first);
                  },
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 13)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  int cols = 2;
                  if (constraints.maxWidth >= 840) {
                    cols = 4;
                  } else if (constraints.maxWidth >= 600) {
                    cols = 3;
                  }
                  final servicios = servicioVM.serviciosFiltrados;
                  if (servicios.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No hay servicios con estos filtros.'),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: servicios.length,
                    itemBuilder: (context, index) {
                      final s = servicios[index];
                      return InkWell(
                        onTap: () => context.push('/turno/nuevo', extra: s),
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset( // <-- Aquí carga la foto
                                    'assets/servicios/${s.categoria.name}.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported, size: 40),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(s.nombre,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${s.duracionMinutos} min'),
                                Text('\$${s.precio}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}