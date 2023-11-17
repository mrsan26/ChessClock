//
//  TimerController.swift
//  Chess Clock
//
//  Created by Sanchez on 23.06.2023.
//

import UIKit

class TimerController: UIViewController {

    @IBOutlet weak var firstPlayerTimerLabel: UILabel!
    @IBOutlet weak var secondPlayerTimerLabelView: UIView!
    @IBOutlet weak var secondPlayerTimerLabel: UILabel!
    
    @IBOutlet weak var firstPlayerCounterLabel: UILabel!
    @IBOutlet weak var secondPlayerCounterLabel: UILabel!
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var pickerBackView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    
    var firstColour: UIColor = .systemPink
    var secondColour: UIColor = UIColor(red: 255, green: 202, blue: 195)
    
    var timer: Timer?
    
    var settings: Settings = .init()
    var timeFormat = 60000
    var timeIntervalOfUpdating: Double = 0.001
    
    var playersArray: [Player] = [.init(timeLeft: nil, playerID: 1), .init(timeLeft: nil, playerID: 2)]
    var whoIsTurnID = -1
    var pickerViewSelection = 1
    var timerIsOut = false
    
//    var timerIterationsCounter = 0
    
    var timerLabelsArray: [UILabel] = []
    var pickerArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        
        setTime()
        setupUI()
        setupColours()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupColours()
    }
        
    func setTime() {
        for player in playersArray {
            player.timeLeft = settings.timerTime * pickerViewSelection
        }
        
        firstPlayerTimerLabel.text = "\((playersArray.first?.timeLeft ?? 0) / timeFormat):00"
        secondPlayerTimerLabel.text = "\((playersArray.last?.timeLeft ?? 0) / timeFormat):00"
    }
    
    private func setupColours() {
        switch UserManager.read(.colour) ?? "pink" {
        case "pink":
            firstColour = .systemPink
            secondColour = UIColor(red: 255, green: 202, blue: 195)
        case "blue":
            firstColour = .systemBlue
            secondColour = UIColor(red: 178, green: 224, blue: 250)
        default:
            break
        }
        
        settingsView.animateColorChangingView(to: secondColour)
        pickerBackView.animateColorChangingView(to: secondColour)
        
        separatorView.animateColorChangingView(to: firstColour)
        settingsButton.animateColorChangingButton(to: firstColour)
        startButton.animateColorChangingButton(to: firstColour)
        clearButton.animateColorChangingButton(to: firstColour)
        resetButton.animateColorChangingButton(to: firstColour)
        firstPlayerCounterLabel.animateColorChangingLabelText(to: firstColour)
        secondPlayerCounterLabel.animateColorChangingLabelText(to: firstColour)
        pickerView.reloadAllComponents()
    }
    
    private func setupUI() {
        secondPlayerTimerLabelView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        secondPlayerCounterLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        timerLabelsArray.append(firstPlayerTimerLabel)
        timerLabelsArray.append(secondPlayerTimerLabel)
        
        settingsView.layer.cornerRadius = settingsView.frame.width / 2.0
        pickerBackView.layer.cornerRadius = pickerBackView.frame.width / 2.0
        
        for number in 1...59 {
            pickerArray.append(number)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerLabelsUpdating(milisecundsVisibility: Bool) {
        
        let totalSeconds = (playersArray[whoIsTurnID].timeLeft ?? 0) / 1000
        
        let min = totalSeconds / (timeFormat / 1000)
        let sec = totalSeconds % (timeFormat / 1000)
        let milisec = (playersArray[whoIsTurnID].timeLeft ?? 0) % 1000
        
        var zeroSignForSec = ""
        if sec.toString().count < 2 {
            zeroSignForSec = "0"
        } else {
            zeroSignForSec = ""
        }
        
        if milisecundsVisibility {
            timerLabelsArray[whoIsTurnID].softAppearance(text: "\(min):\(zeroSignForSec)\(sec):\(milisec)")
        } else {
            timerLabelsArray[whoIsTurnID].softAppearance(text: "\(min):\(zeroSignForSec)\(sec)")
        }
    }
    
    private func timerIteration() {
        playersArray[whoIsTurnID].timeLeft? -= 1
        playersArray[whoIsTurnID].timerIterationsCounter += 1
        
        if playersArray[whoIsTurnID].timerIterationsCounter == 1000, playersArray[whoIsTurnID].timeLeft ?? 0 > 5000 {
            timerLabelsUpdating(milisecundsVisibility: false)
            playersArray[whoIsTurnID].timerIterationsCounter = 0
        } else if playersArray[whoIsTurnID].timeLeft ?? 0 < 5000 {
            timerLabelsUpdating(milisecundsVisibility: true)
        }
        
        checkAndStopTimer()
    }
    
    private func updateInfoAfterTimeout() {
        setTime()
        timerIsOut = false
        resetButton.isHidden = !timerIsOut
        for player in playersArray {
            player.timerIterationsCounter = 0
        }
    }
    
    private func resetTurnCounters() {
        for player in playersArray {
            player.countOfTurns = 0
        }
        firstPlayerCounterLabel.text = "0"
        secondPlayerCounterLabel.text = "0"
    }
    
    private func startTimer() {
        if timerIsOut {
            updateInfoAfterTimeout()
        }
        
        timerLabelsArray[whoIsTurnID].animateLabelPulse()
        timer = Timer.scheduledTimer(withTimeInterval: timeIntervalOfUpdating, repeats: true, block: { _ in
            self.timerIteration()
        })
    }
    
    private func checkAndStopTimer() {
        if playersArray[whoIsTurnID].timeLeft == 0 {
            timerIsOut = true
            timerLabelsArray[whoIsTurnID].softAppearance(text: "Время вышло!")
            resetButton.isHidden = !timerIsOut
            stopTimer()
        }
    }
    
    @IBAction func firstPlayerViewTapAction(_ sender: Any) {
        if whoIsTurnID == 0 || whoIsTurnID == -1 {
            if timer == nil {
                whoIsTurnID = 0
                startTimer()
            } else {
                stopTimer()
                
                playersArray[whoIsTurnID].countOfTurns += 1
                firstPlayerCounterLabel.softAppearance(text: playersArray[whoIsTurnID].countOfTurns.toString())
                                
                whoIsTurnID = 1
                startTimer()
            }
        }
    }
    
    @IBAction func secondPlayerViewTapAction(_ sender: Any) {
        if whoIsTurnID == 1 || whoIsTurnID == -1 {
            if timer == nil {
                whoIsTurnID = 1
                startTimer()
            } else {
                stopTimer()
                
                playersArray[whoIsTurnID].countOfTurns += 1
                secondPlayerCounterLabel.softAppearance(text: playersArray[whoIsTurnID].countOfTurns.toString())
                
                whoIsTurnID = 0
                startTimer()
            }
        }
    }
    
    
    @IBAction func pauseAllAction(_ sender: Any) {
        if timer == nil, whoIsTurnID != -1 {
            startTimer()
        } else if timer != nil, whoIsTurnID != -1 {
            stopTimer()
        } else {
            whoIsTurnID = Int.random(in: 0...1)
            startTimer()
        }
    }
    
    @IBAction func stopAction(_ sender: Any) {
        stopTimer()
        
        let alertController = UIAlertController(title: "Сброс таймеров", message: "Сбросить также счетчики ходов?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.whoIsTurnID = -1
            self.updateInfoAfterTimeout()
            self.resetTurnCounters()
            
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            self.whoIsTurnID = -1
            self.updateInfoAfterTimeout()
        }
        alertController.addAction(noAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { _ in
            if self.whoIsTurnID != -1 {
                self.startTimer()
            }
        }
        alertController.addAction(cancelAction)
        
        // Показать диалоговое окно
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsController") as? SettingsController else { return }
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
        stopTimer()
    }
    
    @IBAction func resetAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Перезапуск таймеров", message: "Сбросить счетчики ходов?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.updateInfoAfterTimeout()
            self.resetTurnCounters()
            self.startTimer()
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            self.updateInfoAfterTimeout()
            self.startTimer()
        }
        alertController.addAction(noAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { _ in
        }
        alertController.addAction(cancelAction)
        
        // Показать диалоговое окно
        present(alertController, animated: true, completion: nil)
    }
}

extension TimerController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
}

extension TimerController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = pickerArray[row].toString() // Задайте текст для отображения строки
        label.textColor = firstColour
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if timer == nil {
            pickerViewSelection = row + 1
            setTime()
        }
    }
}
