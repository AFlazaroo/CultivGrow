import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/timer_controller.dart';
import 'add_tarea_screen.dart';

class TareasScreen extends StatefulWidget {
  final int cultivoGestionadoId;
  final String cultivoNombre;

  const TareasScreen({
    super.key,
    required this.cultivoGestionadoId,
    required this.cultivoNombre,
  });

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimerController>().loadTareasByCultivo(widget.cultivoGestionadoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas - ${widget.cultivoNombre}'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimerController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadTareasByCultivo(widget.cultivoGestionadoId),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (controller.tareas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No hay tareas programadas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTareaScreen(
                            cultivoGestionadoId: widget.cultivoGestionadoId,
                            cultivoNombre: widget.cultivoNombre,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Tarea'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          final tareasActivas = controller.tareas.where((t) => t.activa).toList();
          final tareasInactivas = controller.tareas.where((t) => !t.activa).toList();

          return RefreshIndicator(
            onRefresh: () => controller.loadTareasByCultivo(widget.cultivoGestionadoId),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller.tareasPendientes.isNotEmpty) ...[
                  const Text(
                    'Tareas Pendientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...controller.tareasPendientes.map((tarea) => _TareaCard(
                        tarea: tarea,
                        cultivoNombre: widget.cultivoNombre,
                        onComplete: () async {
                          await controller.marcarTareaCompletada(
                            tarea,
                            widget.cultivoNombre,
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar Tarea'),
                              content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
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

                          if (confirm == true) {
                            await controller.deleteTarea(
                              tarea.id!,
                              widget.cultivoGestionadoId,
                            );
                          }
                        },
                      )),
                  const SizedBox(height: 24),
                ],
                if (tareasActivas.isNotEmpty) ...[
                  const Text(
                    'Tareas Activas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tareasActivas.map((tarea) => _TareaCard(
                        tarea: tarea,
                        cultivoNombre: widget.cultivoNombre,
                        onComplete: () async {
                          await controller.marcarTareaCompletada(
                            tarea,
                            widget.cultivoNombre,
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar Tarea'),
                              content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
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

                          if (confirm == true) {
                            await controller.deleteTarea(
                              tarea.id!,
                              widget.cultivoGestionadoId,
                            );
                          }
                        },
                      )),
                  const SizedBox(height: 24),
                ],
                if (tareasInactivas.isNotEmpty) ...[
                  const Text(
                    'Tareas Inactivas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tareasInactivas.map((tarea) => _TareaCard(
                        tarea: tarea,
                        cultivoNombre: widget.cultivoNombre,
                        onComplete: null,
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar Tarea'),
                              content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
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

                          if (confirm == true) {
                            await controller.deleteTarea(
                              tarea.id!,
                              widget.cultivoGestionadoId,
                            );
                          }
                        },
                      )),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTareaScreen(
                cultivoGestionadoId: widget.cultivoGestionadoId,
                cultivoNombre: widget.cultivoNombre,
              ),
            ),
          );
        },
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TareaCard extends StatelessWidget {
  final dynamic tarea;
  final String cultivoNombre;
  final VoidCallback? onComplete;
  final VoidCallback onDelete;

  const _TareaCard({
    required this.tarea,
    required this.cultivoNombre,
    this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final proximaEjecucion = tarea.proximaEjecucion;
    final ultimaEjecucion = tarea.ultimaEjecucion;
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
        title: Text(
          tarea.tipoTarea.nombre,
          style: TextStyle(
            fontWeight: esPendiente ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarea.descripcion),
            const SizedBox(height: 4),
            if (proximaEjecucion != null)
              Text(
                'Próxima: ${DateFormat('dd/MM/yyyy HH:mm').format(proximaEjecucion)}',
                style: TextStyle(
                  fontSize: 12,
                  color: esPendiente ? Colors.orange.shade700 : Colors.grey.shade600,
                  fontWeight: esPendiente ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            if (ultimaEjecucion != null)
              Text(
                'Última: ${DateFormat('dd/MM/yyyy HH:mm').format(ultimaEjecucion)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            Text(
              'Intervalo: cada ${tarea.intervaloHoras} horas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (esPendiente && onComplete != null)
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: onComplete,
                tooltip: 'Marcar como completada',
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}

