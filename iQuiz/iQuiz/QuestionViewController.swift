//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/11/25.
//

import UIKit

class QuestionViewController: UIViewController {
    var receivedData: String?

    @IBOutlet weak var topicLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = receivedData {
            topicLabel.text = "\(data)"
        } else {
            topicLabel.text = "Did not click on cell"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
