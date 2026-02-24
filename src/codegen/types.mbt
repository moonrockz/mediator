///|
/// Result of scanning source for mediator handlers.
pub struct HandlerInfo {
  message_type : String
  response_type : String
  fn_name : String
  source_file : String
  line : Int
  is_async : Bool
} derive(Show, Eq)

///|
pub struct ScanResult {
  handlers : Array[HandlerInfo]
} derive(Show, Eq)
