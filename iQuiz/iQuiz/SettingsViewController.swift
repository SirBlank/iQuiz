//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/13/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var topics: [Topic]?

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.isHidden = true
    }
    
    @IBAction func checkNowTapped(_ sender: Any) {
        
        sendRequest(url: addressField.text!)
    }
    
    func sendRequest(url: String) {
        let url = URL(string: url)
        
        if url == nil {
            statusLabel.text = "Invalid URL!"
            statusLabel.isHidden = false
            return
        }
        
        var comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        comps?.scheme = "https"
        let new_url = comps?.url
        
        var request = URLRequest(url: new_url!)
        request.httpMethod = "GET"
        
        (URLSession.shared.dataTask(with: new_url!) {
            data, response, error in
          
            DispatchQueue.main.async {
                if error == nil {
                    let response = response! as! HTTPURLResponse
              
                    var headers = ""
                    headers = "\(response.statusCode)\n"
                    for (name, value) in response.allHeaderFields {
                        headers += "\(name as! String) = \(value as! String)\n"
                    }
              
                    if data == nil {
                        self.statusLabel.text = "No data returned!"
                        self.statusLabel.isHidden = false
                    } else {
                        let decoder = JSONDecoder()
                        do {
                            self.topics = try decoder.decode([Topic].self, from: data!)
                            UserDefaults.standard.set(data, forKey: "quizData")
                            self.statusLabel.text = "Data retrieved!"
                            self.statusLabel.isHidden = false
                        } catch {
                            self.statusLabel.text = "Error parsing JSON!"
                            self.statusLabel.isHidden = false
                        }
                    }
                } else {
                    self.statusLabel.text = "Request failed!"
                    self.statusLabel.isHidden = false
                    print(error ?? "Error")
                }
            }
        }).resume()
    }
    

}
