//
//  DocumentHelper.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 27/07/2021.
//

import Foundation
import UIKit

class DocumentHelper {

    public static let shared = DocumentHelper()
    var destURL : URL?
    let fileManager = FileManager.default
    var flag : Bool = false
    func copyFileToDocumentsFolder( nameForFile: String, extForFile: String , sourceURL : URL) -> Bool{
        
        var fileName = nameForFile
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Shapr3D")
        //.appendingPathExtension(extForFile)
        
        if  fileAlreadyExist(fileName: nameForFile){
                fileName = "\(nameForFile) (\(CoreDataHelper.shared.resultCount(itemName: fileName)))"
        }
        
        destURL = documentsURL!.appendingPathComponent(fileName)
        do {
            try fileManager.copyItem(at: sourceURL, to: destURL!)
            CoreDataHelper.shared.createData(fileData: Model(isSelected: false, fileName: fileName, size: String(sizeForLocalFilePath(filePath: destURL!.path)), filePath: destURL!.path , progressObj: 0, progressStep: 0, progressStl: 0, iSConvertedObj: false, isConvertedStep: false, isConvertedStl: false, uuid: UUID().uuidString), completionalHandler: { [self] isSave in
                if isSave{
                   flag = true
                }
            })
            
            
        } catch {
            flag = false
            print("Unable to copy file")
        }
        
        return flag
    }
    
    
    
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func removeFileFromDir(fileName:String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent("Shapr3D").appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try FileManager.default.removeItem(at: documentDirectoryFileUrl)
            } catch {
                print("Could not delete file: \(error.localizedDescription)")
            }
        }
    }
    
    func fileAlreadyExist(fileName : String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false}
        let outputUrl = documentsDirectory.appendingPathComponent("Shapr3D").appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            return true
        } else{
            return false
        }
    }
}
