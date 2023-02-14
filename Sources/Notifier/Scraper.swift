import Foundation
import Crypto

import Alamofire
import Kanna

public class Scraper {
    public func fetchUpcomingContests() -> [Contest] {
        let contests = self.fetchUpcomingAtCoderContests() + self.fetchUpcomingCFContests()
                
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
        
        print(contests)
        return contests
    }
    
    func fetchUpcomingCFContests() -> [Contest] {
        let url = "https://codeforces.com/api/"
        var contests: [Contest] = []
        
        let methodName = "contest.list"
                
        let params = ["gym": "false"]
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
        AF.request(url + methodName, parameters: params).responseDecodable(of: CFResponse.self, queue: queue) { response in
            switch response.result {
            case .success(let res):
                for contest in res.result.filter({ $0.phase == "BEFORE" && !$0.frozen }) {
                    contests.append(Contest(name: contest.name, startTime: Date(timeIntervalSince1970: TimeInterval(contest.startTimeSeconds)), url: nil, host: .codeforces))
                }
            case .failure(let err):
                print(err)
            }
            semaphore.signal()
        }
        semaphore.wait()
                
        print(contests)
        return contests.sorted(by: { $0.startTime < $1.startTime })
    }
    
    struct CFContest: Codable {
        let id: Int
        let name: String
        let type: String
        let phase: String
        let frozen: Bool
        let durationSeconds: Int
        let startTimeSeconds: Int
        let relativeTimeSeconds: Int
    }
    
    struct CFResponse: Codable {
        let status: String
        let result: [CFContest]
    }
}
