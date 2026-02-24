///|
/// Mediator CLI: codegen and version.
fn get_version() -> String {
  let json = @json.parse(moon_mod_json) catch { _ => return "unknown" }
  match json {
    Object(obj) =>
      match obj.get("version") {
        Some(String(v)) => v
        _ => "unknown"
      }
    _ => "unknown"
  }
}

///|
fn main {
  let parser = build_parser()
  let args = @env.args()
  let cli_args : Array[String] = if args.length() > 1 {
    args[1:].to_array()
  } else {
    []
  }
  let value = @clap.SimpleValue::new(parser.prog)
  let help_message = parser.parse(value, cli_args[:]) catch {
    err => {
      println("Error: " + err.to_string())
      return
    }
  }
  match help_message {
    Some(msg) => {
      println(msg)
      return
    }
    None => ()
  }
  match value.subcmd {
    Some(subcmd) =>
      match subcmd.name {
        "version" => cmd_version()
        "gen" => cmd_gen(subcmd)
        _ => ()
      }
    None => {
      let help = parser.gen_help_message(["mediator"], {})
      println(help)
    }
  }
}
