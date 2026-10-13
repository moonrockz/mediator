///|
fn cmd_version() -> Unit {
  println("mediator " + get_version())
}

///|
fn cmd_gen(value : @argparse.Matches) -> Unit {
  let dir = match value.values.get("dir") {
    Some(vals) => vals[0]
    None => "src"
  }
  let output = match value.values.get("output") {
    Some(vals) => vals[0]
    None => {
      println("Error: --output (-o) is required")
      return
    }
  }
  let code = @codegen.generate(dir)
  @fs.write_string_to_file(output, code) catch {
    _ => {
      println("Error writing " + output)
      return
    }
  }
  println(output)
}
