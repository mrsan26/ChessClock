//
//  SettingsController.swift
//  Chess Clock
//
//  Created by Sanchez on 24.06.2023.
//

import UIKit


class SettingsController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    private let settingsMenu: [[SettingPoints]] = [[.timerMode], [.colourSet]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        obsereverSet()
    }
    
    private func setupTable() {
        settingsTableView.dataSource = self
    }
    
    private func obsereverSet() {
        // Регистрация наблюдателя уведомления
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("UpdateTableView"), object: nil)
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        // Код, который будет выполнен при получении уведомления
        settingsTableView.reloadData()
    }
    
}

extension SettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenu[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.id, for: indexPath)
        guard let settingCell = cell as? SettingCell else { return .init() }
        let point = settingsMenu[indexPath.section][indexPath.row]
        settingCell.setupWith(point)
        return settingCell
    }
}
