///|
/// Contract for generated code. Your project does not implement types here; the
/// `mediator gen` CLI produces a file that defines:
/// - **Request** — enum wrapping all message types (e.g. GetUser(GetUser) | CreateOrder(CreateOrder) | ...)
/// - **Response** — enum of response wrappers (e.g. UserResult(UserResult) | OrderResult(OrderResult) | ...)
/// - **dispatch** — fn(Request) -> Response
/// Mediator and the pipeline are generic over these; pass the generated dispatch to Mediator::new.
