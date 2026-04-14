# Prueba Técnica · Flutter

¡Hola! Gracias por tomarte el tiempo para esta prueba. Está diseñada para que puedas demostrar cómo trabajás con Flutter en un contexto **muy parecido al que vas a encontrar en el equipo**: un monorepo Melos con Riverpod, Freezed, GoRouter, GetIt y un patrón de capas estricto.

**Tiempo estimado**: 6 a 8 horas. No queremos que dediques más. Si llegás al límite y algo queda incompleto, **documentá qué harías a continuación** — eso vale igual o más que una solución pulida pero sin criterio.

## 1. Setup

Ver `README.md` en la raíz del repo para los comandos de bootstrap. Verificá que la app levanta y muestra el shell de 2 tabs (Home / Activity) con dos pantallas placeholder.

> **Sin backend real**: no hay servidor que levantar. Tu propio **datasource** devuelve datos fake (lista hardcodeada en memoria, `Future.delayed` para simular latencia, y `throw` de las excepciones que correspondan). Lo que evaluamos no es que hables con un backend, sino **cómo estructurás las capas** para que el día que se cambie el datasource fake por uno real con HTTP, **nada por encima tenga que cambiar**.

## 2. Lo que tienes que construir

### Feature: **Savings Goals** (objetivos de ahorro de un niño)

Cada niño tiene una billetera y puede definir metas de ahorro (ej: "Bici nueva — €120"). La feature vive dentro del módulo `modules/savings_goals/` (que entregamos vacío).

### 2.1 Operaciones que tiene que soportar el datasource

Tu `SavingsGoalsRemoteDatasource` (interfaz + impl) tiene que exponer y mockear estas operaciones. La impl devuelve datos en memoria con `Future.delayed(Duration(milliseconds: 600))` para simular red.

| Operación | Comportamiento que tu impl debe simular |
|---|---|
| `fetchGoals(childId)` | Devuelve lista hardcodeada. Si `childId == 'child-error'` → tirá un `Exception('Network error')`. |
| `createGoal(childId, request)` | Agrega a la lista en memoria. Si el `name` ya existe → tirá una excepción que represente conflicto con el mensaje `"Goal name already exists"`. Ese mensaje tiene que llegar tal cual al usuario. |
| `updateProgress(goalId, amount)` | Actualiza `currentAmount`. Una vez de cada 5 intentos lanzá un error de red (para que demuestres tu manejo de error). |
| `deleteGoal(goalId)` | Elimina del estado en memoria. Siempre OK. |

Seedeá 2 niños (`child-1`, `child-2`) con 3 goals cada uno. El estado vive en memoria del proceso (se pierde con hot restart — está bien).

> Estructurá las capas **como si el datasource hablara con HTTP de verdad**. El día 1 en el equipo, lo único que cambia es swappear esa impl por una que use el cliente HTTP real — todo lo de arriba (repository, viewmodel, screen, tests) tiene que seguir funcionando sin tocarse.

### 2.2 Modificar la pantalla Home (trabajo sobre código existente)

La pantalla Home actual es un placeholder con un contador. Reemplazala para que muestre **2 cards de niños** (`child-1` y `child-2`) con la siguiente info por card:

- Nombre del niño (puede ser hardcodeado: "Lucía", "Mateo").
- Resumen de sus metas: cantidad de metas y progreso total (ej: "3 metas · €45 / €300").
- Al tocar una card → navega a `/children/{childId}/savings-goals` (la lista de la feature).

Esto implica:
- Modificar `HomeViewState` (agregarle la lista de niños con su resumen).
- Modificar `HomeViewModel` (que obtenga los datos del datasource de savings_goals).
- Modificar `HomeScreen` (reemplazar el contador por las cards, usando widgets del `design_system`).
- Resolver la **dependencia entre módulos**: Home necesita datos de savings_goals. Pensá cómo exponés eso sin acoplar los módulos directamente (ej: un provider compartido, una interfaz en un package común, etc). No hay una respuesta única correcta — lo que evaluamos es tu criterio.

### 2.3 Pantallas a implementar

#### A. **Lista de objetivos** — `/children/:childId/savings-goals`

- Muestra la lista de goals de ese niño.
- Cada item: nombre, monto objetivo, monto actual, % de progreso (barra), botón "eliminar".
- Estados visibles: **loading**, **empty** (con CTA), **error** (con retry), **success**.
- Pull-to-refresh.
- FAB "Crear nuevo objetivo" → navega a la pantalla B.

#### B. **Crear objetivo** — `/children/:childId/savings-goals/new`

- Formulario con: `name` (3–40 chars), `targetAmount` (decimal > 0, máx €10.000), `description` (opcional, máx 200 chars).
- Validación inline en tiempo real (botón submit deshabilitado si inválido).
- Al enviar: en éxito vuelve a la lista y muestra un snackbar; en error (ej: conflicto de nombre duplicado) muestra el mensaje exacto del backend, no uno genérico.

#### C. **Detalle / actualizar progreso** — `/children/:childId/savings-goals/:goalId`

- Muestra info de la meta + un input para añadir un aporte (monto positivo).
- Al confirmar, llama a `updateProgress` con el nuevo total.
- Si el aporte completa la meta (`>= targetAmount`), muestra un diálogo de "¡Meta alcanzada!" **una sola vez**, no en cada rebuild del widget.

### 2.4 Requisitos transversales (NO opcionales)

1. **Estructura de feature** según el patrón del proyecto. Mirá `modules/home/` antes de empezar — es la referencia. Estructura esperada:
   ```
   savings_goals/
   ├── lib/savings_goals.dart                    # public exports
   └── lib/src/
       ├── features/
       │   ├── list/
       │   │   ├── savings_goals_list_builder.dart
       │   │   ├── savings_goals_list_screen.dart
       │   │   └── presentation/state/
       │   │       ├── savings_goals_list_view_model.dart
       │   │       └── savings_goals_list_view_state.dart
       │   ├── create/...
       │   └── detail/...
       └── core/
           ├── data/
           │   ├── datasource/                   # interfaz + impl en memoria
           │   ├── models/                       # Freezed + json_serializable
           │   └── repositories/                 # impl
           ├── domain/
           │   ├── entities/                     # Freezed entities (NO usar los models en la UI)
           │   └── repositories/                 # interfaces
           └── providers/                        # providers de Riverpod para datasource/repository
   ```
2. **Riverpod 3** con `NotifierProvider.autoDispose` y `Notifier<TViewState>`. Para parametrizar por `childId`/`goalId`, usar `family`.
3. **Freezed** para todos los models, entities y view states. Generado con `melos gen` (o `dart run build_runner build --delete-conflicting-outputs` dentro del package).
4. **GoRouter**: agregar las 3 rutas anidadas dentro del shell de Home. Los builders son clases `const` con `buildPage(context, state)`. Mirá `home_builder.dart` como referencia.
5. **Capa de datos**: el `Repository` de dominio consume la interfaz `SavingsGoalsRemoteDatasource` (no la impl directamente). La impl en memoria se inyecta vía un `Provider` de Riverpod, y queda trivialmente reemplazable por una versión real con HTTP. Las excepciones del datasource se mapean a errores del dominio en el repository.
6. **Errores tipados**: el `ViewState` debe exponer un enum (por ejemplo `SavingsGoalsErrorEvent { loadFailed, createConflict, networkError, validation }`) y un `SavingsGoalsSuccessEvent`. La traducción a UI string ocurre en el widget vía `ref.listen` + `I18n.*`.
7. **Localización**: todas las strings visibles van por `context.translate(I18n.x)`. Agregá las keys nuevas en `packages/localizations/assets/l10n/{en,es}.json` y en `i18n.dart`.
8. **Theming**: colores, radios y tipografía vía el `design_system` (no hardcodear). Si necesitás un widget que no existe, agregalo al package — no inline en una pantalla.
9. **Sin comentarios** en el código que entregues. Sin business logic dentro de widgets.

### 2.5 Tests (mínimo aceptable)

Escribí tests para **al menos** estas tres cosas:

1. **Repository / mapeo de errores** — dado un datasource fake controlado en el test (no la impl en memoria de la app), validar que el conflicto de nombre se mapea al error tipado correcto y que el happy path devuelve los datos esperados.
2. **ViewModel de la lista** — transición `loading → success` y `loading → error` + acción `refresh`.
3. **Validación del formulario de creación** — casos válido/inválido.

No esperamos coverage total, esperamos **tests que demuestren cómo testeás**.

### 2.6 Bonus (opcional, máx 1h — y sólo si llegás)

Elegí **uno** y lo discutimos en la defensa:

- **A) Refactor**: en `modules/legacy_god_class/` te dejamos un `sign_up_view_model.dart` de ~400 LOC con 12 `TextEditingController`s, validación esparcida, y una llamada async dentro de un listener. Identificá los 3 problemas más graves y proponé un plan de refactor incremental en un `REFACTOR_PLAN.md`. No tenés que aplicarlo, sólo describirlo y justificarlo.
- **B) Persistir filtro**: agregá un toggle "ocultar metas completadas" en la lista, persistido en `SharedPreferences`, leído al rebuild del provider sin race conditions.
- **C) Optimistic update**: en `deleteGoal`, sacá el item de la lista antes de que la operación termine. Si falla, restauralo y mostrá un snackbar.

## 3. Entregables

1. PR (o repo) con tu solución.
2. Un `SOLUTION.md` corto (máx 1 página) con:
   - Cómo correrlo (si cambiaste algo del setup).
   - Qué dejaste afuera y por qué.
   - Qué harías diferente con más tiempo.
   - Si hiciste el bonus, cuál y por qué elegiste ese.

## 4. Nota final

Valoramos el diseño, las buenas prácticas, la arquitectura limpia y el código limpio.

El skeleton viene armado con Riverpod, Freezed, GoRouter y GetIt, y la consigna pide usarlos. Pero si considerás que hay una mejor forma de resolver algo — ya sea un manejo de estado diferente(bloc,cubits por ejemplo), otra estructura de capas, otro approach de navegación, o lo que sea — **tenés libertad de hacerlo**. Lo único que pedimos es que lo justifiques en tu `SOLUTION.md` y estés preparado para defenderlo en el review. Vamos a hacer todas las preguntas necesarias para entender tu razonamiento.

Lo que nos importa no es que sigas instrucciones al pie de la letra, sino que demuestres criterio técnico.
