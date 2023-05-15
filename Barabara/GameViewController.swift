//
//  GameViewController.swift
//  Barabara
//
//  Created by 大森青 on 2023/05/12.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var middleImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!
    @IBOutlet var resultLabel: UILabel!
    
    var timer: Timer!
    var score: Int = 1000
    var positionX: [CGFloat] = [0.0, 0.0, 0.0]
    var dx: [CGFloat] = [1.0, 0.5, -1.0]
    
    let saveData = UserDefaults.standard
    let width: CGFloat = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        positionX = [width/2, width/2, width/2]
        self.start()
        
    }
    
    func start() {
        resultLabel.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(up), userInfo: nil, repeats: true)
        timer.fire()
    }

    @objc func up() {
        for i in 0 ..< 3 {
            if positionX[i] > width || positionX[i] < 0 {
                dx[i] *= -1
            }
            
            positionX[i] += dx[i]
        }
        
        topImageView.center.x = positionX[0]
        middleImageView.center.x = positionX[1]
        bottomImageView.center.x = positionX[2]
        
    }
    
    @IBAction func stop() {
        if timer.isValid {
            timer.invalidate()
        }
        
        for i in 0 ..< 3 {
            score -= abs(Int(width / 2 - positionX[i])) * 2
        }
        resultLabel.text = "score: " + String(score)
        resultLabel.isHidden = false
        
        let firstScore: Int = saveData.integer(forKey: "firstScore")
        let secondScore: Int = saveData.integer(forKey: "secondScore")
        let thirdScore: Int = saveData.integer(forKey: "thirdScore")
        
        if score > firstScore {
            saveData.set(score, forKey: "firstScore")
            saveData.set(firstScore, forKey: "secondScore")
            saveData.set(secondScore, forKey: "thirdScore")
        } else if score > secondScore {
            saveData.set(score, forKey: "secondScore")
            saveData.set(secondScore, forKey: "thirdScore")
        } else if score > thirdScore {
            saveData.set(score, forKey: "thirdScore")
        }
    }
    
    @IBAction func retry() {
        score = 1000
        positionX = [width/2, width/2, width/2]
        
        if !timer.isValid {
            self.start()
        }
    }
    
    @IBAction func toTop() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
