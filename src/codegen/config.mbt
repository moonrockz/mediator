///|
/// Configuration for code generation.
pub struct CodegenConfig {
  output_path : String
  package_prefix : String
} derive(Show, Eq)

///|
pub fn CodegenConfig::default() -> CodegenConfig {
  { output_path: "mediator_gen.mbt", package_prefix: "" }
}
