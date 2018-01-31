import Foundation
public extension String {
    var lines : [String] {
        var result: [String] = []
        enumerateLines{line, _ in result.append(line)}
        return result
    }
    
    var localized : String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
