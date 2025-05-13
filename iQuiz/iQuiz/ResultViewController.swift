//
//  ResultViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/12/25.
//

import UIKit

class ResultViewController: UIViewController {
    
    var receivedData: String?
    var correct = 0
    var total = 1
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var performanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let parts = receivedData?.split(separator: "/")
        print(receivedData ?? "Nothing")
        
        if parts?.count == 2,
           let numerator = Double(parts?[0] ?? "None"),
           let denominator = Double(parts?[1] ?? "None"),
           denominator != 0 {
            let result = numerator / denominator
            if result == 1 {
                performanceLabel.text = "Wow! You're pretty smart!"
            } else if result >= 0.5 {
                performanceLabel.text = "You're kind of smart I guess."
            } else if result > 0 {
                performanceLabel.text = "You could do better."
            } else if result == 0 {
                performanceLabel.text = "Maybe try next time?"
            }
            scoreLabel.text = "\(Int(numerator)) out of \(Int(denominator)) correct"
        }
        
    }

}
