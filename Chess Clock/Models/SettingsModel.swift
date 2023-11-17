//
//  SettingsModel.swift
//  Chess Clock
//
//  Created by Sanchez on 24.06.2023.
//

import Foundation
import UIKit

class Settings {
    var timerTime: Int
    
    init(timerTime: Int = 60000) {
        self.timerTime = timerTime
    }
}
