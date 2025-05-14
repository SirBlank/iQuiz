//
//  MainViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/5/25.
//

import UIKit

struct Topic: Codable {
    var title: String
    var desc: String
    var questions: [Question]
}

struct Question: Codable {
    var text: String
    var answer: String
    var answers: [String]
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topicTable: UITableView!
    
    var topics = [Topic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTable.dataSource = self
        topicTable.delegate = self
        
        let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
        let savedURL = UserDefaults.standard.string(forKey: "quizDataURL") ?? defaultURL
        sendRequest(url: savedURL)
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    func sendRequest(url: String) {
        let url = URL(string: url)
        
        if url == nil {
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
                        let decoder = JSONDecoder()
                        do {
                            self.topics = try decoder.decode([Topic].self, from: data!)
                            self.topicTable.reloadData()
                            print(self.topics)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error ?? "Error")
                }
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)

        let topic = topics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.text = topic.desc
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(systemName: "atom")
        } else if indexPath.row == 1 {
            cell.imageView?.image = UIImage(systemName: "figure.run")
        } else {
            cell.imageView?.image = UIImage(systemName: "plus")
        }

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
        performSegue(withIdentifier: "goToQuestionVC", sender: topics[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestionVC" {
            if let destinationVC = segue.destination as? QuestionViewController,
               let name = sender as? Topic {
                    destinationVC.receivedData = name
                }
        }
    }
    

}
