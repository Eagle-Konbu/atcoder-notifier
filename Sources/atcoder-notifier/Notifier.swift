import AWSLambdaRuntime

@main
struct Notifier: SimpleLambdaHandler {
    func handle(_name: String, context: LambdaContext) async throws -> String {
        "Hello, \(name)"
    }
}
