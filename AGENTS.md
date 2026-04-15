# AGENTS.md

## Repo purpose

This repository contains a Flutter monorepo skeleton centered on a modular application structure.

Work should stay aligned with the existing architecture and conventions already present in the repository. Prefer extending the current patterns over introducing alternative structures unless there is a clear, task-driven reason to do so.

## Instruction hierarchy

Use sources in this order when they overlap:

1. Direct user request
2. `test.md`
3. This `AGENTS.md`
4. `README.md`
5. Existing repo code, especially `modules/home/`

If sources conflict:
- state the conflict clearly
- do not guess
- prefer the smallest reversible interpretation unless the user has already settled the decision

## Source of truth by concern

- Scope, required behavior, deliverables, and required implementation rules:
  - `test.md`
- Workspace setup, commands, monorepo layout, and package structure:
  - `README.md`
- Reference implementation patterns for module structure, state flow, and builders:
  - `modules/home/`
- App-level wiring and route integration:
  - `apps/mobile_app/lib/navigation/app_router.dart`
- Shared visual primitives and theme constraints:
  - `packages/design_system/`
- Localization contracts and user-facing strings:
  - `packages/localizations/`

## Working principles

- Keep code in English.
- Keep user-facing reasoning documents in Spanish unless asked otherwise.
- Prefer small, reviewable edits.
- Strong default: one file at a time.
- Only edit multiple files when the task genuinely requires it.
- Do not refactor unrelated code.
- Do not introduce new abstractions unless they clearly reduce necessary coupling or duplication.
- Stay close to the repository’s established naming, structure, and state-management patterns.
- Prefer completing required behavior cleanly over adding extra polish or optional architecture.

## Architecture guidance

Default to the repository’s existing approach:

- layered structure
- Riverpod `Notifier<ViewState>`
- Freezed for models, entities, and view states
- GoRouter builders as classes
- repository over datasource abstraction
- replaceable infrastructure implementations behind interfaces
- explicit state transitions and UI events
- UI separated from business logic

Do not import patterns from other projects unless they are directly compatible with this repository and the current task.

## Implementation discipline

Before editing:

1. Read the relevant section of `test.md`.
2. Read the relevant files in `modules/home/`.
3. Inspect the touched area for existing naming, provider, routing, and state patterns.
4. Identify the smallest coherent change that moves the task forward.

When implementing:
- follow existing patterns from `modules/home/`
- keep state flow explicit
- do not use data models directly in UI
- keep business logic out of widgets
- keep styling within the design system or existing shared theme patterns
- route visible strings through localization
- map datasource exceptions in the repository layer
- keep side effects and event handling explicit in state

## Testing guidance

Prefer the minimum useful test set that proves behavior and layer boundaries.

Prioritize:
1. repository error mapping
2. view model state transitions
3. form validation behavior

Do not create placeholder tests with comments only. Add tests when the relevant contracts are defined clearly enough to make them meaningful.

- Prefer tests to follow the Arrange / Act / Assert structure when it improves readability.
- In test files, use the exact section comments `// Arrange`, `// Act`, and `// Assert` for that structure.
- Scope this commenting convention to tests only.
- Do not add comparable comments in production code unless the user explicitly asks for them.

## Validation

Use the lightest validation that proves the change.

Typical commands:
- `melos bootstrap`
- `melos gen`
- `melos analyze`
- `melos test`

When code generation surfaces change:
- run `melos gen`

When editing a single package:
- prefer targeted validation where practical
- keep repo-wide analyze/test in mind before final handoff

If a validation step cannot be run, state that clearly.

## Change safety

Do not change without explicit instruction:
- the monorepo structure
- the role of `modules/home/` as the primary reference pattern
- the default use of Riverpod, Freezed, GoRouter, and the layered structure
- the repo-level location of this `AGENTS.md`

Also avoid:
- broad cleanup unrelated to the active task
- turning prompts into durable repo policy
- adding planning comments as placeholders in delivered code
- solving local problems with large abstractions when a smaller solution is already sufficient

## Completion criteria

A task is done when:
- the requested scope is implemented
- the diff is small and readable
- the implementation aligns with `test.md` and existing repo patterns
- generated files are updated if needed
- relevant validation has been run, or limitations are stated clearly

## Commit guidance

When asked for a commit message:
- inspect the staged diff first
- use a short, specific, past-tense summary
- avoid vague messages

## Conventions and constraints

- Make the smallest change that fully solves the task.
- Do not do unrelated refactors, broad rewrites, or speculative improvements.
- Follow the structure and conventions already established in the repo, especially the builder, screen, and `Notifier<ViewState>` patterns used in `modules/home/`.
- Treat `test.md` and the existing repo structure as the source of truth over generic framework preferences.
- Stay close to the skeleton unless there is a clear technical reason to deviate.
- Prefer solutions that are easy to understand, easy to review, and consistent with the rest of the codebase.
- Prefer existing widgets, localization flow, theme tokens, provider patterns, route helpers, and file structure before introducing new ones.
- Keep styling values centralized through the existing design system and theme layer. Do not scatter visual constants through feature screens.
- Use descriptive names, keep constants centralized, and avoid scattered magic values.
- Keep modules narrowly scoped. Do not couple one module to another through internal implementation details when a small public surface or existing abstraction is enough.
- Keep business logic out of widgets. UI should render state and trigger actions; view models and repositories should hold behavior.
- Keep data, domain, and presentation responsibilities separated. Do not expose data-layer models directly to presentation when domain entities are expected.
- Prefer `if (...) { ... } else { ... }` over just `if (...) { ... } ...` in case of early return and similar.
- Avoid long early-return chains when they make the logic harder to follow.
- Prefer expression methods where possible
- Keep view states explicit and typed. Use typed success and error events for one-shot UI effects, and handle those effects via listeners rather than inside `build()`.
- Keep routing consistent with the repo’s GoRouter builder pattern. New routes should be explicit, readable, and easy to trace.
- Keep user-facing text fully localized through the existing localization system. Do not hardcode visible strings in screens or widgets.
- Keep public-facing copy and docs professional, factual, and restrained.
- Do not overstate architecture, scalability, or production-readiness beyond what the implementation actually proves.
- Do not place secrets, tokens, personal data, or misleading example data in code, docs, fixtures, or tests.
- Do not introduce new shared packages or cross-module abstractions unless the task clearly requires them.
- Prefer small, reviewable edits. Strong default: one coherent file at a time unless the change genuinely requires touching several files together.
- After each meaningful change, run the most relevant verification for that scope instead of making many unverified edits in a row.

## Technical priorities

- Prioritize correctness, clarity, and alignment with the task over cleverness.
- Build only what the task requires before considering extras.
- Use fake infrastructure behind proper abstractions so the upper layers would not need to change when replacing the datasource later.
- Favor solutions that are straightforward to reason about and consistent with the repo.
- When multiple valid approaches exist, prefer the one that stays closest to the repo and the challenge requirements.
