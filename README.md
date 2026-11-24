# Gestor de tareas local – Flutter y SQLite

## Descripción

Aplicación desarrollada con Flutter para administrar tareas mediante una base de datos SQLite local. Permite registrar, consultar, editar, completar y eliminar tareas.

## Objetivo

Implementar persistencia local utilizando SQLite y comprobar las operaciones CRUD desde una interfaz desarrollada en Flutter.

## Tecnologías utilizadas

- Flutter
- Dart
- SQLite
- Drift
- drift_flutter
- Flutter Test

## Funcionalidades

- Registrar nuevas tareas.
- Visualizar las tareas guardadas.
- Editar el título de una tarea.
- Marcar tareas como completadas.
- Eliminar tareas.
- Validar que los títulos no estén vacíos ni contengan únicamente espacios.
- Conservar los registros después de cerrar y volver a abrir la aplicación.

## Base de datos

Se utiliza Drift como herramienta para trabajar con SQLite.

La tabla de tareas contiene:

| Campo | Descripción |
|---|---|
| id | Identificador autoincremental |
| titulo | Nombre de la tarea |
| completada | Estado de la tarea |

## Estructura principal

```text
lib/
├── data/
│   ├── database.dart
│   └── database.g.dart
├── models/
│   └── tarea.dart
├── ui/
│   └── tareas_page.dart
└── main.dart

test/
└── widget_test.dart

web/
├── index.html
├── sqlite3.wasm
└── drift_worker.js
```

## Instalación y ejecución

1. Descargar o clonar el proyecto.
2. Abrir una terminal en la carpeta del proyecto.
3. Instalar las dependencias:

```bash
flutter pub get
```

4. Ejecutar en Chrome:

```bash
flutter run -d chrome
```

5. Ejecutar en Android utilizando el identificador del dispositivo:

```bash
flutter devices
flutter run -d ID_DEL_DISPOSITIVO
```

## Pruebas

Para ejecutar las pruebas automatizadas:

```bash
flutter test
```

Para analizar el proyecto:

```bash
flutter analyze
```

Resultados obtenidos:
- `flutter test`: dos pruebas aprobadas.
- `flutter analyze`: sin problemas detectados.

## Plataformas verificadas

- Web: Google Chrome.
- Móvil: dispositivo Android.

## Persistencia

Se comprobó que las tareas permanecen almacenadas después de recargar el navegador y cerrar y volver a abrir la aplicación Android.

## Autor

Nombre: Romeo Issac Puentes Delfin

Materia: Programación de Dispositivos Móviles

Grupo: 7 B 