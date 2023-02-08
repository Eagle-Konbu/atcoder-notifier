import Foundation

struct Contest {
    let name: String
    let startTime: Date
    
    var startTimeStr: String {
        get {
            return formatter.string(from: self.startTime)
        }
    }
    
    private let formatter: DateFormatter
    
    public init(name: String, startTimeStr: String) {
        self.formatter = DateFormatter()
        self.formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        self.name = name
        self.startTime = formatter.date(from: startTimeStr)!
    }
}
