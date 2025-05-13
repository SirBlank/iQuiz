//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Amber Wu on 5/11/25.
//

import UIKit

let questionBank = [
    "Mathematics": [
        Question(text: "What is 9 + 10?", answers: ["2", "19", "21", "22"], correctIndex: 1),
        Question(text: "What is 100 - 25?", answers: ["75", "80", "90", "100"], correctIndex: 0)
    ],
    "Marvel Superheroes": [
        Question(text: "Who is Spiderman", answers: ["Peter Parker", "J. Jonah Jameson", "Tony Stark"], correctIndex: 0),
        Question(text: "What is the name of Thor's hammer?", answers: ["Milnojuor", "Mijolnier", "Jonathon", "Mjolnir"], correctIndex: 3),
        Question(text: "Which of Bucky's arms is made of metal?", answers: ["Right", "Left"], correctIndex: 1)
    ],
    "Science": [
        Question(text: "How many bones are there in a human foot?", answers: ["26", "28", "30", "32"], correctIndex: 0),
        Question(text: "Which animal possesses the largest brain relative to its body size?", answers: ["Elephant", "Sperm whale", "Dolphin", "Gorilla"], correctIndex: 1)
    ]
]

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var receivedData: String?
    
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
            topicLabel.text = data
            numQuestions = questionBank[data]?.count ?? 0
            currentQuestions = questionBank[data] ?? []
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
            let correctIndex = currentQuestions[currentIndex].correctIndex
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
            let correctIndex = currentQuestions[currentIndex].correctIndex
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
