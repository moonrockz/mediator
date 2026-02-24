///|
/// Generate mediator dispatch code from a directory of MoonBit source files.
pub fn generate(scan_dir : String) -> String {
  let result = scan_directory(scan_dir)
  emit_dispatch(result)
}

///|
fn scan_directory(dir : String) -> ScanResult {
  let entries = @fs.read_dir(dir) catch { _ => return { handlers: [] } }
  let all_handlers : Array[HandlerInfo] = []
  for entry in entries {
    let path = dir + "/" + entry
    let is_dir = @fs.is_dir(path) catch { _ => false }
    if is_dir {
      let sub = scan_directory(path)
      for h in sub.handlers {
        all_handlers.push(h)
      }
    } else if entry.has_suffix(".mbt") &&
      !entry.has_suffix("_test.mbt") &&
      !entry.has_suffix("_wbtest.mbt") {
      let content = @fs.read_file_to_string(path) catch { _ => continue }
      let scan = scan_source(content, path)
      for h in scan.handlers {
        all_handlers.push(h)
      }
    }
  }
  { handlers: all_handlers }
}
