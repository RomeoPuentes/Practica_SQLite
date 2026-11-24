import 'package:flutter/material.dart';

import '../data/database.dart';
import '../models/tarea.dart';

// Pantalla base SIN persistencia ni operaciones CRUD implementadas.
// Conserva las indicaciones TODO para orientar tu trabajo.
class TareasPage extends StatefulWidget {
  final AppDatabase database;
  const TareasPage({super.key, required this.database});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  //List<Tarea> _tareas = [];
  late final Stream<List<Tarea>> _tareasStream;

  @override
  void initState() {
    super.initState();
    _tareasStream = widget.database.observarTareas();
  }

  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      _pendiente('El título no puede estar vacío');
      return;
    }

    try {
      await widget.database.insertarTarea(titulo);
      _tituloController.clear();
    } catch (e) {
      _pendiente('Error al agregar la tarea: $e');
    }
  }

  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    await widget.database.actualizarEstado(tarea.id, completada);
  }

  Future<void> _editarTarea(Tarea tarea) async {
    String nuevoTitulo = tarea.titulo;
    final resultado = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextFormField(
          initialValue: tarea.titulo,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nuevo título'),
          onChanged: (valor) {
            nuevoTitulo = valor;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(nuevoTitulo.trim());
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (resultado == null || resultado.isEmpty) {
      return;
    }
    await widget.database.actualizarTitulo(tarea.id, resultado);
    if (mounted) {
      _pendiente('Tarea actualizada correctamente');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Estás seguro de eliminar la tarea "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await widget.database.eliminarTarea(tarea.id);

      if (mounted) {
        _pendiente('Tarea eliminada correctamente');
      }
    }
  }

  void _pendiente(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _agregarTarea(),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Tarea>>(
                stream: _tareasStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar tareas: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tareas = snapshot.data!;
                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text('Todavía no hay tareas guardadas'),
                    );
                  }
                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (valor) {
                              if (valor != null) {
                                _alternarCompletada(tarea, valor);
                              }
                            },
                          ),
                          title: Text(
                            tarea.titulo,
                            style: TextStyle(
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text('ID: ${tarea.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editarTarea(tarea),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _eliminarTarea(tarea),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
