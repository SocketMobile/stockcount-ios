//
//  FileMgr.swift
//  StockCount
//
//  Created by Sohel Dhanani on 12/28/17.
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
        let fileName = "InventoryScan_" + Date().toStringWithFormat("yyMMddHHmmss")
        
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
    
    class func saveShareFile(fileName: String) -> URL? {
        let content = readFile(fileName: fileName) ?? ""
        return saveShareFile(fileName: fileName, content: content)
    }
    
    class func saveShareFile(fileName: String, content: String) -> URL? {
        let fileMgr = FileManager.default
        var ext = "txt"
        var shareContent = content
        let shareFileName = fileName.hasSuffix(".txt") ? String(fileName.prefix(fileName.count - 4)) : fileName
        if SettingMgr.consolidatingCounts {
            ext = "csv"
            
            var lines = content.split(separator: "\n")
            if !lines.isEmpty {
                let firstLine = String(lines.removeFirst())
                var barcodeCountMap = [String: Int]()
                lines.joined(separator: ";").split(separator: ";", omittingEmptySubsequences: true).forEach { (line) in
                    let components = line.contains(",") ? line.split(separator: ",", omittingEmptySubsequences: true) : line.split(separator: " ", omittingEmptySubsequences: true)
                    if !components.isEmpty {
                        let barcode = String(components[0])
                        let count = components.count > 1 ? Int(String(components[1]).trimmingCharacters(in: CharacterSet.whitespaces)) ?? 1 : 1
                        
                        if !barcode.isEmpty {
                            barcodeCountMap[barcode] = (barcodeCountMap[barcode] ?? 0) + count
                        }
                    }
                }
                
                shareContent = "\(firstLine)\n"
                barcodeCountMap.forEach { (keyValue) in
                    let (barcode, count) = keyValue
                    shareContent += "\(barcode), \(count)\n"
                }
            }
        }
        
        if let dir = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(shareFileName).\(ext)")
            do {
                try shareContent.write(to: fileURL, atomically: false, encoding: .utf8)
                return fileURL
            } catch {
                NSLog("error on create file for share. \(fileName)")
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
