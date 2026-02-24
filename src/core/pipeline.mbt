///|
/// Context passed through the middleware pipeline.
/// Middleware can extend or replace context in Before; it is immutable by convention.
pub struct PipelineContext[Req, Res] {
  pub request : Req
  pub response : Res?
} derive(Show, Eq)

///|
pub fn[Req, Res] PipelineContext::new(
  request : Req,
) -> PipelineContext[Req, Res] {
  { request, response: None }
}

///|
/// Middleware stage: runs before the handler. Returns updated context.
pub struct Before[Req, Res] {
  pub run : (Req, PipelineContext[Req, Res]) -> PipelineContext[Req, Res]
}

///|
/// Middleware stage: runs after the handler. Receives request, response, and context.
pub struct After[Req, Res] {
  pub run : (Req, Res, PipelineContext[Req, Res]) -> Unit
}

///|
/// Middleware stage: runs when the pipeline exits (success or failure).
/// Receives request, context, and optional error message.
pub struct Finally[Req, Res] {
  pub run : (Req, PipelineContext[Req, Res], String?) -> Unit
}

///|
/// Combined middleware: optional Before, After, and Finally.
pub struct Middleware[Req, Res] {
  pub before : Before[Req, Res]?
  pub after : After[Req, Res]?
  pub run_finally : Finally[Req, Res]?
}

///|
/// Constructors for use from other packages (structs may be read-only across packages).
pub fn[Req, Res] before(
  run : (Req, PipelineContext[Req, Res]) -> PipelineContext[Req, Res],
) -> Before[Req, Res] {
  { run, }
}

///|
pub fn[Req, Res] after(
  run : (Req, Res, PipelineContext[Req, Res]) -> Unit,
) -> After[Req, Res] {
  { run, }
}

///|
pub fn[Req, Res] finally(
  run : (Req, PipelineContext[Req, Res], String?) -> Unit,
) -> Finally[Req, Res] {
  { run, }
}

///|
pub fn[Req, Res] middleware(
  before : Before[Req, Res]?,
  after : After[Req, Res]?,
  run_finally : Finally[Req, Res]?,
) -> Middleware[Req, Res] {
  { before, after, run_finally }
}

///|
/// Run the full pipeline: run all Before middlewares, call dispatch, run all After middlewares,
/// then run all Finally middlewares. If dispatch raises, the error propagates (Finally is not run on error path).
pub fn[Req, Res] run_pipeline(
  request : Req,
  dispatch_fn : (Req) -> Res,
  middleware : Array[Middleware[Req, Res]],
) -> Res {
  let ctx = PipelineContext::new(request)
  let ctx_after_before = run_before_chain(request, ctx, middleware)
  let res = dispatch_fn(request)
  let ctx_with_response = { ..ctx_after_before, response: Some(res) }
  run_after_chain(request, res, ctx_with_response, middleware)
  run_finally_chain(request, ctx_after_before, None, middleware)
  res
}

///|
fn[Req, Res] run_before_chain(
  request : Req,
  ctx : PipelineContext[Req, Res],
  middleware : Array[Middleware[Req, Res]],
) -> PipelineContext[Req, Res] {
  let mut acc = ctx
  for m in middleware {
    match m.before {
      Some(b) => acc = (b.run)(request, acc)
      None => ()
    }
  }
  acc
}

///|
fn[Req, Res] run_after_chain(
  request : Req,
  response : Res,
  ctx : PipelineContext[Req, Res],
  middleware : Array[Middleware[Req, Res]],
) -> Unit {
  for m in middleware {
    match m.after {
      Some(a) => (a.run)(request, response, ctx)
      None => ()
    }
  }
}

///|
fn[Req, Res] run_finally_chain(
  request : Req,
  ctx : PipelineContext[Req, Res],
  err : String?,
  middleware : Array[Middleware[Req, Res]],
) -> Unit {
  for m in middleware {
    match m.run_finally {
      Some(f) => (f.run)(request, ctx, err)
      None => ()
    }
  }
}
