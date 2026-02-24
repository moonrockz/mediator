///|
test "scan_source finds handle_GetUser" {
  let source = "pub fn handle_GetUser(req : GetUser) -> Result[User] {\n  ok(User::{ id: 1, name: \"a\" })\n}\n"
  let result = scan_source(source, "handlers.mbt")
  assert_eq(result.handlers.length(), 1)
  let h = result.handlers[0]
  assert_eq(h.message_type, "GetUser")
  assert_eq(h.response_type, "User")
  assert_eq(h.fn_name, "handle_GetUser")
  assert_eq(h.source_file, "handlers.mbt")
}

///|
test "scan_source empty returns no handlers" {
  let result = scan_source("pub fn other(x : Int) -> Int { x }\n", "x.mbt")
  assert_eq(result.handlers.length(), 0)
}
