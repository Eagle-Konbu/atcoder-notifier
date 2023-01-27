import AWSLambdaRuntime

@main
struct Notifier: SimpleLambdaHandler {
    func handle(_ name: String, context: LambdaContext) async throws -> String {
        "Hello, \(name)"
    }
}
