//
//  ViewController.swift
//  Churros-tycoon
//
//  Created by 김준섭 on 2022/06/10.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let menu = ["초코츄러스", "설탕츄러스", "생크림츄러스"]
    let people = ["people01", "people02", "people03", "people04", "people05", "people06", "people07", "people08"]
    let skimmer: Array = ["바구니", "바구니01", "바구니02", "바구니03", "바구니04", "바구니05", "바구니06", "바구니07", "바구니08"]
    
    var nowGaming: Bool = false
    var hand: String = ""
    var score: Int = 0
    var leftFryer: String = ""
    var rightFryer: String = ""
    var nowSkimmer: Int = 0
    var peopleOrder: String = "초코츄러스"
    
    var audioPlayer: AVAudioPlayer?

    // 게임 시작
    @IBAction func gameStartBtnDidTapped(_ sender: UIButton) {
        // 게임이 실행중인지 확인
        guard !nowGaming else { /* TODO: 실행중이라는 경고 띄우기 */ return }
        // 게임 실행 세팅
        nowGaming = true
        score = 0
        scoreLabel.text = String(0)
        usleep(1000000)
        peopleDidTappedBGImage.setBackgroundImage(UIImage(named: "people0\(Int.random(in: 1...8))"), for: .normal)
        peopleOrder = menu[Int.random(in: 0...2)]
        orderFoodImage.image = UIImage(named: peopleOrder)
        // 시간카운트 시작
        DispatchQueue.global().async { self.setupTimer() }
        
    }
    
    @IBAction func kneaderBtnDidTapped(_ sender: UIButton) {
        guard hand == "" else { /* TODO: 손에 아무것도 없어야 한다는 경고 띄우기 */ return }
        hand = "반죽츄러스"
        handImage.image = UIImage(named: "before-churros")
    }
    
    @IBAction func leftFryerBtnDidTapped(_ sender: UIButton) {
        if hand == "반죽츄러스" && leftFryer == "" {
            leftFryer = "반죽츄러스"
            leftFryerBGImage.setBackgroundImage(UIImage(named: "before-churros"), for: .normal)
            hand = ""
            handImage.image = nil
            DispatchQueue.global().async { self.setupFryChurros(leftRight: "left") }
        } else if hand == "" {
            if(leftFryer == "츄러스") {
                hand = "츄러스"
                handImage.image = UIImage(named: "churros")
                leftFryer = ""
                leftFryerBGImage.setBackgroundImage(nil, for: .normal)
            } else if(leftFryer == "탄츄러스") {
                hand = "탄츄러스"
                handImage.image = UIImage(named: "bad-churros")
                leftFryer = ""
                leftFryerBGImage.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    @IBAction func rightFryerBtnDidTapped(_ sender: UIButton) {
        if hand == "반죽츄러스" && rightFryer == "" {
            rightFryer = "반죽츄러스"
            rightFryerBGImage.setBackgroundImage(UIImage(named: "before-churros"), for: .normal)
            hand = ""
            handImage.image = nil
            DispatchQueue.global().async { self.setupFryChurros(leftRight: "right") }
        } else if hand == "" {
            if(rightFryer == "츄러스") {
                hand = "츄러스"
                handImage.image = UIImage(named: "churros")
                rightFryer = ""
                rightFryerBGImage.setBackgroundImage(nil, for: .normal)
            } else if(rightFryer == "탄츄러스") {
                hand = "탄츄러스"
                handImage.image = UIImage(named: "bad-churros")
                rightFryer = ""
                rightFryerBGImage.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    @IBAction func skimmerDidTapped(_ sender: UIButton) {
        if hand == "츄러스" && nowSkimmer < 8 {
            hand = ""
            handImage.image = nil
            nowSkimmer += 1
            skimmerBGImage.setBackgroundImage(UIImage(named: skimmer[nowSkimmer]), for: .normal)
        } else if hand == "" && nowSkimmer > 0 {
            hand = "츄러스"
            handImage.image = UIImage(named: "churros")
            nowSkimmer -= 1
            skimmerBGImage.setBackgroundImage(UIImage(named: skimmer[nowSkimmer]), for: .normal)
        }
    }
    
    @IBAction func trashCanDidTapped(_ sender: UIButton) {
        hand = ""
        handImage.image = nil
    }
    
    @IBAction func sugarSauceDidTapped(_ sender: UIButton) {
        sauceChurros(sauce: "설탕")
    }
    @IBAction func chocoSauceDidTapped(_ sender: UIButton) {
        sauceChurros(sauce: "초코")
    }
    @IBAction func creamSauceDidTapped(_ sender: UIButton) {
        sauceChurros(sauce: "생크림")
    }
    
    @IBAction func peopleDidTapped(_ sender: UIButton) {
        guard nowGaming else { return }
        DispatchQueue.global().async {
            if(self.hand == self.peopleOrder) {
                self.hand = ""
                DispatchQueue.main.async {
                    self.handImage.image = nil
                    self.orderFoodImage.image = UIImage(named: "success")
                    self.score += 100
                    self.scoreLabel.text = String(self.score)
                    self.peopleOrder = "nil"
                    self.resultImage.image = UIImage(named: "success")
                    self.resultImage.fadeIn()
                    self.resultImage.fadeOut()
                    self.peopleDidTappedBGImage.setBackgroundImage(UIImage(named: "people0\(Int.random(in: 1...8))"), for: .normal)
                    self.peopleOrder = self.menu[Int.random(in: 0...2)]
                    self.orderFoodImage.image = UIImage(named: self.peopleOrder)
                }
            } else {
                self.hand = ""
                DispatchQueue.main.async {
                    self.handImage.image = nil
                    self.orderFoodImage.image = UIImage(named: "failed")
                    self.score -= 100
                    self.scoreLabel.text = String(self.score)
                    self.peopleOrder = "nil"
                    self.resultImage.image = UIImage(named: "failed")
                    self.resultImage.fadeIn()
                    self.resultImage.fadeOut()
                    self.peopleDidTappedBGImage.setBackgroundImage(nil, for: .normal)
                    self.orderFoodImage.image = nil
                    self.peopleDidTappedBGImage.setBackgroundImage(UIImage(named: "people0\(Int.random(in: 1...8))"), for: .normal)
                    self.peopleOrder = self.menu[Int.random(in: 0...2)]
                    self.orderFoodImage.image = UIImage(named: self.peopleOrder)
                }
            }
        }
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var handImage: UIImageView!
    @IBOutlet weak var leftFryerBGImage: UIButton!
    @IBOutlet weak var rightFryerBGImage: UIButton!
    @IBOutlet weak var skimmerBGImage: UIButton!
    @IBOutlet weak var orderFoodImage: UIImageView!
    @IBOutlet weak var peopleDidTappedBGImage: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peopleDidTappedBGImage.setBackgroundImage(nil, for: .normal)
        self.orderFoodImage.image = nil
        playMusic()
    }
    
    func setupTimer() {
        for i in 0...60 {
            DispatchQueue.main.async { self.timeLabel.text = String(60 - i) }
            usleep(1000000)
            DispatchQueue.main.async {
                if(self.timeLabel.text == "0") {
                // 게임 끝 동작
                    let alert = UIAlertController(title: "게임 끝", message: "점수 : \(self.score)", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)

                    self.nowGaming = false
                    self.peopleDidTappedBGImage.setBackgroundImage(nil, for: .normal)
                    self.orderFoodImage.image = nil
                }
            }
        }
    }
    
    func setupFryChurros(leftRight: String) {
        for i in 0...15 {
            usleep(1000000)
            if(i == 5) {
                if(leftRight == "left") {
                    leftFryer = "츄러스"
                    DispatchQueue.main.async {
                        self.leftFryerBGImage.setBackgroundImage(UIImage(named: "churros"), for: .normal)
                    }
                } else if(leftRight == "right") {
                    rightFryer = "츄러스"
                    DispatchQueue.main.async {
                        self.rightFryerBGImage.setBackgroundImage(UIImage(named: "churros"), for: .normal)
                    }
                }
                
            }else if(i == 15) {
                if(leftFryer == "츄러스" && leftRight == "left") {
                    leftFryer = "탄츄러스"
                    DispatchQueue.main.async {
                        self.leftFryerBGImage.setBackgroundImage(UIImage(named: "bad-churros"), for: .normal)
                    }
                } else if(rightFryer == "츄러스" && leftRight == "right") {
                    rightFryer = "탄츄러스"
                    DispatchQueue.main.async {
                        self.rightFryerBGImage.setBackgroundImage(UIImage(named: "bad-churros"), for: .normal)
                    }
                }
            }
        }
    }
    
    func sauceChurros(sauce: String) {
        guard hand == "츄러스" else { return }
        hand = "\(sauce)츄러스"
        switch sauce {
        case "설탕":
            handImage.image = UIImage(named: "sugar-churros")
            break
        case "초코":
            handImage.image = UIImage(named: "choco-churros")
            break
        case "생크림":
            handImage.image = UIImage(named: "cream-churros")
            break
        default:
            break
        }
    }
    
    @objc private func playMusic() {
        let url = Bundle.main.url(forResource: "ES_8-bit Sheriff - Wave Saver", withExtension: "mp3")
            if let url = url {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    audioPlayer?.numberOfLoops = -1
                } catch {
                    print(error)
                }
            }
    }
    
}

extension UIView {
    func fadeIn(duration: TimeInterval = 0.3) {
         UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
         })
     }

    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
      }
}
