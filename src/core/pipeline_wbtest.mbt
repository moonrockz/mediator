///|
test "run_pipeline no middleware" {
  let dispatch_fn = fn(x : Int) { x + 1 }
  let res = run_pipeline(10, dispatch_fn, [])
  assert_eq(res, 11)
}

///|
test "run_pipeline with before middleware" {
  let dispatch_fn = fn(x : Int) { x + 1 }
  let mw = middleware(
    Some(before(fn(req, ctx) { { ..ctx, response: Some(-1) } })),
    None,
    None,
  )
  let res = run_pipeline(10, dispatch_fn, [mw])
  assert_eq(res, 11)
}

///|
test "run_pipeline with after and finally" {
  let mut after_ran = false
  let mut finally_ran = false
  let dispatch_fn = fn(x : Int) { x }
  let mw = middleware(
    None,
    Some(after(fn(_req, _res, _ctx) { after_ran = true })),
    Some(finally(fn(_req, _ctx, _err) { finally_ran = true })),
  )
  ignore(run_pipeline(0, dispatch_fn, [mw]))
  assert_true(after_ran)
  assert_true(finally_ran)
}
