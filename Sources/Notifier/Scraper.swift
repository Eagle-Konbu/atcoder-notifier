import Foundation

import Alamofire
import Kanna

public class Scraper {
    public func fetchUpcomingContests() -> [Contest] {
        let contests = self.fetchUpcomingAtCoderContests()
        
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
}
