# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Project Overview

This module (`moonrockz/mediator`) is an **in-process mediator** for MoonBit inspired by
[Foundatio.Mediator](https://github.com/FoundatioFx/Foundatio.Mediator). It provides
request/response dispatch with optional middleware; handlers are discovered at **build time**
via a CLI codegen tool (no runtime reflection).

The library supports:

1. **Core** — `Result[T]` ADT, pipeline (Before/After/Finally), `Mediator` facade
2. **Codegen** — CLI scans source for handler functions and generates Request/Response enums and dispatch
3. **CLI** — `mediator gen` and `mediator version` subcommands

### Architecture Summary

```
moonrockz/mediator
├── src/
│   ├── core/                 # Runtime library (no parser/clap)
│   │   ├── types.mbt         # Generated contract description
│   │   ├── result.mbt        # Result[T] ADT + constructors
│   │   ├── pipeline.mbt      # Middleware + run_pipeline
│   │   ├── dispatch.mbt      # Mediator facade
│   │   └── lib.mbt
│   ├── codegen/              # Code generation
│   │   ├── types.mbt         # HandlerInfo, ScanResult
│   │   ├── scanner.mbt       # Scan source for handle_<Message> functions
│   │   ├── emitter.mbt       # Emit Request/Response/dispatch
│   │   ├── config.mbt        # CodegenConfig
│   │   ├── codegen.mbt       # generate(scan_dir)
│   │   └── moon.pkg          # deps: parser, fs
│   └── cmd/main/             # CLI binary
│       ├── main.mbt, cli.mbt, cli_commands.mbt
│       └── moon.pkg          # is_main: true
├── examples/
│   ├── minimal/              # One request, one handler, no middleware
│   └── with_middleware/      # Logging middleware (before/after/finally)
├── docs/plans/
└── mise-tasks/
```

### Processing Pipeline

```
Source files → mediator gen → mediator_gen.mbt (Request enum, Response enum, dispatch)
Consumer builds Mediator::new(dispatch).with_middleware([...])
send(request) → run_pipeline (before → dispatch → after → finally) → response
```

### Package Dependency Graph

```
core
codegen → parser, fs
cmd/main → codegen, clap
```

Consumers depend only on `moonrockz/mediator` (core); codegen/CLI are for pre-build.

## Design Philosophy

- **ADTs**: Result[T], Request/Response enums (generated), PipelineContext.
- **No runtime reflection**: Handler discovery and dispatch via codegen only.
- **Immutability**: Context passed through pipeline; middleware returns new context.
- **Total functions**: Use Result and pattern matching; avoid exceptions for control flow.

## Test-Driven Development (TDD)

- Prefer **Red-Green-Refactor**.
- Use `*_wbtest.mbt` for whitebox tests (core, codegen).
- Use `assert_eq` and `inspect` for snapshots where appropriate.

## Conventional Commits

All commits MUST use **Conventional Commits**:

```
type(scope): description
```

Scopes: `core`, `codegen`, `cmd`, `docs`, `examples`, `build`, `ci`.

## Mise Tasks

Tasks are **file-based** in `mise-tasks/`. Use `mise run <task>`. A script named `_default` in a subdirectory is the catch-all for that namespace (e.g. `mise run gen` runs `gen/_default`).

| Task                  | Purpose                                      |
|-----------------------|----------------------------------------------|
| `test:unit`           | Run `moon test`                              |
| `gen`                 | Run all codegen (depends: gen:minimal, gen:with_middleware) |
| `gen:minimal`         | Generate mediator_gen.mbt for minimal example |
| `gen:with_middleware` | Generate mediator_gen.mbt for with_middleware example |
| `examples:minimal`    | Gen + build + run minimal example             |
| `examples:with_middleware` | Gen + build + run with_middleware example |

## Tooling

- `moon fmt` — format code
- `moon info` — update `.mbti` interface
- Run `mise run test:unit` before committing
