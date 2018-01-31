import Foundation
import RealmSwift

class RMFile: Object {
    @objc dynamic var fileName = ""
    @objc dynamic var fileTitle = ""
    @objc dynamic var firstScan = ""
    @objc dynamic var updatedTime = Date()
    
    override static func primaryKey() -> String? {
        return "fileName"
    }
}
