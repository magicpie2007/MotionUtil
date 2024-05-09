//
//  NavigationModifier.swift
//  MotionUtil
//
//  Created by hiroyuki shoji on 2024/05/07.
//

import SwiftUI

enum FeatureMenu: Hashable {
    case feature_collect_activity_data
    case feature_predict_activity
}

struct NavigationModifier: ViewModifier {
    @Binding var path: [FeatureMenu]

    @ViewBuilder
    fileprivate func coordinator(_ featureMenu: FeatureMenu) -> some View {
        switch featureMenu {
        case .feature_collect_activity_data:
            CollectActivityDataView()
        case .feature_predict_activity:
            PredictActivityView()
        }
    }

    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .navigationDestination(for: FeatureMenu.self) { featureMenu in
                    coordinator(featureMenu)
                }
        }
    }
}

extension View {
    func navigation(path: Binding<[FeatureMenu]>) -> some View {
        self.modifier(NavigationModifier(path: path))
    }
}
