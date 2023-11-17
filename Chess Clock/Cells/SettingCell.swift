//
//  SettingCell.swift
//  Chess Clock
//
//  Created by Sanchez on 09.07.2023.
//

import UIKit

class SettingCell: UITableViewCell {
    
    static let id = String(describing: SettingCell.self)
    
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var firstColour: UIColor = .systemPink
    
    var currentPoint: SettingPoints?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(_ point: SettingPoints) {
        setupColours()
        self.currentPoint = point
        nameLabel.text = point.title
        settingImage.image = point.image
        settingImage.tintColor = firstColour
        menuButton.menu = point.buttonMenu
        menuButton.tintColor = firstColour
    }
    
    private func setupColours() {
        switch UserManager.read(.colour) ?? "pink" {
        case "pink":
            firstColour = .systemPink
        case "blue":
            firstColour = .systemBlue
        default:
            break
        }
    }

}
