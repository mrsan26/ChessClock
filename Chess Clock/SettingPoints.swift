//
//  SettingPoints.swift
//  Chess Clock
//
//  Created by Sanchez on 09.07.2023.
//

import Foundation
import UIKit

enum SettingPoints {
    case timerMode
    case colourSet
    
    
    //    надпись на ячейке (для чего настройка)
    var title: String {
        switch self {
        case .timerMode:
            return "Режми таймера"
        case .colourSet:
            return "Цветовая тема"
        }
    }
    
    var buttonMenu: UIMenu {
        switch self {
        case .timerMode:
            let first = UIAction(title: "На всю игру") { action in
                print("1")
            }
            let second = UIAction(title: "На один ход") { action in
                print("2")
            }
            let menuElements: [UIAction] = [first, second]
            let menu = UIMenu(title: "Режим таймера", children: menuElements)
            return menu
            
        case .colourSet:
            let pink = UIAction(title: "Розовая") { action in
                UserManager.write(value: "pink", for: .colour)
                
                // Отправка уведомления
                NotificationCenter.default.post(name: Notification.Name("UpdateTableView"), object: nil)
            }
            let blue = UIAction(title: "Синяя") { action in
                UserManager.write(value: "blue", for: .colour)
                
                // Отправка уведомления
                NotificationCenter.default.post(name: Notification.Name("UpdateTableView"), object: nil)
            }
            
            switch UserManager.read(.colour) ?? "pink" {
            case "pink":
                pink.state = .on
            case "blue":
                blue.state = .on
            default:
                break
            }
            
            let menuElements: [UIAction] = [pink, blue]
            let menu = UIMenu(title: "Цветовая тема", children: menuElements)
            return menu
        }
    }
    
    //    картинка настройки, у каждого своя
    var image: UIImage? {
        switch self {
        case .timerMode:
            return UIImage(systemName: "clock.circle.fill")
        case .colourSet:
            return UIImage(systemName: "paintpalette.fill")
        }
    }
    
}

