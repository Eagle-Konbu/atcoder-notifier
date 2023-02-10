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
                        "text": ":deployparrot: 今週の競プロ :deployparrot:"
                    ]
                ]
            ]
            for host in [ContestHost.atcoder, ContestHost.codeforces, ContestHost.topcoder, ContestHost.yukicoder] {
                if !contests.map({ $0.host }).contains(host) {
                    continue
                }
                var blockToAdd: [[String: Any]] = [
                    [
                        "type": "divider"
                    ],
                    [
                        "type": "section",
                        "text": [
                            "type": "mrkdwn",
                            "text": "*\(host.rawValue)*"
                        ]
                    ]
                ]
                for contest in contests.filter({ $0.host == host }) {
                    blockToAdd.append([
                        "type": "section",
                        "text": [
                            "type": "mrkdwn",
                            "text": contest.url != nil ? "<\(contest.url ?? "")|\(contest.name)>\n\(contest.startTimeStr)開始" : "\(contest.name)\n\(contest.startTimeStr)開始"
                        ]
                    ])
                }
                for block in blockToAdd {
                    blocks.append(block)
                }
            }
            let res: [String: Any] = [
                "text": "今週の競プロ",
                "blocks": blocks
            ]
            
            return res
        }
    }
    
    public init(contests: [Contest]) {
        self.contests = contests.filter {
            let from = Date()
            let to = Date(timeInterval: 60*60*24*7, since: from)
            return (from...to).contains($0.startTime)
        }
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
//                "text": ":deployparrot: 今週の競プロ :deployparrot:"
//            }
//        },
//        {
//            "type": "divider"
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "*AtCoder*"
//            }
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "<https://atcoder.jp/contests/agc061|AGC061>\n01/02 (日) 21:00 開始"
//            }
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "<https://atcoder.jp/contests/agc061|AGC061>\n01/02 (日) 21:00 開始"
//            }
//        },
//        {
//            "type": "divider"
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "*Codeforces*"
//            }
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "<https://codeforces.com/contestRegistrants/1793|Codeforces Round #852 (Div. 2)>\n01/02 (日) 21:00 開始"
//            }
//        },
//        {
//            "type": "section",
//            "text": {
//                "type": "mrkdwn",
//                "text": "Educational Codeforces Round 143 (Rated for Div. 2)\n01/02 (日) 21:00 開始"
//            }
//        }
//    ]
//}
