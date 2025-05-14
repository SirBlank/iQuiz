//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/13/25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.isHidden = true
    }
    
    @IBAction func checkNowTapped(_ sender: Any) {
        guard let urlString = addressField.text else {
            statusLabel.text = "Invalid URL."
            statusLabel.isHidden = false
            return
        }
        
        statusLabel.text = "Valid URL!"
        statusLabel.isHidden = false
        UserDefaults.standard.set(urlString, forKey: "quizDataURL")
    }
    

}
