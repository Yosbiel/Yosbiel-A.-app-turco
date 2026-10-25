import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- Necesario para la navegación
import '../../viewmodels/servicio_viewmodel.dart';
import '../../models/servicio.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});
  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final ServicioViewModel _viewModel = ServicioViewModel();

  @override
  void dispose() { _viewModel.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Servicios')),
          body: Column(
            children: [
              // Filtro por categoría
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: _viewModel.filtroCategoria == null,
                      onSelected: (_) => _viewModel.cambiarFiltroCategoria(null),
                    ),
                    const SizedBox(width: 8),
                    ...CategoriaServicio.values.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat.name),
                        selected: _viewModel.filtroCategoria == cat,
                        onSelected: (_) => _viewModel.cambiarFiltroCategoria(cat),
                      ),
                    )),
                  ],
                ),
              ),

              // Filtro por público
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<PublicoObjetivo?>(
                  segments: const [
                    ButtonSegment(value: null, label: Text('Todos')),
                    ButtonSegment(value: PublicoObjetivo.mujeres, label: Text('Mujeres')),
                    ButtonSegment(value: PublicoObjetivo.hombres, label: Text('Hombres')),
                  ],
                  selected: {_viewModel.filtroPublico},
                  onSelectionChanged: (Set<PublicoObjetivo?> newSelection) {
                    _viewModel.cambiarFiltroPublico(newSelection.first);
                  },
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Cuadrícula
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _viewModel.serviciosFiltrados.length,
                  itemBuilder: (context, index) {
                    final s = _viewModel.serviciosFiltrados[index];
                    return InkWell( // <-- Añadido para detectar el toque
                      onTap: () {
                        // Navega al formulario pasando el servicio
                        context.push('/turno/nuevo', extra: s);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.content_cut, size: 40),
                              const SizedBox(height: 8),
                              Text(s.nombre, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${s.duracionMinutos} min'),
                              Text('\$${s.precio}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}