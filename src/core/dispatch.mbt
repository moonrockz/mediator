///|
/// Mediator facade: holds the generated dispatch function and optional middleware.
/// Build with Mediator::new(dispatch_fn) and optionally with_middleware; then call send to run the pipeline.
pub struct Mediator[Req, Res] {
  dispatch_fn : (Req) -> Res
  middleware : Array[Middleware[Req, Res]]
}

///|
/// Create a mediator that uses the given dispatch (from generated code). Add middleware with with_middleware before calling send.
pub fn[Req, Res] Mediator::new(
  dispatch_fn : (Req) -> Res,
) -> Mediator[Req, Res] {
  { dispatch_fn, middleware: [] }
}

///|
/// Add middleware (before/after/finally). Returns a new Mediator; chain with send.
pub fn[Req, Res] Mediator::with_middleware(
  self : Mediator[Req, Res],
  middleware : Array[Middleware[Req, Res]],
) -> Mediator[Req, Res] {
  { ..self, middleware, }
}

///|
/// Send a request through the pipeline (before -> dispatch -> after -> finally).
pub fn[Req, Res] Mediator::send(
  self : Mediator[Req, Res],
  request : Req,
) -> Res {
  run_pipeline(request, self.dispatch_fn, self.middleware)
}
