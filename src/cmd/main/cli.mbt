///|
fn build_parser() -> @clap.Parser {
  let gen = @clap.SubCommand::new(
    args={
      "dir": @clap.Arg::named(
        short='d',
        nargs=AtMost(1),
        help="Directory to scan for handler definitions",
      ),
      "output": @clap.Arg::named(
        short='o',
        nargs=AtMost(1),
        help="Output file path for generated code",
      ),
    },
    help="Generate Request/Response enums and dispatch from handlers",
  )
  let version = @clap.SubCommand::new(help="Print version information")
  @clap.Parser::new(
    prog="mediator",
    description="In-process mediator for MoonBit with codegen-based handler dispatch",
    subcmds={ "gen": gen, "version": version },
  )
}
