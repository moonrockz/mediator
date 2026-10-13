///|
/// Mediator CLI: codegen and version.
fn get_version() -> String {
  for line in moon_mod.split("\n") {
    match line.trim().strip_prefix("version") {
      Some(rest) =>
        match rest.trim().strip_prefix("=") {
          Some(value) => return value.trim().trim(chars="\"").to_owned()
          None => ()
        }
      None => ()
    }
  }
  "unknown"
}

///|
fn main {
  let parser = build_parser()
  let args = @env.args()
  let cli_args : Array[String] = if args.length() > 1 {
    args[1:].to_owned()
  } else {
    []
  }
  let matches = parser.parse(argv=cli_args) catch {
    err => {
      println(err.to_string())
      return
    }
  }
  match matches.subcommand {
    Some(("version", _)) => cmd_version()
    Some(("gen", sub)) => cmd_gen(sub)
    Some(_) => ()
    None => println(parser.render_help())
  }
}
