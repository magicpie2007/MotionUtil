//
//  MotionData.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/04/15.
//

import Foundation
import CoreMotion
import os

class MotionData: ObservableObject {
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.hsworks.MotionUtil", category: "MotionData")
    private let motionManager = CMMotionManager()
    private let accDataCsvWriter = CsvWriter()
    private let dateFolderName: String
    private var csvStoreFolderName: String = ""
    @Published var accX: Double = 0.0
    @Published var accY: Double = 0.0
    @Published var accZ: Double = 0.0

    init() {
        self.logger.info("init() is called")
        self.dateFolderName = { () -> String in
            // Define folder name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: Date()) + "-" + "CSV"
        }()
        createFolderInDocumentDirectory(folderName: self.dateFolderName)
    }

    func setActivity(activity: String) {
        self.logger.info("setActivity() is called: activity=\(activity)")
        self.csvStoreFolderName = self.dateFolderName + "/" + activity
        createFolderInDocumentDirectory(folderName: self.csvStoreFolderName)
    }

    func start() {
        self.logger.info("start() is called")
        self.createCsv()
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.2
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
                guard let data = data, error == nil else { return }
                self.accX = data.acceleration.x
                self.accY = data.acceleration.y
                self.accZ = data.acceleration.z
                let currentTime = Date().timeIntervalSince1970
                self.accDataCsvWriter.writeRowToCsv(rowString: "\(currentTime),\(self.accX),\(self.accY),\(self.accZ)\r\n")
            })
        }
    }

    func stop() {
        self.logger.info("stop() is called")
        if self.motionManager.isAccelerometerActive {
            self.motionManager.stopAccelerometerUpdates()
        }
        self.accDataCsvWriter.closeCsv()
    }

    private func createCsv() {
        self.logger.info("createCsv() is called")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        let fileName = "AccData-" + dateFormatter.string(from: Date()) + ".csv"

        let accDataCsvPath = NSHomeDirectory() + "/Documents/" + self.csvStoreFolderName + "/" + fileName
        self.logger.info("createCsv(): CSV path=\(accDataCsvPath)")
        let accDataCsvHeader = "timestamp,accX,accY,accZ\r\n"
        self.accDataCsvWriter.openCsv(filePath: accDataCsvPath,
                                      header: accDataCsvHeader)
    }
}
