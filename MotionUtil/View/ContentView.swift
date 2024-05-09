//
//  ContentView.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/04/15.
//

import SwiftUI

struct ContentView: View {
    @State private var path = [FeatureMenu]()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(value: FeatureMenu.feature_collect_activity_data) {
                    Text("Collect Activity Data")
                    Spacer()
                }
                NavigationLink(value: FeatureMenu.feature_predict_activity) {
                    Text("Predict Activity")
                    Spacer()
                }
            }
            .navigationBarTitle("Motion Util")
            .navigation(path: $path)
        }
    }
}

#Preview {
    ContentView()
}
