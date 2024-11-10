//
//  PredictActivityView.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/05/07.
//

import SwiftUI

struct PredictActivityView: View {
    @State private var isStarting: Bool = false
    @ObservedObject private var motionData = MotionData()

    var body: some View {
        List {
            Section {
                Toggle(isOn: self.$isStarting, label: {
                    Text("Prediction Start")
                })
                .onChange(of: self.isStarting) {
                    if self.isStarting {
                        self.motionData.start(enablePrediction: true)
                    } else {
                        self.motionData.stop()
                    }
                }
            } header: {
                Text("Start")
            }
            // .headerProminence(.increased)

            Section {
                VStack {
                    HStack {
                        Text("Prediction:")
                        Spacer()
                        Text("\(self.motionData.prediction)")
                    }
                }
            } header: {
                Text("Prediction")
            }

            Section {
                VStack {
                    HStack {
                        Text("X:")
                        Spacer()
                        Text("\(self.motionData.accX)")
                    }
                }
                VStack {
                    HStack {
                        Text("Y:")
                        Spacer()
                        Text("\(self.motionData.accY)")
                    }
                }
                VStack {
                    HStack {
                        Text("Z:")
                        Spacer()
                        Text("\(self.motionData.accZ)")
                    }
                }
            } header: {
                Text("Accelerometer")
            }
            // .headerProminence(.increased)

            Section {
                VStack {
                    HStack {
                        Text("X:")
                        Spacer()
                        Text("\(self.motionData.rotationRateX)")
                    }
                }
                VStack {
                    HStack {
                        Text("Y:")
                        Spacer()
                        Text("\(self.motionData.rotationRateY)")
                    }
                }
                VStack {
                    HStack {
                        Text("Z:")
                        Spacer()
                        Text("\(self.motionData.rotationRateZ)")
                    }
                }
            } header: {
                Text("Gyro")
            }
            // .headerProminence(.increased)
        }
    }
}

#Preview {
    PredictActivityView()
}
