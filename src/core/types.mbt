///|
/// Placeholder for request type. Generated code defines the actual Request enum
/// that wraps all message types (e.g. Request = GetUser(GetUser) | CreateOrder(CreateOrder) | ...).
/// The pipeline and Mediator are generic over the request and response enums.
///
/// This module documents the contract: generated code must provide
/// - type Request (enum of all request variants)
/// - type Response (enum of all response variants)
/// - fn dispatch(Request) -> Response
/// so that Mediator can run the pipeline and call dispatch.
