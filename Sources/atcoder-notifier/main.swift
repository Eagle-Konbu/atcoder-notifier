import AWSLambdaRuntime

#if DEBUG
try Lambda.withLocalServer {
    Lambda.run { (context: Lambda.Context, event: String, callback: @escaping (Result<String, Error>) -> Void) in
        callback(.success("Hello, world!"))
    }
}
#else
Lambda.run { (context: Lambda.Context, event: String, callback: @escaping (Result<String, Error>) -> Void) in
    callback(.success("Hello, world!"))
}
#endif
