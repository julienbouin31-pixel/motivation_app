//
//  MotivationWidgetBundle.swift
//  MotivationWidget
//
//  Created by Julien on 09/04/2026.
//

import WidgetKit
import SwiftUI

@main
struct MotivationWidgetBundle: WidgetBundle {
    var body: some Widget {
        MotivationWidget()
        MotivationWidgetControl()
        MotivationWidgetLiveActivity()
    }
}
