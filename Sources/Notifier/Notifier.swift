import AWSLambdaRuntime

//import Scraper

@main
struct Notifier: SimpleLambdaHandler {
    func handle(_ name: String, context: LambdaContext) async throws -> String {
        let scraper = Scraper()
        let contests = scraper.fetchUpcomingContests()
        
        let slack = Slack(contests: contests)
        slack.send()

        return "Hello, \(name)"
    }
}
