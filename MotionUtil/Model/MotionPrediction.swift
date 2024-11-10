//
//  MotionPrediction.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/11/04.
//

import Foundation
import CoreML

class MotionPrediction {
    private let model = try! ActivityDetector2(configuration: MLModelConfiguration())
    private let predictionWindow: Int
    private let accX: MLMultiArray
    private let accY: MLMultiArray
    private let accZ: MLMultiArray
    private let gyroX: MLMultiArray
    private let gyroY: MLMultiArray
    private let gyroZ: MLMultiArray
    private var currentIndex: Int = 0
    private var prediction: String = "Unknown"

    init() {
        let metadata = model.model.modelDescription.metadata
        if let _creatorDefinedMeta = metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: Any], let _predictionWindow = _creatorDefinedMeta["prediction_window"] as? Int {
            predictionWindow = _predictionWindow
            print("predictionWindow: \(predictionWindow)")
        } else {
            predictionWindow = 25
            print("predictionWindow: \(predictionWindow) (default)")
        }

        accX = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
        accY = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
        accZ = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
        gyroX = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
        gyroY = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
        gyroZ = try! MLMultiArray(shape: [NSNumber(value: predictionWindow)], dataType: .double)
    }

    func predict(_accX: Double, _accY: Double, _accZ: Double,
                 _gyroX: Double, _gyroY: Double, _gyroZ: Double)
    -> String {
        accX[currentIndex] = _accX as NSNumber
        accY[currentIndex] = _accY as NSNumber
        accZ[currentIndex] = _accZ as NSNumber
        gyroX[currentIndex] = _gyroX as NSNumber
        gyroY[currentIndex] = _gyroY as NSNumber
        gyroZ[currentIndex] = _gyroZ as NSNumber
        // print("AccX: \(accX[currentIndex]), AccY: \(accY[currentIndex]), AccZ: \(accZ[currentIndex]), GyroX: \(gyroX[currentIndex]), GyroY: \(gyroY[currentIndex]), GyroZ: \(gyroZ[currentIndex])")
        currentIndex = (currentIndex + 1) % Int(truncating: predictionWindow as NSNumber)
        if currentIndex == 0 {
            prediction = predict(accX, accY, accZ, gyroX, gyroY, gyroZ)
            print("Prediction: \(prediction)")
        }

        return prediction
    }

    private func predict(_ accX: MLMultiArray, _ accY: MLMultiArray, _ accZ: MLMultiArray, _ gyroX: MLMultiArray, _ gyroY: MLMultiArray, _ gyroZ: MLMultiArray) -> String {
        let stateIn: MLMultiArray = try! MLMultiArray(shape: [NSNumber(value: 400)], dataType: .double)
        let output = try! self.model.prediction(input: ActivityDetector2Input(accX: accX, accY: accY, accZ: accZ, gyroX: gyroX, gyroY: gyroY, gyroZ: gyroZ, stateIn: stateIn))
        print("predict: output: \(output.labelProbability)")
        return output.label
    }
}
