import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/gestion_controller.dart';
import '../controllers/timer_controller.dart';
import 'tareas_screen.dart';
import 'add_tarea_screen.dart';

class CultivoGestionadoDetailScreen extends StatefulWidget {
  final int cultivoGestionadoId;

  const CultivoGestionadoDetailScreen({super.key, required this.cultivoGestionadoId});

  @override
  State<CultivoGestionadoDetailScreen> createState() => _CultivoGestionadoDetailScreenState();
}

class _CultivoGestionadoDetailScreenState extends State<CultivoGestionadoDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GestionController>().loadCultivoGestionadoById(widget.cultivoGestionadoId);
      context.read<TimerController>().loadTareasByCultivo(widget.cultivoGestionadoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<GestionController, TimerController>(
        builder: (context, gestionController, timerController, child) {
          final cultivo = gestionController.cultivoGestionadoSeleccionado;

          if (gestionController.isLoading || cultivo == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final diasRestantes = cultivo.diasRestantes;
          final fechaCosecha = cultivo.fechaCosechaEstimada;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.green.shade700,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    cultivo.nombrePersonalizado.isNotEmpty
                        ? cultivo.nombrePersonalizado
                        : cultivo.cultivo?.nombre ?? 'Cultivo',
                  ),
                  background: Container(
                    color: Colors.green.shade100,
                    child: const Icon(Icons.eco, size: 80, color: Colors.green),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Cultivo'),
                          content: const Text('¿Estás seguro de que deseas eliminar este cultivo?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        final success = await gestionController.deleteCultivoGestionado(cultivo.id!);
                        if (success && mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cultivo eliminado')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cultivo.cultivo != null) ...[
                        _InfoCard(
                          title: 'Información del Cultivo',
                          children: [
                            _InfoRow('Nombre', cultivo.cultivo!.nombre),
                            _InfoRow('Temporada', cultivo.cultivo!.temporada),
                            _InfoRow('Días de cosecha', '${cultivo.cultivo!.diasCosecha} días'),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      _InfoCard(
                        title: 'Información de Siembra',
                        children: [
                          _InfoRow(
                            'Fecha de siembra',
                            DateFormat('dd/MM/yyyy').format(cultivo.fechaSiembra),
                          ),
                          _InfoRow(
                            'Fecha estimada de cosecha',
                            DateFormat('dd/MM/yyyy').format(fechaCosecha),
                          ),
                          _InfoRow(
                            'Días restantes',
                            diasRestantes > 0
                                ? '$diasRestantes días'
                                : 'Listo para cosechar',
                          ),
                          if (cultivo.ubicacion.isNotEmpty)
                            _InfoRow('Ubicación', cultivo.ubicacion),
                        ],
                      ),
                      if (cultivo.notas.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Notas',
                          children: [
                            Text(cultivo.notas),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tareas Programadas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TareasScreen(
                                    cultivoGestionadoId: widget.cultivoGestionadoId,
                                    cultivoNombre: cultivo.nombrePersonalizado.isNotEmpty
                                        ? cultivo.nombrePersonalizado
                                        : cultivo.cultivo?.nombre ?? 'Cultivo',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (timerController.tareas.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.task_alt, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No hay tareas programadas',
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ...timerController.tareas.take(3).map((tarea) => _TareaCard(
                              tarea: tarea,
                              cultivoNombre: cultivo.nombrePersonalizado.isNotEmpty
                                  ? cultivo.nombrePersonalizado
                                  : cultivo.cultivo?.nombre ?? 'Cultivo',
                            )),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTareaScreen(
                                  cultivoGestionadoId: widget.cultivoGestionadoId,
                                  cultivoNombre: cultivo.nombrePersonalizado.isNotEmpty
                                      ? cultivo.nombrePersonalizado
                                      : cultivo.cultivo?.nombre ?? 'Cultivo',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Tarea'),
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

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _TareaCard extends StatelessWidget {
  final dynamic tarea;
  final String cultivoNombre;

  const _TareaCard({required this.tarea, required this.cultivoNombre});

  @override
  Widget build(BuildContext context) {
    final proximaEjecucion = tarea.proximaEjecucion;
    final ahora = DateTime.now();
    final esPendiente = proximaEjecucion != null && proximaEjecucion.isBefore(ahora);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: esPendiente ? Colors.orange.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(tarea.tipoTarea.icono),
        ),
        title: Text(tarea.tipoTarea.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarea.descripcion),
            if (proximaEjecucion != null)
              Text(
                'Próxima: ${DateFormat('dd/MM/yyyy HH:mm').format(proximaEjecucion)}',
                style: TextStyle(
                  fontSize: 12,
                  color: esPendiente ? Colors.orange.shade700 : Colors.grey.shade600,
                  fontWeight: esPendiente ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
        trailing: esPendiente
            ? Chip(
                label: const Text('Pendiente', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.orange.shade200,
              )
            : null,
      ),
    );
  }
}

