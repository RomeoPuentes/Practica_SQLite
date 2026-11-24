import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('La base de datos permite realizar operaciones CRUD', () async {
    // Crear
    final id = await database.insertarTarea('Estudiar Flutter');

    var tareas = await database.select(database.tareas).get();

    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Estudiar Flutter');
    expect(tareas.first.completada, false);

    // Actualizar título
    await database.actualizarTitulo(id, 'Estudiar SQLite');

    tareas = await database.select(database.tareas).get();
    expect(tareas.first.titulo, 'Estudiar SQLite');

    // Actualizar estado
    await database.actualizarEstado(id, true);

    tareas = await database.select(database.tareas).get();
    expect(tareas.first.completada, true);

    // Eliminar
    await database.eliminarTarea(id);

    tareas = await database.select(database.tareas).get();
    expect(tareas, isEmpty);
  });
}
