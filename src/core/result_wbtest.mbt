///|
test "Result ok constructors" {
  let r : Result[Int] = ok(42)
  assert_true(r.is_ok())
  assert_true(!r.is_error())
  assert_eq(r.unwrap(), 42)
}

///|
test "Result not_found" {
  let r : Result[Int] = not_found("missing")
  assert_true(!r.is_ok())
  assert_true(r.is_error())
  assert_eq(r.unwrap_or(0), 0)
}

///|
test "Result map" {
  let r : Result[Int] = ok(21)
  let s = r.map(fn(x) { x * 2 })
  assert_true(s.is_ok())
  assert_eq(s.unwrap(), 42)
}

///|
test "Result map preserves error" {
  let r : Result[Int] = not_found("x")
  let s = r.map(fn(x) { x * 2 })
  assert_true(!s.is_ok())
}

///|
test "Result flat_map" {
  let r : Result[Int] = ok(21)
  let s = r.flat_map(fn(x) { ok(x * 2) })
  assert_eq(s.unwrap(), 42)
}
