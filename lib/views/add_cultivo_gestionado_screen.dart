import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/cultivo_controller.dart';
import '../controllers/gestion_controller.dart';
import '../models/cultivo_gestionado.dart';

class AddCultivoGestionadoScreen extends StatefulWidget {
  final int? cultivoId;

  const AddCultivoGestionadoScreen({super.key, this.cultivoId});

  @override
  State<AddCultivoGestionadoScreen> createState() => _AddCultivoGestionadoScreenState();
}

class _AddCultivoGestionadoScreenState extends State<AddCultivoGestionadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _notasController = TextEditingController();
  DateTime _fechaSiembra = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.cultivoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CultivoController>().loadCultivoById(widget.cultivoId!);
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSiembra,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaSiembra) {
      setState(() {
        _fechaSiembra = picked;
      });
    }
  }

  Future<void> _saveCultivo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.cultivoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se especificó el cultivo')),
      );
      return;
    }

    final cultivo = CultivoGestionado(
      cultivoId: widget.cultivoId!,
      nombrePersonalizado: _nombreController.text.trim(),
      fechaSiembra: _fechaSiembra,
      ubicacion: _ubicacionController.text.trim(),
      notas: _notasController.text.trim(),
    );

    final gestionController = context.read<GestionController>();
    final success = await gestionController.addCultivoGestionado(cultivo);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cultivo agregado exitosamente')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gestionController.error ?? 'Error al agregar cultivo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cultivo'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CultivoController>(
        builder: (context, cultivoController, child) {
          final cultivo = cultivoController.cultivoSeleccionado;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cultivo != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.eco, size: 40, color: Colors.green.shade700),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cultivo.nombre,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cultivo.descripcion,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre personalizado (opcional)',
                      hintText: 'Ej: Tomates del jardín',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de siembra',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_fechaSiembra),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ubicacionController,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación (opcional)',
                      hintText: 'Ej: Jardín trasero, Invernadero',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notasController,
                    decoration: const InputDecoration(
                      labelText: 'Notas (opcional)',
                      hintText: 'Observaciones adicionales',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCultivo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Guardar Cultivo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

