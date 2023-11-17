//
//  PlayerModel.swift
//  Chess Clock
//
//  Created by Sanchez on 23.06.2023.
//

import Foundation
import UIKit

class Player {
    var timeLeft: Int?
    var countOfTurns: Int = 0
    var timerIterationsCounter: Int = 0
    var playerID: Int
    
    init(timeLeft: Int?, playerID: Int) {
        self.timeLeft = timeLeft
        self.playerID = playerID
    }
}
