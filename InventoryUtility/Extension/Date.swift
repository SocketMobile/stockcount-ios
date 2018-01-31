import Foundation
public extension Date {
    func toStringWithFormat(_ format : String) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}
