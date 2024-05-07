//
//  CollectActivityDataView.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/05/07.
//

import SwiftUI

struct CollectActivityDataView: View {
    private let items: [String] = ["Stay", "Walk", "Run", "Bicycle", "Train", "Automobile"]
    @State private var selected: String?
    @State private var isStarting: Bool = false
    @ObservedObject private var motionData = MotionData()

    var body: some View {
        List {
            Section {
                ForEach(items, id: \.self) { item in
                    Button {
                        selected = item
                        self.motionData.setActivity(activity: item)
                    } label: {
                        Text(item)
                            .foregroundColor(self.selected == item ? Color(.white) : Color(.blue))
                    }
                    .listRowBackground(selected == item ? Color(.blue) : Color(.systemGroupedBackground))
                }
            } header: {
                Text("Collecting Data for ...")
            }
            // .headerProminence(.increased)

            Section {
                Toggle(isOn: self.$isStarting, label: {
                    Text("Collecting Start")
                })
                .onChange(of: self.isStarting) {
                    if self.isStarting {
                        self.motionData.start()
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
    CollectActivityDataView()
}
