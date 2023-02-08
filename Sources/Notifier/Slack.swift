import Foundation
import Alamofire
//import Scraper

public class Slack {
    public let contests: [Contest]
    let url: String
    
    var requestBody: [String: Any] {
        get {
            var blocks: [Any] = [
                [
                    "type": "header",
                    "text": [
                        "type": "plain_text",
                        "text": ":deployparrot: 今週のAtCoderコンテスト  :deployparrot:"
                    ]
                ]
            ]
            for contest in contests {
                let blockToAdd: [[String: Any]] = [
                    [
                        "type": "divider"
                    ],
                    [
                        "type": "section",
                        "text": [
                            "type": "mrkdwn",
                            "text": "<\(contest.url)|\(contest.name)>\n\(contest.startTimeStr)開始"
                        ]
                    ]
                ]
                
                for block in blockToAdd {
                    blocks.append(block)
                }
            }
            let res = [
                "blocks": blocks
            ]
            
            return res
        }
    }
    
    public init(contests: [Contest]) {
        self.contests = contests
        self.url = ProcessInfo.processInfo.environment["SLACK_URL"]!
    }
    
    public func send() -> Void {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
        AF.request(self.url, method: .post, parameters: self.requestBody, encoding: JSONEncoding.default, headers: ["Content-type": "application/json"]).responseString(queue: queue) { response in
            switch response.result {
            case .success(let res):
                print(res)
            case .failure(let res):
                print(res)
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}

// Body Format
//{
//    "blocks": [
//        {
//            "type": "header",
//            "text": {
//                "type": "plain_text",
//                "text": ":deployparrot: 今週のAtCoderコンテスト  :deployparrot:"
//            }
//        },
//        {
//            "type": "divider"
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "<https://atcoder.jp/contests/agc061|AGC061>\n01/02 (日) 21:00 開始"
//            }
//        }
//    ]
//}
