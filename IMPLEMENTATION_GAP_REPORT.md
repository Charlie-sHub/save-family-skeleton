# IMPLEMENTATION_GAP_REPORT

Inspección realizada sobre `test.md`, `README.md`, `apps/mobile_app/lib/navigation/app_router.dart`, `modules/home/`, `modules/savings_goals/`, `packages/design_system/`, `packages/localizations/` y los `pubspec.yaml` relevantes.  
No se implementó la feature; este documento describe el gap actual contra la consigna.

## 1. Estructura relevante actual

```text
apps/mobile_app/
  lib/
    app.dart
    core/init_app.dart
    navigation/app_router.dart

modules/
  activity/
    lib/src/activity_builder.dart
    lib/src/activity_screen.dart
  home/
    lib/home.dart
    lib/src/home_builder.dart
    lib/src/home_screen.dart
    lib/src/presentation/state/home_view_model.dart
    lib/src/presentation/state/home_view_state.dart
  savings_goals/
    lib/savings_goals.dart                # archivo vacío
    pubspec.yaml

packages/
  design_system/
    lib/src/theme/theme_module.dart
    lib/src/theme/theme_port.dart
    lib/src/widgets/loading_indicator.dart
    lib/src/widgets/primary_button.dart
    lib/src/widgets/text_input.dart
  localizations/
    assets/l10n/en.json
    assets/l10n/es.json
    lib/src/context_extension.dart
    lib/src/generated/i18n.dart
  navigation/
    lib/src/app_routes.dart
    lib/src/navigation_contract.dart
```

Observaciones puntuales:

- `modules/savings_goals/lib/savings_goals.dart` está vacío y no existe `lib/src/`.
- `modules/home/` es la referencia viva para builder + screen + `Notifier<ViewState>`, pero no trae ejemplo de capas `data/domain/providers`.
- `apps/mobile_app/lib/navigation/app_router.dart` solo registra `home` y `activity` dentro del `StatefulShellRoute`.
- No encontré `test/` ni `*_test.dart` en `modules/home/`, `modules/savings_goals/` ni en los packages compartidos.

## 2. Qué ya existe y se puede reutilizar

### Patrón de builders y wiring de router

- `modules/home/lib/src/home_builder.dart` y `modules/activity/lib/src/activity_builder.dart` muestran el patrón esperado: clase `const`, método `buildPage(BuildContext, GoRouterState)` y retorno de `MaterialPage`.
- `apps/mobile_app/lib/navigation/app_router.dart` ya tiene el shell con tabs y es el punto correcto para anidar las rutas nuevas bajo la rama de Home.

### Patrón de pantalla + view model + view state

- `modules/home/lib/src/presentation/state/home_view_model.dart` muestra el uso actual de `NotifierProvider.autoDispose<..., ...>` con un `Notifier<ViewState>`.
- `modules/home/lib/src/presentation/state/home_view_state.dart` muestra el patrón de `@freezed` para `ViewState` y enums de eventos de error/éxito.
- `modules/home/lib/src/home_screen.dart` muestra:
  - `ref.watch(...)` para estado.
  - `ref.read(...notifier)` para acciones.
  - `ref.listen(...)` para traducir eventos a UI side effects.
  - limpieza explícita de eventos con `clearEvents()`.

### Design system y theming

- `packages/design_system/lib/src/theme/theme_module.dart` expone `themePortProvider`.
- `packages/design_system/lib/src/theme/theme_port.dart` y `theme_adapter.dart` definen los tokens de color disponibles.
- Widgets reutilizables ya listos:
  - `PrimaryButton`
  - `SfTextInput`
  - `LoadingIndicator`

### Localización

- `packages/localizations/lib/src/context_extension.dart` define `context.translate(...)`.
- `packages/localizations/lib/src/generated/i18n.dart` centraliza las keys.
- `packages/localizations/assets/l10n/en.json` y `es.json` son la fuente de strings visibles.

### Dependencias y bootstrap

- `apps/mobile_app/pubspec.yaml` ya depende de `home`, `activity` y `savings_goals`.
- `modules/savings_goals/pubspec.yaml` ya incluye `flutter_riverpod`, `freezed_annotation`, `json_annotation`, `go_router`, `design_system`, `localizations` y `navigation`.
- `apps/mobile_app/lib/core/init_app.dart` ya inicializa `navigationModule()`, `themePackages()` y `configureAppRouter()`.

## 3. Qué falta para completar la feature

### Routing

Estado actual:

- `packages/navigation/lib/src/app_routes.dart` solo define `home` y `activity`.
- `apps/mobile_app/lib/navigation/app_router.dart` no importa `savings_goals` ni registra rutas de lista, creación o detalle.
- `modules/savings_goals/lib/savings_goals.dart` no exporta builders.

Falta:

- Extender `packages/navigation/lib/src/app_routes.dart` con helpers para rutas dinámicas de:
  - `/children/:childId/savings-goals`
  - `/children/:childId/savings-goals/new`
  - `/children/:childId/savings-goals/:goalId`
- Crear y exportar los builders de `savings_goals` desde `modules/savings_goals/lib/savings_goals.dart`.
- Anidar las tres rutas nuevas dentro de la rama `home` en `apps/mobile_app/lib/navigation/app_router.dart`.

Patrón local a seguir:

- `modules/home/lib/src/home_builder.dart`
- `apps/mobile_app/lib/navigation/app_router.dart`

### Feature structure

Estado actual:

- `modules/savings_goals/` no tiene `lib/src/`, `features/`, `core/` ni tests.

Falta:

- Crear la estructura pedida en `test.md`:
  - `lib/src/features/list/...`
  - `lib/src/features/create/...`
  - `lib/src/features/detail/...`
  - `lib/src/core/data/...`
  - `lib/src/core/domain/...`
  - `lib/src/core/providers/...`
- Definir `lib/savings_goals.dart` como punto de export público del módulo.

Patrón local a seguir:

- `modules/home/lib/home.dart` como referencia de exports públicos.

### Data layer

Estado actual:

- No existe ningún datasource, modelo, repositorio ni almacenamiento en memoria en `modules/savings_goals/`.

Falta:

- Crear la interfaz `SavingsGoalsRemoteDatasource`.
- Crear la implementación fake en memoria con `Future.delayed(const Duration(milliseconds: 600))`.
- Seedear `child-1` y `child-2` con 3 goals cada uno.
- Simular los comportamientos exigidos:
  - `fetchGoals(childId)` con error cuando `childId == 'child-error'`
  - `createGoal(...)` con conflicto por nombre duplicado y mensaje exacto `"Goal name already exists"`
  - `updateProgress(...)` con fallo de red una vez cada 5 intentos
  - `deleteGoal(...)` OK siempre
- Crear modelos Freezed/JSON para request/response del datasource.
- Crear la implementación del repositorio que consuma la interfaz del datasource, no la impl directa.
- Mapear excepciones del datasource a errores tipados del dominio en el repositorio.

Archivos esperables:

- `modules/savings_goals/lib/src/core/data/datasource/savings_goals_remote_datasource.dart`
- `modules/savings_goals/lib/src/core/data/datasource/savings_goals_remote_datasource_impl.dart`
- `modules/savings_goals/lib/src/core/data/models/...`
- `modules/savings_goals/lib/src/core/data/repositories/savings_goals_repository_impl.dart`

### Domain layer

Estado actual:

- No existe ninguna entidad ni contrato de repositorio para la feature.

Falta:

- Crear entidades Freezed para no exponer models directamente en UI.
- Crear la interfaz del repositorio de dominio.
- Definir errores/failures tipados que permitan distinguir al menos:
  - conflicto por nombre duplicado
  - error de red / carga
  - error genérico
- Resolver una entidad o proyección de resumen para Home.

Archivos esperables:

- `modules/savings_goals/lib/src/core/domain/entities/savings_goal.dart`
- `modules/savings_goals/lib/src/core/domain/entities/child_savings_summary.dart`
- `modules/savings_goals/lib/src/core/domain/repositories/savings_goals_repository.dart`
- `modules/savings_goals/lib/src/core/domain/...` para failures o errores tipados

Nota:

- `modules/home/` no ofrece ejemplo de `domain/data`, así que esta parte hay que construirla siguiendo la consigna y manteniendo el estilo del repo.

### Providers

Estado actual:

- Solo existe un provider de referencia en `modules/home/lib/src/presentation/state/home_view_model.dart`.
- No hay ningún provider en `modules/savings_goals/`.
- No hay ejemplos locales de `family`.

Falta:

- Provider del datasource fake.
- Provider del repositorio.
- `NotifierProvider.autoDispose.family` para pantalla de lista parametrizada por `childId`.
- `NotifierProvider.autoDispose.family` para pantalla de detalle parametrizada por `childId` y `goalId`, o por un parámetro compuesto.
- Provider o API pública para que `home` pueda leer los resúmenes de niños sin conocer la implementación interna.

Patrones locales a seguir:

- `modules/home/lib/src/presentation/state/home_view_model.dart`
- `packages/design_system/lib/src/theme/theme_module.dart` como referencia de provider compartido simple

### List screen

Estado actual:

- No existen builder, screen, view model ni view state para la lista.

Falta:

- Crear:
  - `savings_goals_list_builder.dart`
  - `savings_goals_list_screen.dart`
  - `presentation/state/savings_goals_list_view_model.dart`
  - `presentation/state/savings_goals_list_view_state.dart`
- Implementar estados visibles:
  - `loading`
  - `empty` con CTA
  - `error` con retry
  - `success`
- Mostrar items con:
  - nombre
  - monto objetivo
  - monto actual
  - porcentaje / barra de progreso
  - acción eliminar
- Agregar pull-to-refresh.
- Agregar FAB que navegue a create.
- Escuchar eventos con `ref.listen(...)` y traducir strings en widget vía `I18n.*`.

Patrón local a seguir:

- `modules/home/lib/src/home_screen.dart`
- `modules/home/lib/src/presentation/state/home_view_state.dart`

### Create screen

Estado actual:

- No existe ningún flujo de formulario ni validación.

Falta:

- Crear:
  - `savings_goals_create_builder.dart`
  - `savings_goals_create_screen.dart`
  - `presentation/state/savings_goals_create_view_model.dart`
  - `presentation/state/savings_goals_create_view_state.dart`
- Modelar validación en tiempo real para:
  - `name` entre 3 y 40 chars
  - `targetAmount` decimal > 0 y <= 10000
  - `description` opcional y <= 200 chars
- Deshabilitar submit mientras el formulario sea inválido.
- En éxito:
  - volver a la lista
  - mostrar snackbar
- En conflicto:
  - mostrar el mensaje exacto del backend

Gap adicional detectado:

- `packages/design_system/lib/src/widgets/text_input.dart` soporta `errorText`, `onChanged`, `keyboardType` y `maxLength`, pero no soporta `maxLines`. Si la descripción debe ser multilinea, habrá que extender este widget o crear una variante mínima en `design_system`.

### Detail screen

Estado actual:

- No existe builder, screen, view model ni view state para detalle/progreso.

Falta:

- Crear:
  - `savings_goal_detail_builder.dart`
  - `savings_goal_detail_screen.dart`
  - `presentation/state/savings_goal_detail_view_model.dart`
  - `presentation/state/savings_goal_detail_view_state.dart`
- Mostrar la info de la meta y un input para aporte positivo.
- Calcular el nuevo total antes de llamar al update si se interpreta la consigna literalmente.
- Mostrar el diálogo de "meta alcanzada" una sola vez usando evento de éxito + `ref.listen(...)`, no desde `build`.

### Home integration

Estado actual:

- `modules/home/lib/src/presentation/state/home_view_state.dart` solo tiene `isLoading`, `counter`, `errorEvent` y `successEvent`.
- `modules/home/lib/src/presentation/state/home_view_model.dart` no depende de ninguna capa externa; solo incrementa un contador local.
- `modules/home/lib/src/home_screen.dart` muestra texto placeholder y un botón de refresh.
- `modules/home/pubspec.yaml` no depende de `savings_goals`.

Falta:

- Reemplazar el placeholder por 2 cards de niños con:
  - nombre
  - cantidad de metas
  - progreso total
  - navegación a la lista de la feature
- Extender `HomeViewState` para contener la colección de resúmenes de niños.
- Cambiar `HomeViewModel` para obtener esos resúmenes desde una API pública de savings goals.
- Reemplazar la UI actual en `HomeScreen`.
- Resolver la dependencia entre módulos.

Archivos a modificar casi seguro:

- `modules/home/pubspec.yaml`
- `modules/home/lib/src/presentation/state/home_view_state.dart`
- `modules/home/lib/src/presentation/state/home_view_model.dart`
- `modules/home/lib/src/home_screen.dart`
- `packages/navigation/lib/src/app_routes.dart`

### Localization

Estado actual:

- Solo existen keys genéricas y de `home` / `activity`.
- No hay ninguna key para Savings Goals.

Falta:

- Agregar keys nuevas en:
  - `packages/localizations/assets/l10n/en.json`
  - `packages/localizations/assets/l10n/es.json`
  - `packages/localizations/lib/src/generated/i18n.dart`
- Cubrir al menos:
  - títulos de lista/create/detail
  - estados empty/error
  - copy de cards/resúmenes
  - labels de formulario
  - mensajes de validación
  - snackbar de create/delete/update
  - diálogo de meta alcanzada

Patrón local a seguir:

- `packages/localizations/lib/src/context_extension.dart`
- `modules/home/lib/src/home_screen.dart`

### Design system needs

Estado actual:

- El design system solo expone `PrimaryButton`, `SfTextInput`, `LoadingIndicator` y `themePortProvider`.
- Los colores disponibles alcanzan para componer pantallas, pero no hay widgets de card, empty state, error state ni progress bar.

Falta:

- Reutilizar lo ya existente donde aplique:
  - `PrimaryButton`
  - `SfTextInput`
  - `LoadingIndicator`
  - `ThemeCode` + `themePortProvider`
- Evaluar agregar solo lo mínimo realmente repetido por la feature.

Posibles faltantes concretos:

- una card reutilizable para niño/meta si se usa en más de una pantalla
- un widget de barra de progreso con theme
- soporte multilinea en `SfTextInput` para la descripción

Recomendación de mínima:

- no crear abstracciones nuevas salvo que un mismo patrón aparezca al menos en Home + List o List + Detail

### Tests

Estado actual:

- No hay tests existentes que sirvan como base.

Falta:

- Crear `test/` dentro de `modules/savings_goals/`.
- Cubrir como mínimo:
  - repository / mapeo de errores
  - view model de la lista
  - validación del formulario de creación
- Usar fakes controlados para el datasource en tests del repositorio.
- Usar `ProviderContainer` y overrides para tests de view model.

Archivos esperables:

- `modules/savings_goals/test/core/data/repositories/savings_goals_repository_impl_test.dart`
- `modules/savings_goals/test/features/list/presentation/state/savings_goals_list_view_model_test.dart`
- `modules/savings_goals/test/features/create/presentation/state/savings_goals_create_view_model_test.dart`

## 4. Riesgos o decisiones abiertas que requieren criterio

1. **Dependencia Home -> Savings Goals**  
   La consigna pide que Home consuma datos de savings goals, pero también sugiere evitar acoplamiento directo. Hoy no existe un package compartido para ese contrato.  
   Camino mínimo viable: exponer desde `savings_goals` una API pública de lectura y hacer que `home` dependa solo de esa superficie.  
   Camino más desacoplado: extraer un contrato compartido a `packages/`, pero eso agranda el diff.

2. **Dónde viven los nombres de los niños**  
   La consigna permite hardcodear `"Lucía"` y `"Mateo"`, pero esos datos no forman parte del datasource requerido.  
   Camino mínimo viable: mantener el mapping `childId -> displayName` fuera del datasource fake, idealmente en Home o en una proyección de lectura muy acotada.

3. **Semántica de `updateProgress(goalId, amount)`**  
   El método se llama `updateProgress`, pero la pantalla captura un aporte y la consigna dice “llama a `updateProgress` con el nuevo total”.  
   Conviene dejar explícito en el view model que el usuario ingresa aporte y que el repositorio recibe `newTotal`.

4. **Forma del error tipado de dominio**  
   No hay un patrón local de `Failure`, `Result` o `Either`.  
   Camino mínimo viable: errores/excepciones de dominio tipadas desde el repositorio y mapeo a `ErrorEvent` en los view models.

5. **Alcance de las extensiones del design system**  
   La feature puede tentar a agregar varios widgets nuevos.  
   Conviene agregar solo piezas claramente reutilizables; el resto puede resolverse con Material + `themePortProvider`.

6. **`modules/home/` no cubre todas las capas pedidas**  
   Sirve como referencia para builder, view model, view state y side effects, pero no para repository/datasource/entities.  
   Ese vacío obliga a tomar decisiones nuevas; conviene mantenerlas pequeñas y alineadas con `test.md`.

## 5. Orden recomendado de implementación en pasos chicos y revisables

1. **Fundación del módulo**
   Crear `lib/src/`, exports públicos, builders vacíos y helpers de rutas en `AppRoutes`.

2. **Dominio y data base**
   Crear entidades, contrato de repositorio, datasource fake en memoria, models y repository impl con mapeo de errores.

3. **Providers**
   Conectar datasource + repositorio + providers `family` necesarios para la feature.

4. **Lista**
   Implementar view state, view model, screen y builder de lista con loading/empty/error/success y pull-to-refresh.

5. **Tests del foundation**
   Agregar tests del repositorio y del view model de lista antes de seguir sumando UI.

6. **Create**
   Implementar formulario, validación en tiempo real, submit, snackbar y test de validación.

7. **Detail**
   Implementar actualización de progreso y evento de “meta alcanzada” disparado una sola vez.

8. **Home integration**
   Resolver el puente con savings goals, actualizar `HomeViewState`, `HomeViewModel` y `HomeScreen`, y conectar navegación a la lista.

9. **Localización y design system mínimo**
   Agregar las keys faltantes y solo las extensiones de `design_system` que realmente se repitan.

10. **Generación y validación**
   Correr `melos gen` y luego validación focalizada en `modules/savings_goals/`; dejar `melos analyze` y `melos test` como chequeo final del monorepo si el tiempo alcanza.
