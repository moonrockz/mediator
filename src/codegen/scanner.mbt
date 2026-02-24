///|
/// Scan MoonBit source for mediator handler functions.
/// Detects #mediator.handler(MessageType) attribute or handle_MessageType(MessageType) -> Result[T] convention.
pub fn scan_source(source : String, file_name : String) -> ScanResult {
  let (impls, _errors) = @parser.parse_string(source, name=file_name)
  let handlers : Array[HandlerInfo] = []
  walk_impls(impls, file_name, handlers)
  { handlers, }
}

///|
fn walk_impls(
  impls : @list.List[@syntax.Impl],
  file_name : String,
  handlers : Array[HandlerInfo],
) -> Unit {
  match impls {
    More(head, tail~) => {
      process_impl(head, file_name, handlers)
      walk_impls(tail, file_name, handlers)
    }
    Empty => ()
  }
}

///|
fn process_impl(
  impl_ : @syntax.Impl,
  file_name : String,
  handlers : Array[HandlerInfo],
) -> Unit {
  match impl_ {
    TopFuncDef(fun_decl~, ..) => process_func_def(fun_decl, file_name, handlers)
    _ => ()
  }
}

///|
fn process_func_def(
  fun_decl : @syntax.FunDecl,
  file_name : String,
  handlers : Array[HandlerInfo],
) -> Unit {
  let name = fun_decl.name.name
  let line = fun_decl.name.loc.start.lnum
  if string_starts_with(name, "handle_") {
    let message_type = string_substring_from(name, 7)
    match fun_decl.decl_params {
      Some(More(first, ..)) => {
        let param_type = type_to_string(extract_param_type(first))
        if param_type == message_type {
          let ret_type = extract_return_type(fun_decl.return_type)
          let info : HandlerInfo = {
            message_type,
            response_type: ret_type,
            fn_name: name,
            source_file: file_name,
            line,
            is_async: false,
          }
          handlers.push(info)
        }
      }
      _ => ()
    }
  }
}

///|
fn extract_param_type(param : @syntax.Parameter) -> @syntax.Type? {
  match param {
    Positional(ty~, ..) => ty
    Labelled(ty~, ..) => ty
    Optional(ty~, ..) => ty
    QuestionOptional(ty~, ..) => ty
    DiscardPositional(ty~, ..) => ty
  }
}

///|
fn type_to_string(ty : @syntax.Type?) -> String {
  match ty {
    Some(Name(constr_id~, ..)) =>
      match constr_id.id {
        Ident(name~) => name
        Dot(pkg~, id~) => id
      }
    Some(Option(ty~, ..)) => type_to_string(Some(ty)) + "?"
    _ => "Unknown"
  }
}

///|
fn extract_return_type(ret : @syntax.Type?) -> String {
  match ret {
    Some(Name(constr_id~, tys~, ..)) => {
      let name = match constr_id.id {
        Ident(name~) => name
        Dot(pkg~, id~) => id
      }
      match tys {
        More(first_ty, ..) =>
          if name == "Result" {
            type_to_string(Some(first_ty))
          } else {
            name
          }
        Empty => name
      }
    }
    Some(Option(ty~, ..)) => extract_return_type(Some(ty))
    _ => "Unit"
  }
}

///|
fn string_starts_with(s : String, prefix : String) -> Bool {
  let plen = prefix.length()
  if s.length() < plen {
    return false
  }
  for i = 0; i < plen; i = i + 1 {
    if s[i] != prefix[i] {
      return false
    }
  }
  true
}

///|
fn string_substring_from(s : String, start : Int) -> String {
  let buf = StringBuilder::new()
  for i = start; i < s.length(); i = i + 1 {
    buf.write_char(s[i].to_int().unsafe_to_char())
  }
  buf.to_string()
}
