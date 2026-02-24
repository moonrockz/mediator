///|
/// With_middleware example: GetUser + logging middleware (before, after, finally).
fn main {
  let logging = @core.middleware(
    Some(@core.before(fn(_req, ctx) {
      println("[middleware] before request")
      ctx
    })),
    Some(@core.after(fn(_req, _res, _ctx) {
      println("[middleware] after response")
    })),
    Some(@core.finally(fn(_req, _ctx, _err) {
      println("[middleware] finally")
    })),
  )
  let mediator = @core.Mediator::new(dispatch).with_middleware([logging])
  let req = GetUser::{ id: 1 }
  let res = mediator.send(Request::GetUser(req))
  match res {
    UserResult(wrap) =>
      match wrap.value {
        @core.Result::Ok(u) => println("User: " + u.name)
        @core.Result::NotFound(msg) => println("Not found: " + msg)
        _ => println("Error")
      }
  }
}
