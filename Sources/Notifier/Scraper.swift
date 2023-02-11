import Foundation
import Crypto

import Alamofire
import Kanna

public class Scraper {
    public func fetchUpcomingContests() -> [Contest] {
        let contests = self.fetchUpcomingAtCoderContests()
        
        self.fetchUpcomingCFContests()
        
        return contests
    }
    
    func fetchUpcomingAtCoderContests() -> [Contest] {
        let url = "https://atcoder.jp/home?lang=ja"

        var contests: [Contest] = []
        
        let contestTableSelector = "#contest-table-upcoming > div > table > tbody > tr"
        let dateSelector = "td:nth-child(1) > small > a"
        let nameSelector = "td:nth-child(2) > small > a"

        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
        AF.request(url).responseString(queue: queue) { response in
            switch response.result {
            case .success(_):
                if let html = response.value {
                    if let doc = try? HTML(html: html, encoding: .utf8) {
                        for e in doc.css(contestTableSelector) {
                            let dateStr = e.css(dateSelector).first?.text ?? ""
                            let name = e.css(nameSelector).first?.text ?? ""
                            let url = "https://atcoder.jp" + (e.css(nameSelector).first?["href"] ?? "")
                            contests.append(Contest(name: name, startTimeStr: dateStr, url: url, host: .atcoder))
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            semaphore.signal()
        }
        semaphore.wait()
        return contests
    }
    
    func fetchUpcomingCFContests() -> [Contest] {
        let url = "https://codeforces.com/api/"
        var contests: [Contest] = []
        
        let apiKey = ProcessInfo.processInfo.environment["CF_API_KEY"]!
        let apiSecret = ProcessInfo.processInfo.environment["CF_API_SECRET"]!
        
        let methodName = "contest.list"
        
        let unixTime = String(Date().timeIntervalSince1970)
        
        let params = ["gym": "false", "apiKey": apiKey, "time": unixTime]
        let apiSig = apiSigForCFApi(methodName: methodName, secret: apiSecret, params: params)
                
        return contests
    }
    
    private func apiSigForCFApi(methodName: String, secret: String, params: [String: String]) -> String {
        let charactersSource = "abcdefghijklmnopqrstuvwxyz#$%&_ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let randStr = String((0..<10).compactMap{ _ in charactersSource.randomElement() })
        let paramStr = params.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        let raw = "\(randStr)/\(methodName)?\(paramStr)#\(secret)"
        let hash = SHA512.hash(data: raw.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
        return randStr + hash
    }
}
