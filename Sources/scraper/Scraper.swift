import Foundation

import Alamofire
import Kanna

class Scraper {
    var url: String
    
    init() {
        self.url = "https://atcoder.jp/home"
    }
    
    private func fetchUpcomingContests() -> String {
        var contests = []
        AF.request(self.url).responseString { response in
            let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    
                }
            }
        }
    }
}
