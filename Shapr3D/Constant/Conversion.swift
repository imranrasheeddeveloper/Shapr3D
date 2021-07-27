//
//  Conversion.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 27/07/2021.
//

import Foundation
import UIKit

enum ProgressAction {
    case `continue`
    case abort
    // this can be returned from the progress callback to cancel an ongoing conversion
}
// Cleaning up after any error is the responsibility of the caller
enum ConversionError:Error {
    case aborted
    // the conversion was cancelled by returning .abort from the progress callback
    case inputError(error: Error? = nil)
    // something went wrong while opening/reading the input file
    case outputError(error: Error? = nil) // something went wrong while opening/writing the output file
    case dataError // something went wrong with the conversion logic
}

class Conversion {
    @available(iOS 13.4, *)
    func convert(from sourceURL: URL, // must be a file:// URL readable by this process
                 to targetURL: URL, // must be a file:// URL writable by this process
                 progress: ((_ progress: Double) -> ProgressAction)?) throws {
        // progress is [0.0, 1.0] When the callback is nil it behaves as if it always returned .continue
        let totalBytes: UInt64
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: sourceURL.path)
            guard let size = attributes[FileAttributeKey.size] as? UInt64 else { throw ConversionError.inputError()
            }
            totalBytes = size
        }
        catch { throw ConversionError.inputError(error: error) }
        let input: FileHandle
        do { input = try FileHandle(forReadingFrom: sourceURL) } catch { throw ConversionError.inputError(error: error) }
        
        guard FileManager.default.createFile(atPath: targetURL.path, contents: nil, attributes: nil) else { throw ConversionError.outputError() }
        
        let output: FileHandle
        do { output = try FileHandle(forWritingTo: targetURL) } catch { throw ConversionError.outputError(error: error) }
        var bytesWritten = 0
        while true {
            guard UInt.random(in: 0..<10000) != 0 else { throw ConversionError.dataError } // 0.01% chance of failure
            usleep(UInt32.random(in: 1000...10000)) // some artificial delay
            var readData: Data
            do {
                guard let data = try input.read(upToCount: 1024), !data.isEmpty else { return }
                readData = data
            } catch { throw ConversionError.inputError(error: error) }
            for i in 0..<readData.count {
                readData[i] = ~readData[i] // top secret conversion algorithm :^)
            }
            do { try output.write(contentsOf: readData) }
            catch { throw ConversionError.outputError(error: error) }
            bytesWritten += readData.count
            if let progress = progress, progress(Double(bytesWritten) / Double(totalBytes)) == .abort { throw ConversionError.aborted
            }
            
        }
    }

}

