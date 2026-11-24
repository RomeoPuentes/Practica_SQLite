import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart' as modelo;

part 'database.g.dart';

// Tabla de tareas.
@DataClassName('TareaDb')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 1, max: 255)();

  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

// Base de datos principal.
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'gestor_tareas',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  // Constructor para pruebas.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  // CONSULTAR: observar todas las tareas.
  Stream<List<modelo.Tarea>> observarTareas() {
    return (select(
      tareas,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).watch().map(
      (registros) => registros
          .map(
            (registro) => modelo.Tarea(
              id: registro.id,
              titulo: registro.titulo,
              completada: registro.completada,
            ),
          )
          .toList(),
    );
  }

  // AGREGAR: insertar una tarea.
  Future<int> insertarTarea(String titulo) {
    return into(tareas).insert(TareasCompanion.insert(titulo: titulo.trim()));
  }

  // EDITAR: modificar el título.
  Future<void> actualizarTitulo(int id, String nuevoTitulo) async {
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(titulo: Value(nuevoTitulo.trim())),
    );
  }

  // ACTUALIZAR: cambiar el estado.
  Future<void> actualizarEstado(int id, bool completada) async {
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  // ELIMINAR: borrar una tarea.
  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((t) => t.id.equals(id))).go();
  }
}
