///|
fn cmd_version() -> Unit {
  println("mediator " + get_version())
}

///|
fn cmd_gen(value : @clap.SimpleValue) -> Unit {
  let dir = match value.args.get("dir") {
    Some(vals) => vals[0]
    None => "src"
  }
  let output = match value.args.get("output") {
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
