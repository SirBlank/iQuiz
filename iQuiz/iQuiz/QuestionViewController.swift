//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/11/25.
//

import UIKit


class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var receivedData: Topic?
    
    var currentQuestions: [Question] = []
    var currentIndex = 0
    var selectedAnswerIndex: Int? = nil
    var hasSubmitted = false
    var score = 0
    var numQuestions = 0

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        score = 0
        currentIndex = 0
        selectedAnswerIndex = nil
        hasSubmitted = false
        
        answerTable.delegate = self
        answerTable.dataSource = self
        
        resultBtn.isHidden = true
        
        if let data = receivedData {
            topicLabel.text = data.title
            numQuestions = data.questions.count
            currentQuestions = data.questions
            showCurrentQuestion()
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestions[currentIndex].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        let option = currentQuestions[currentIndex].answers[indexPath.row]
        cell.textLabel?.text = option
        cell.accessoryType = (indexPath.row == selectedAnswerIndex) ? .checkmark : .none
        
        if hasSubmitted {
            let correctIndex = Int(currentQuestions[currentIndex].answer)! - 1
            if indexPath.row == correctIndex {
                cell.textLabel?.textColor = .green
            } else if indexPath.row == selectedAnswerIndex {
                cell.textLabel?.textColor = .red
            }
        } else {
            cell.textLabel?.textColor = .label
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !hasSubmitted {
            selectedAnswerIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
    func showCurrentQuestion() {
        hasSubmitted = false
        selectedAnswerIndex = nil
        questionLabel.text = currentQuestions[currentIndex].text
        submitBtn.setTitle("Submit", for: .normal)
        answerTable.reloadData()
    }

    @IBAction func submitTapped(_ sender: Any) {
        guard let selected = selectedAnswerIndex else { return }
        
        if !hasSubmitted {
            let correctIndex = Int(currentQuestions[currentIndex].answer)! - 1
            if selected == correctIndex {
                score += 1
            }
            hasSubmitted = true
            answerTable.reloadData()
            submitBtn.setTitle("Next", for: .normal)
        } else {
            currentIndex += 1
            if currentIndex < currentQuestions.count {
                showCurrentQuestion()
            } else {
                resultBtn.isHidden = false
                submitBtn.isHidden = true
                let final_score = "\(score)/\(numQuestions)"
                performSegue(withIdentifier: "goToResultVC", sender: final_score)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResultVC" {
            if let destinationVC = segue.destination as? ResultViewController,
               let score = sender as? String {
                    destinationVC.receivedData = score
                }
        }
    }
}
