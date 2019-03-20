//
//  ViewController.swift
//  Stopwatch
//
//  Created by Hung-Ching Song on 2019/3/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController, UITableViewDataSource {
    private var stopwatch: Stopwatch!
    private var timer: Timer?
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var viewContainingStartAndResetButtons: UIView!
    @IBOutlet var viewContainingStopAndLapButtons: UIView!
    @IBOutlet var tableViewLaps: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopwatch = loadStopwatch() ?? Stopwatch()
        displayTimeText()
        if stopwatch.isStarted {
            viewContainingStartAndResetButtons.isHidden = true
            startTimer()
        } else {
            viewContainingStopAndLapButtons.isHidden = true
        }
        observeDidEnterBackground {
            print("ENTERING BACKGROUND")
            self.stopTimer()
            saveStopwatch(self.stopwatch)
        }
        observeWillEnterForeground {
            print("ENTERING FOREGROUND")
            if self.stopwatch.isStarted {
                self.startTimer()
            }
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        stopwatch.start()
        startTimer()
        viewContainingStartAndResetButtons.isHidden = true
        viewContainingStopAndLapButtons.isHidden = false
    }
    
    @IBAction func stop(_ sender: UIButton) {
        stopwatch.stop()
        stopTimer()
        viewContainingStartAndResetButtons.isHidden = false
        viewContainingStopAndLapButtons.isHidden = true
    }
    
    @IBAction func reset(_ sender: UIButton) {
        stopwatch.reset()
        displayTimeText()
        tableViewLaps.reloadData()
    }
    
    @IBAction func lap(_ sender: UIButton) {
        stopwatch.lap()
        tableViewLaps.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopwatch.laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lapTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LapTableViewCell", for: indexPath) as! LapTableViewCell
        lapTableViewCell.bind(stopwatch.laps[indexPath.row])
        return lapTableViewCell
    }
    
    private func displayTimeText() {
        labelTime.text = stopwatch.getTimeText()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {
            _ in self.displayTimeText()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}
