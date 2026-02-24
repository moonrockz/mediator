///|
/// Minimal mediator example: one request type, one handler, no middleware.
fn main {
  let mediator = @core.Mediator::new(dispatch)
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
