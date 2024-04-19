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
    private let folderName: String
    private var activity: String = "Stay"
    @Published var accX: Double = 0.0
    @Published var accY: Double = 0.0
    @Published var accZ: Double = 0.0

    init() {
        self.folderName = { () -> String in
            // Define folder name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: Date()) + "-" + "CSV"
        }()
        createFolderInDocumentDirectory(folderName: folderName)
    }

    func setActivity(activity: String) {
        self.activity = activity
    }

    func start() {
        self.logger.info("start() is called")
        self.createCsv(activity: self.activity)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
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
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        accDataCsvWriter.closeCsv()
    }

    private func createCsv(activity: String) {
        self.logger.info("createCsv() is called")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmmss"
        let fileName = "AccData-" + activity + "-" + dateFormatter.string(from: Date()) + ".csv"

        let folderPath = NSHomeDirectory() + "/Documents/" + folderName

        let accDataCsvPath = folderPath + "/" + fileName
        let accDataCsvHeader = "timestamp,accX,accY,accZ\r\n"
        accDataCsvWriter.openCsv(filePath: accDataCsvPath,
                                 header: accDataCsvHeader)
    }
}
