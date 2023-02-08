import Foundation

struct Contest {
    let name: String
    let startTime: Date
    let url: String
    
    var startTimeStr: String {
        get {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "M/d(EEE) HH:mm"
            return formatter.string(from: self.startTime)
        }
    }
    
    var abstStr: String {
        get {
            return "\(name)\n\(self.startTimeStr)開始"
        }
    }
        
    public init(name: String, startTimeStr: String, url: String) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        self.name = name
        self.startTime = formatter.date(from: startTimeStr)!
        self.url = url
    }
}
