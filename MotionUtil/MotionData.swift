//
//  MotionData.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/04/15.
//

import Foundation
import CoreMotion

class MotionData: ObservableObject {
    // MARK: - Properties
    private let motionManager = CMMotionManager()
    @Published var accX: Double = 0.0
    @Published var accY: Double = 0.0
    @Published var accZ: Double = 0.0

    func start() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
                guard let data = data, error == nil else { return }
                self.accX = data.acceleration.x
                self.accY = data.acceleration.y
                self.accZ = data.acceleration.z
            })
        }
    }

    func stop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
