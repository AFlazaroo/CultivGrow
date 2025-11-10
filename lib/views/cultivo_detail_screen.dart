import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cultivo_controller.dart';
import 'add_cultivo_gestionado_screen.dart';

class CultivoDetailScreen extends StatefulWidget {
  final int cultivoId;

  const CultivoDetailScreen({super.key, required this.cultivoId});

  @override
  State<CultivoDetailScreen> createState() => _CultivoDetailScreenState();
}

class _CultivoDetailScreenState extends State<CultivoDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CultivoController>().loadCultivoById(widget.cultivoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CultivoController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null || controller.cultivoSeleccionado == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error ?? 'Error al cargar cultivo',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadCultivoById(widget.cultivoId),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final cultivo = controller.cultivoSeleccionado!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.green.shade700,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(cultivo.nombre),
                  background: cultivo.imagen.isNotEmpty
                      ? Image.network(
                          cultivo.imagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green.shade100,
                              child: const Icon(Icons.eco, size: 80, color: Colors.green),
                            );
                          },
                        )
                      : Container(
                          color: Colors.green.shade100,
                          child: const Icon(Icons.eco, size: 80, color: Colors.green),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoSection(
                        title: 'Descripción',
                        content: cultivo.descripcion,
                        icon: Icons.info,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Temporada',
                        content: cultivo.temporada,
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Tiempo de Cosecha',
                        content: '${cultivo.diasCosecha} días desde la siembra',
                        icon: Icons.access_time,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Clima',
                        content: cultivo.clima,
                        icon: Icons.wb_sunny,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Tipo de Suelo',
                        content: cultivo.suelo,
                        icon: Icons.landscape,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Riego',
                        content: cultivo.riego,
                        icon: Icons.water_drop,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Cuidados',
                        content: cultivo.cuidados,
                        icon: Icons.healing,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Plagas Comunes',
                        content: cultivo.plagas,
                        icon: Icons.bug_report,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Fertilización',
                        content: cultivo.fertilizacion,
                        icon: Icons.science,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCultivoGestionadoScreen(
                                  cultivoId: cultivo.id!,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar a Mis Cultivos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _InfoSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

