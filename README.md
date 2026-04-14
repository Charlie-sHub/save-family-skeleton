# SaveFamily Skeleton — Flutter Skeleton

Mini-monorepo Flutter para una prueba técnica. Antes de empezar a codear, leé `test.md` (en este mismo directorio) que tiene la consigna completa.

## Stack

- Dart `^3.9.2` / Flutter
- Melos `6.3.3` (workspace)
- Riverpod 3 (`flutter_riverpod`)
- Freezed 3 + `json_serializable`
- GoRouter 17 (`StatefulShellRoute.indexedStack`)
- GetIt para servicios de infraestructura
- `intl` y delegate propio para localización (en/es)

## Setup

```bash
dart pub global activate melos 6.3.3
melos bootstrap

# Generate iOS / Android platform folders for the app (only first time)
cd apps/mobile_app
flutter create --platforms=ios,android --org com.example.savefamily .
cd ../..

melos gen
flutter run -t apps/mobile_app/lib/main_development.dart \
  --dart-define-from-file=apps/mobile_app/config/development.json
```

`melos gen` corre `build_runner` en los packages que lo necesitan (Freezed). Si tocás cualquier `*_view_state.dart`, model con `@freezed`, o serialización, volvé a correrlo (o `melos watch` en otra terminal).

## Estructura

```
save-family-skeleton/
├── apps/
│   └── mobile_app/                         # Entry point + router + DI bootstrap
│       ├── lib/
│       │   ├── main_development.dart
│       │   ├── app.dart                    # Root MaterialApp.router
│       │   ├── core/init_app.dart          # Orden de inicialización
│       │   └── navigation/app_router.dart  # GoRouter con StatefulShellRoute (2 tabs)
│       └── config/development.json
├── modules/
│   ├── home/                               # Módulo de referencia (mirá este antes de empezar)
│   ├── activity/                           # Placeholder mínimo
│   └── savings_goals/                      # VACÍO — acá va tu trabajo
└── packages/
    ├── design_system/                      # ThemePort + widgets básicos
    ├── localizations/                      # Delegate + I18n constants + en/es
    └── navigation/                         # NavigationContract + AppRoutes
```

## Cómo agregar tu feature

`modules/home/` es la **referencia viva** del patrón. Antes de tocar nada, abrílo entero y entendé:

- Cómo se exponen los builders (`home_builder.dart`).
- Cómo se estructura un `Notifier<ViewState>` con Freezed.
- Cómo el screen consume el view model y traduce eventos a UI.
- Cómo el módulo declara sus dependencias en `pubspec.yaml`.

Después abrí `apps/mobile_app/lib/navigation/app_router.dart` para ver cómo ese módulo se conecta al `StatefulShellRoute`.

Cuando estés listo, replicá ese patrón en `modules/savings_goals/`.

## Comandos útiles

```bash
melos analyze              # flutter analyze en todos los packages
melos test                 # flutter test en los packages con test/
melos gen                  # build_runner build (Freezed)
melos watch                # build_runner watch
melos clean                # limpia .dart_tool/ + build/
```
