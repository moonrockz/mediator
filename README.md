# mediator

**In-process mediator for MoonBit** with codegen-based handler dispatch — no runtime reflection.

Inspired by [Foundatio.Mediator](https://github.com/FoundatioFx/Foundatio.Mediator). Handlers are plain functions discovered at **build time** by the `mediator gen` CLI; the generated code provides a type-safe `Request`/`Response` enum and a `dispatch` function.

## Quick Start

### Add dependency

```bash
moon add moonrockz/mediator
```

### 1. Define message and handler

```moonbit
// messages.mbt
pub struct GetUser { id : Int }

// handlers.mbt — convention: handle_<MessageName>(MessageName) -> Result[T]
pub fn handle_GetUser(req : GetUser) -> @core.Result[User] {
  @core.ok(User::{ id: req.id, name: "Alice" })
}
```

### 2. Import core and generate dispatch

In your package `moon.pkg`:

```moonbit
import { "moonrockz/mediator/core" }
```

Run codegen (e.g. in pre-build or manually):

```bash
mediator gen -d src -o src/mediator_gen.mbt
```

Generated file contains `Request`, `Response`, and `dispatch(req : Request) -> Response`.

### 3. Use the mediator

```moonbit
let mediator = @core.Mediator::new(dispatch)
let res = mediator.send(Request::GetUser(GetUser::{ id: 1 }))
match res {
  UserResult(wrap) => match wrap.value {
    @core.Result::Ok(u) => println(u.name)
    _ => ()
  }
}
```

## Middleware

Add Before/After/Finally stages with `with_middleware`:

```moonbit
let mw = @core.middleware(
  Some(@core.before(fn(_req, ctx) { println("before"); ctx })),
  Some(@core.after(fn(_req, _res, _ctx) { println("after") })),
  Some(@core.finally(fn(_req, _ctx, _err) { println("finally") })),
)
let mediator = @core.Mediator::new(dispatch).with_middleware([mw])
```

## Result type

Handlers return `@core.Result[T]`: `Ok(T) | NotFound(String) | ValidationError(String) | Error(String)`.
Use `@core.ok(v)`, `@core.not_found(msg)`, etc. to build values from other packages.

## Examples

- **examples/minimal** — one request (GetUser), one handler, no middleware
- **examples/with_middleware** — same plus logging middleware

The examples use a **pre-build** step to run codegen. In this repo, pre-build invokes `scripts/mediator` (a shim that runs the CLI via `moon run src/cmd/main`); **users** would install the real CLI and use `mediator gen` in their own pre-build.

Build and run (from repo root):

```bash
cd examples/minimal && moon check && moon run src/main.mbt
cd examples/with_middleware && moon check && moon run src/main.mbt
```

## CLI

Install the CLI for use in your own projects (or from this repo):

```bash
moon install moonrockz/mediator/src/cmd/main
```

- `mediator gen -d <dir> -o <file>` — scan directory for handlers, write generated code
- `mediator version` — print version

Handler convention: function name `handle_<MessageTypeName>` with a single parameter of that type and return type `Result[T]`. The scanner uses `moonbitlang/parser` to find these functions.
