///|
/// Result type for mediator handler outcomes.
/// Avoids exceptions for control flow; use pattern matching for total handling.
pub enum Result[T] {
  Ok(T)
  NotFound(String)
  ValidationError(String)
  Error(String)
} derive(Show, Eq)

///|
/// Constructors for use from other packages (enum variants may be read-only across packages).
pub fn[T] ok(v : T) -> Result[T] {
  Ok(v)
}

///|
pub fn[T] not_found(msg : String) -> Result[T] {
  NotFound(msg)
}

///|
pub fn[T] validation_error(msg : String) -> Result[T] {
  ValidationError(msg)
}

///|
pub fn[T] error(msg : String) -> Result[T] {
  Error(msg)
}

///|
pub fn[T] Result::is_ok(self : Result[T]) -> Bool {
  match self {
    Ok(_) => true
    _ => false
  }
}

///|
pub fn[T] Result::is_error(self : Result[T]) -> Bool {
  match self {
    Ok(_) => false
    _ => true
  }
}

///|
pub fn[T, U] Result::map(self : Result[T], f : (T) -> U) -> Result[U] {
  match self {
    Ok(v) => Ok(f(v))
    NotFound(msg) => NotFound(msg)
    ValidationError(msg) => ValidationError(msg)
    Error(msg) => Error(msg)
  }
}

///|
pub fn[T, U] Result::flat_map(
  self : Result[T],
  f : (T) -> Result[U],
) -> Result[U] {
  match self {
    Ok(v) => f(v)
    NotFound(msg) => NotFound(msg)
    ValidationError(msg) => ValidationError(msg)
    Error(msg) => Error(msg)
  }
}

///|
/// Unwrap Ok value; raises on error variants.
pub fn[T] Result::unwrap(self : Result[T]) -> T {
  match self {
    Ok(v) => v
    NotFound(msg) => abort("Result::unwrap NotFound: " + msg)
    ValidationError(msg) => abort("Result::unwrap ValidationError: " + msg)
    Error(msg) => abort("Result::unwrap Error: " + msg)
  }
}

///|
/// Get the value if Ok, otherwise return default.
pub fn[T] Result::unwrap_or(self : Result[T], default : T) -> T {
  match self {
    Ok(v) => v
    _ => default
  }
}
