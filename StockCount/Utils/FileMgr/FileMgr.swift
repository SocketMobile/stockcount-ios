//
//  FileMgr.swift
//  StockCount
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
class FileMgr  {
    /*
     Create new file.
     Return file name if success. Else nil
     */
    class func createFile() -> String? {
        
        let curDate = Date().toStringWithFormat("MM/dd/yyyy")
        var scanCount = 1
        
        let lastScanDate = SettingMgr.scanDate
        if curDate == lastScanDate {
            scanCount = SettingMgr.scanCount + 1
        } else {
            SettingMgr.scanDate = curDate
            SettingMgr.scanCount = 0
        }
        
        
        let fileTitle = "Inventory Scan - " + Date().toStringWithFormat("MM/dd/yyyy") + "-\(scanCount)\n"
        let fileName = "InventoryScan_" + Date().toStringWithFormat("yyMMddHHmmss") + ".txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            //Writing
            do {
                try fileTitle.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                return nil
            }
            DBHelper.updateFile(fileName: fileName, fileTitle: fileTitle, firstScan: "")
        }
        
        SettingMgr.scanCount = scanCount
        
        return fileName
    }
    
    class func readFile(fileName : String) -> String? {
        let fileMgr = FileManager.default
        if let dir = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            if fileMgr.fileExists(atPath: fileURL.path) {
                do {
                    let txtRead = try String(contentsOf: fileURL, encoding: .utf8)
                    return txtRead
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
    class func saveFile(fileName : String, content : String)  {
        let lines = content.lines
        let fileTitle = lines.count > 0 ? lines[0] : ""
        let firstScan = lines.count > 1 ? lines[1] : ""
        
        let fileMgr = FileManager.default
        if let dir = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try content.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                return
            }
            DBHelper.updateFile(fileName: fileName, fileTitle: fileTitle, firstScan: firstScan)
        }
    }
    
    class func deleteFile(fileName : String) {
        let fileMgr = FileManager.default
        if let dir = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try fileMgr.removeItem(at: fileURL)
            } catch {
                print(error)
            }
            DBHelper.deleteFile(fileName: fileName)
        }
        
    }
    
    //Getting File URL for share
    class func getURL(fileName : String) -> URL? {
        let fileMgr = FileManager.default
        
        if let dir = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            if (fileMgr.fileExists(atPath: fileURL.path)) {
                return fileURL
            }
        }
        
        return nil
    }
}
