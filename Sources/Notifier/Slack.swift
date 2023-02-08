import Foundation
import Alamofire
//import Scraper

public class Slack {
    public let contests: [Contest]
    let url: String
    
    var requestBody: [String: Any] {
        get {
            var blocks: [Any] = []
            for contest in contests {
                let blockToAdd: [[String: Any]] = [
                    [
                        "type": "divider"
                    ],
                    [
                        "type": "section",
                        "text": [
                            "type": "plain_text",
                            "text": contest.abstStr
                        ],
                        "accessory": [
                            "type": "button",
                            "text": [
                                "type": "plain_text",
                                "text": "参加登録"
                            ],
                            "value": "click_me_123",
                            "action_id": "button-action",
                            "url": contest.url
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
        AF.request(self.url, method: .post, parameters: self.requestBody, encoding: URLEncoding(destination: .queryString)).responseString(queue: queue) { response in
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
//                "type": "plain_text",
//                "text": "AGC061\n01/02 (日) 21:00 開始",
//            },
//            "accessory": {
//                "type": "button",
//                "text": {
//                    "type": "plain_text",
//                    "text": "参加登録"
//                },
//                "value": "click_me_123",
//                "action_id": "button-action",
//                "url": "https://atcoder.jp/contests/agc061"
//            }
//        }
//    ]
//}
