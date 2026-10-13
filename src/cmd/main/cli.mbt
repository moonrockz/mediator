///|
fn build_parser() -> @argparse.Command {
  let gen = @argparse.Command(
    "gen",
    options=[
      @argparse.OptionArg(
        "dir",
        short='d',
        about="Directory to scan for handler definitions",
      ),
      @argparse.OptionArg(
        "output",
        short='o',
        about="Output file path for generated code",
      ),
    ],
    about="Generate Request/Response enums and dispatch from handlers",
  )
  let version = @argparse.Command("version", about="Print version information")
  @argparse.Command(
    "mediator",
    about="In-process mediator for MoonBit with codegen-based handler dispatch",
    subcommands=[gen, version],
  )
}
