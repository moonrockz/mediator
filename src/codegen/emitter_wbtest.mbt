///|
test "emit_dispatch empty produces placeholder" {
  let result = { handlers: [] }
  let out = emit_dispatch(result)
  assert_true(out.contains("No handlers found"))
}

///|
test "emit_dispatch one handler produces Request Response dispatch" {
  let info : HandlerInfo = {
    message_type: "GetUser",
    response_type: "User",
    fn_name: "handle_GetUser",
    source_file: "handlers.mbt",
    line: 1,
    is_async: false,
  }
  let result = { handlers: [info] }
  let out = emit_dispatch(result)
  assert_true(out.contains("pub enum Request"))
  assert_true(out.contains("GetUser(GetUser)"))
  assert_true(out.contains("pub enum Response"))
  assert_true(out.contains("UserResult(UserResult)"))
  assert_true(out.contains("pub struct UserResult"))
  assert_true(out.contains("MediatorResult[User]"))
  assert_true(out.contains("pub fn dispatch"))
  assert_true(out.contains("handle_GetUser(r)"))
}
