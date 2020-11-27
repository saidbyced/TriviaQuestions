//
//  ViewController.swift
//  TriviaQuestions
//
//  Created by Chris Eadie on 26/11/2020.
//

import UIKit

class TriviaQuestionViewController: UIViewController {
    
    let triviaAPIRequest = TriviaRequest()
    var triviaItems = [TriviaItem]() {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    var questionIsBoolean = false
    var answers = [String]()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triviaAPIRequest.getTrivia { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let triviaItems):
                self?.triviaItems = triviaItems
                self?.questionIsBoolean = triviaItems[0].type == TypeEnum.boolean
                
                var answers = [triviaItems[0].correctAnswer]
                for answer in triviaItems[0].incorrectAnswers {
                    answers.append(answer)
                }
                answers.shuffle()
                
                self?.answers = answers
            }
        }
    }
    
    func updateUI() {
        updateButtonsPresenceForQuestionType()
        updateUILabels()
    }
    
    func updateButtonsPresenceForQuestionType() {
        if questionIsBoolean {
            answerButton3.isHidden = true
            answerButton4.isHidden = true
        } else {
            answerButton3.isHidden = false
            answerButton4.isHidden = false
        }
    }
    
    func updateUILabels() {
        let triviaItem = triviaItems[0]
        
        questionLabel.text = triviaItem.question
        
        if questionIsBoolean {
            answerButton1.setTitle(answers[0], for: .normal)
            answerButton2.setTitle(answers[1], for: .normal)
        } else {
            answerButton1.setTitle(answers[0], for: .normal)
            answerButton2.setTitle(answers[1], for: .normal)
            answerButton3.setTitle(answers[2], for: .normal)
            answerButton4.setTitle(answers[3], for: .normal)
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let answerSelected = answers[sender.tag]
        let answerIsCorrect = answerSelected == triviaItems[0].correctAnswer
        
        var alertTitle: String
        var alertMessage: String
        var alertActionTitle: String
        
        if answerIsCorrect {
            alertTitle = "Yussss"
            alertMessage = "You got it right!"
            alertActionTitle = "Woop"
        } else {
            alertTitle = "Uh oh"
            alertMessage = "Not the right answer"
            alertActionTitle = "Schucks"
        }

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: {
            print("next question please")
        })
    }
}

