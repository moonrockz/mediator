///|
/// Handler for GetUser. Convention: handle_GetUser(GetUser) -> Result[User].
pub fn handle_GetUser(req : GetUser) -> @core.Result[User] {
  if req.id == 1 {
    @core.ok(User::{ id: 1, name: "Alice" })
  } else {
    @core.not_found("User not found: " + req.id.to_string())
  }
}
