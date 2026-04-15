# SOLUTION

## 1. Cómo correrlo

Seguí el setup indicado en `README.md`:

```bash
dart pub global activate melos 6.3.3
melos bootstrap

cd apps/mobile_app
flutter create --platforms=ios,android --org com.example.savefamily .
cd ../..

melos gen
flutter run -t apps/mobile_app/lib/main_development.dart \
  --dart-define-from-file=apps/mobile_app/config/development.json
```

Para validar la implementación usé principalmente:

```bash
melos analyze
cd modules/savings_goals && flutter test
cd ../../apps/mobile_app && flutter test
```

## 2. Qué dejé afuera y por qué

- No amplié la cobertura de tests más allá de ese mínimo. Quedaron cubiertos repository, view model de lista y validación del formulario de creación, que me parecían los puntos con mejor relación entre valor y alcance para esta entrega.
- Del bonus opcional solo implementé el Bonus B. No avancé con los Bonus A o C para mantener el alcance controlado y no desestabilizar la solución obligatoria.
- Mantuve una solución deliberadamente acotada para evitar sobreconstruir. La integración entre `home` y `savings_goals` quedó resuelta a través de una API pública más chica del módulo, pero sin extraer un contrato compartido a un package común.

## 3. Qué haría diferente con más tiempo

- Haría una pasada adicional de UI para reducir más estilos inline y mover al `design_system` solo las piezas reutilizables que realmente lo justifiquen.
- Ampliaría la cobertura de tests en navegación y en algunos casos de regresión entre pantallas.
- Haría una limpieza final adicional de artefactos del skeleton para dejar el repo más cerrado como entrega.

## 4. Bonus realizado o no realizado

Realicé el Bonus B: agregué el toggle "ocultar metas completadas" en la lista de objetivos, persistido en `SharedPreferences`.

La preferencia se carga una sola vez al iniciar la app y se inyecta al módulo mediante Riverpod, para que el `Notifier<ViewState>` de la lista la lea de forma síncrona en `build()` y no haya flicker ni race conditions al reconstruir el provider.

La lista sigue trabajando con goals crudos desde repository/datasource y aplica el filtro solo en presentación. Además, el view model cachea la lista original para que cambiar el toggle actualice la UI al instante sin refetch.
