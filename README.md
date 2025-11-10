# Aplicación de Gestión y Enseñanza de Cultivos

Aplicación móvil Android desarrollada en Flutter para la gestión y enseñanza de cultivos. Permite a los usuarios aprender sobre diferentes tipos de cultivos, sus cuidados y gestionar sus propios cultivos con recordatorios programados.

## Características

### 📚 Catálogo de Cultivos
- **Categorías**: Hortalizas, Tubérculos, Frutas, Hierbas
- **Información detallada**: Cada cultivo incluye:
  - Descripción
  - Temporada de siembra
  - Tiempo de cosecha
  - Clima ideal
  - Tipo de suelo
  - Riego
  - Cuidados
  - Plagas comunes
  - Fertilización

### 🌱 Gestión de Cultivos
- Agregar cultivos personalizados a tu lista
- Registrar fecha de siembra
- Calcular fecha estimada de cosecha
- Agregar ubicación y notas
- Visualizar días restantes para cosecha

### ⏰ Sistema de Tareas Programadas
- Programar tareas recurrentes:
  - Riego
  - Fertilización
  - Aplicación de pesticidas
  - Poda
  - Cosecha
  - Otras tareas personalizadas
- Notificaciones automáticas
- Intervalos personalizables (horas, días, semanas)
- Marcar tareas como completadas
- Visualizar tareas pendientes

## Arquitectura

La aplicación sigue el patrón **MVC (Model-View-Controller)**:

### Modelos (`lib/models/`)
- `Categoria`: Categorías de cultivos
- `Cultivo`: Información de cultivos
- `CultivoGestionado`: Cultivos del usuario
- `TareaProgramada`: Tareas programadas con timers
- `TipoTarea`: Enum de tipos de tareas

### Vistas (`lib/views/`)
- `HomeScreen`: Pantalla principal con navegación
- `CategoriasScreen`: Lista de categorías
- `CultivosScreen`: Lista de cultivos por categoría
- `CultivoDetailScreen`: Detalles de un cultivo
- `GestionScreen`: Lista de cultivos gestionados
- `CultivoGestionadoDetailScreen`: Detalles y gestión de cultivo
- `AddCultivoGestionadoScreen`: Agregar nuevo cultivo
- `TareasScreen`: Lista de tareas programadas
- `AddTareaScreen`: Agregar nueva tarea

### Controladores (`lib/controllers/`)
- `CategoryController`: Gestión de categorías
- `CultivoController`: Gestión de cultivos
- `GestionController`: Gestión de cultivos del usuario
- `TimerController`: Gestión de tareas y timers

### Servicios (`lib/services/`)
- `DatabaseService`: Base de datos SQLite local
- `NotificationService`: Notificaciones locales

## Tecnologías Utilizadas

- **Flutter**: Framework multiplataforma
- **Provider**: Gestión de estado
- **SQFlite**: Base de datos local SQLite
- **Flutter Local Notifications**: Notificaciones locales
- **Timezone**: Manejo de zonas horarias para notificaciones
- **Intl**: Formateo de fechas y números

## Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/AFlazaroo/CultivGrow.git
cd CultivGrow
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## Configuración

### Permisos de Notificaciones (Android)
Los permisos necesarios ya están configurados en `AndroidManifest.xml`:
- `POST_NOTIFICATIONS`
- `SCHEDULE_EXACT_ALARM`
- `USE_EXACT_ALARM`

### Base de Datos
La aplicación crea automáticamente una base de datos SQLite local con datos iniciales:
- 4 categorías predefinidas
- 4 cultivos de ejemplo

## Estructura del Proyecto

```
lib/
├── controllers/      # Controladores MVC
├── models/          # Modelos de datos
├── services/        # Servicios (BD, Notificaciones)
├── views/           # Vistas/Pantallas
└── main.dart        # Punto de entrada
```

## Funcionalidades Futuras

- [ ] Sincronización en la nube
- [ ] Galería de fotos de cultivos
- [ ] Registro de crecimiento con fotos
- [ ] Estadísticas y gráficos
- [ ] Compartir cultivos con otros usuarios
- [ ] Modo offline mejorado
- [ ] Más cultivos en el catálogo
- [ ] Búsqueda y filtros avanzados

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## Autor

Desarrollado como aplicación de gestión y enseñanza de cultivos.
