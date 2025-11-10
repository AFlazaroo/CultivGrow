import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/gestion_controller.dart';
import 'cultivo_gestionado_detail_screen.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  State<GestionScreen> createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GestionController>().loadCultivosGestionados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GestionController>(
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
                  onPressed: () => controller.loadCultivosGestionados(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.cultivosGestionados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No tienes cultivos gestionados',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega cultivos desde el catálogo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadCultivosGestionados(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cultivosGestionados.length,
            itemBuilder: (context, index) {
              final cultivo = controller.cultivosGestionados[index];
              return _CultivoGestionadoCard(cultivo: cultivo);
            },
          ),
        );
      },
    );
  }
}

class _CultivoGestionadoCard extends StatelessWidget {
  final dynamic cultivo;

  const _CultivoGestionadoCard({required this.cultivo});

  @override
  Widget build(BuildContext context) {
    final diasRestantes = cultivo.diasRestantes;
    final fechaCosecha = cultivo.fechaCosechaEstimada;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CultivoGestionadoDetailScreen(
                cultivoGestionadoId: cultivo.id!,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.eco,
                      size: 30,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cultivo.nombrePersonalizado.isNotEmpty
                              ? cultivo.nombrePersonalizado
                              : cultivo.cultivo?.nombre ?? 'Cultivo',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (cultivo.ubicacion.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                cultivo.ubicacion,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_today,
                      label: 'Siembra',
                      value: '${cultivo.fechaSiembra.day}/${cultivo.fechaSiembra.month}/${cultivo.fechaSiembra.year}',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.agriculture,
                      label: 'Cosecha',
                      value: '${fechaCosecha.day}/${fechaCosecha.month}/${fechaCosecha.year}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: diasRestantes > 30
                      ? Colors.green.shade50
                      : diasRestantes > 0
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      diasRestantes > 0 ? Icons.timer : Icons.check_circle,
                      color: diasRestantes > 30
                          ? Colors.green.shade700
                          : diasRestantes > 0
                              ? Colors.orange.shade700
                              : Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      diasRestantes > 0
                          ? '$diasRestantes días restantes para cosecha'
                          : 'Listo para cosechar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: diasRestantes > 30
                            ? Colors.green.shade700
                            : diasRestantes > 0
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

