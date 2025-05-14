//
//  MainViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/5/25.
//

import UIKit

struct Topic {
    var name: String
    var desc: String
    var img: UIImage?
}

struct Question {
    var text: String
    var answers: [String]
    var correctIndex: Int
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var topicTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func settingTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goPushed(_ sender: Any) {
        var url = URL(string: self.addressField.text!)
        
        if url == nil {
            NSLog("Bad address")
            return
        } else {
            var comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)
            comps?.scheme = "https"
            url = comps?.url!
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        spinner.startAnimating()
        
        (URLSession.shared.dataTask(with: url!) {
            data, response, error in
          
            DispatchQueue.main.async {
                if error == nil {
                    NSLog(response!.description)
              
                    let response = response! as! HTTPURLResponse
              
                    var headers = ""
                    headers = "\(response.statusCode)\n"
                    for (name, value) in response.allHeaderFields {
                        headers += "\(name as! String) = \(value as! String)\n"
                    }
              
                    if data == nil {
                        print("No data was retrieved")
                    } else {
                        let json = try! JSONSerialization.jsonObject(with: data!, options: [])
                        print(json)
                        NSLog(data!.description)
                    }
                } else {
                    print(error ?? "Error")
                }
                self.spinner.stopAnimating()
            }
        }).resume()
    }
    

    let topics = [
        Topic(name: "Mathematics", desc: "See if you paid attention in high school math class!", img: UIImage(systemName: "plus")),
        Topic(name: "Marvel Superheroes", desc: "Are you armed and dangerous with Marvel knowledge?", img: UIImage(systemName: "figure.run")),
        Topic(name: "Science", desc: "Would Bill Nye approve?", img: UIImage(systemName: "atom"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTable.dataSource = self
        topicTable.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)

        let topic = topics[indexPath.row]
        cell.textLabel?.text = topic.name
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.text = topic.desc
        cell.imageView?.image = topic.img

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat{
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToQuestionVC", sender: topics[indexPath.row].name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestionVC" {
            if let destinationVC = segue.destination as? QuestionViewController,
               let name = sender as? String {
                    destinationVC.receivedData = name
                }
        }
    }
    

}
