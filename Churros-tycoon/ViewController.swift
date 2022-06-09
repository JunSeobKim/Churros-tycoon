//
//  ViewController.swift
//  Churros-tycoon
//
//  Created by 김준섭 on 2022/06/10.
//

import UIKit

class ViewController: UIViewController {
    
    var nowGaming: Bool = false
    var time = 60

    // 게임 시작
    @IBAction func gameStartBtnDidTapped(_ sender: UIButton) {
        // 게임이 실행중인지 확인
        guard !nowGaming else { /* TODO: 실행중이라는 경고 띄우기 */ return }
        // 게임 실행 세팅
        nowGaming = true
        time = 60
        // 시간카운트 시작
        DispatchQueue.global().async { self.setupTimer() }
        
    }
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func setupTimer() {
        for i in 0...60 {
            DispatchQueue.main.async { self.timeLabel.text = String(60 - i) }
            usleep(1000000)
            // TODO: 게임 끝 동작
        }
    }
}

