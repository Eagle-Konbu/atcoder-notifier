import Foundation

public struct Contest {
    public let name: String
    public let startTime: Date
    public let url: String?
    public let host: ContestHost
    
    public var startTimeStr: String {
        get {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "M/d(EEE) HH:mm"
            return formatter.string(from: self.startTime)
        }
    }
    
    public var abstStr: String {
        get {
            return "\(name)\n\(self.startTimeStr)開始"
        }
    }
        
    public init(name: String, startTimeStr: String, url: String?, host: ContestHost) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        self.name = name
        self.startTime = formatter.date(from: startTimeStr)!
        self.url = url
        self.host = host
    }
    
    public init(name: String, startTime: Date, url: String?, host: ContestHost) {
        self.name = name
        self.startTime = startTime
        self.url = url
        self.host = host
    }
}

public enum ContestHost: String {
    case atcoder = "AtCoder"
    case codeforces = "Codeforces"
    case topcoder = "Topcoder"
    case yukicoder = "yukicoder"
}
