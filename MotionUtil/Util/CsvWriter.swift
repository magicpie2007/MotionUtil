//
//  CsvWriter.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/04/18.
//

import Foundation
import os

let logger = Logger(subsystem: "com.hsworks.MotionUtil", category: "CsvWriter")

func createFolderInDocumentDirectory(folderName: String) {
    let fileManager = FileManager.default
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let folder = documentDirectory.appendingPathComponent(folderName, isDirectory: true)
    do {
        try fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
    } catch let error {
        logger.error("createFolderInDocumentDirectory() is failed: testDataStorePath=\(folderName), error=\(error.localizedDescription)")
    }
}

func getFileListFromDocumentDirectory() -> [URL] {
    var fileList = [URL]()
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        do {
            fileList = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            fileList.sort(by: {$0.lastPathComponent < $1.lastPathComponent})
        } catch let error {
            logger.error("getFileListFromDocumentDirectory(): \(dir), \(error.localizedDescription)")
        }
    }
    return fileList
}

func getFileListFrom(dir: URL) -> [URL] {
    var fileList = [URL]()
    do {
        fileList = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
    } catch let error {
        logger.error("getFileListFromDocumentDirectory(): \(dir), \(error.localizedDescription)")
    }
    return fileList
}

class CsvWriter {
    // MARK: - Properties
    private var outputStream: OutputStream? = nil

    func openCsv(filePath: String, header: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath) {
            if !fileManager.createFile(atPath: filePath,
                                       contents: nil,
                                       attributes: nil) {
                // logger.error("init() is failed: \(filePath)")
            }
        }

        if let outputStream = OutputStream(toFileAtPath: filePath,
                                           append: true) {
            outputStream.open()
            let data = header.data(using: .utf8)
            _ = data?.withUnsafeBytes { rawPtr in
                guard let ptr = rawPtr.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
                outputStream.write(ptr, maxLength: data!.count)
            }

            self.outputStream = outputStream
        }
    }

    func writeRowToCsv(rowString: String) {
        if let outputStream = self.outputStream {
            let rowData = "\(rowString)"
            let data = rowData.data(using: .utf8)
            _ = data?.withUnsafeBytes { rawPtr in
                guard let ptr = rawPtr.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
                outputStream.write(ptr, maxLength: data!.count)
            }
        }
    }

    func isCsvOpened() -> Bool {
        return outputStream != nil
    }

    func closeCsv() {
        if let outputStream = self.outputStream {
            outputStream.close()
            self.outputStream = nil
        }
    }
}
