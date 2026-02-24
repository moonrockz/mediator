///|
/// Mediator facade: holds the generated dispatch function and optional middleware.
/// Consumers build a Mediator with the generated dispatch and send requests through it.
pub struct Mediator[Req, Res] {
  dispatch_fn : (Req) -> Res
  middleware : Array[Middleware[Req, Res]]
}

///|
pub fn[Req, Res] Mediator::new(
  dispatch_fn : (Req) -> Res,
) -> Mediator[Req, Res] {
  { dispatch_fn, middleware: [] }
}

///|
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
