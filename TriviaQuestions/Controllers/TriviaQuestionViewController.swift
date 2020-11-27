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
    var currentTriviaItemNumber = 0
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
                self?.getAnswers()
            }
        }
    }
    
    func updateUI() {
        let triviaItem = triviaItems[self.currentTriviaItemNumber]
        let questionIsBoolean = triviaItem.type == TypeEnum.boolean
        
        questionLabel.text = triviaItem.question
        
        if questionIsBoolean {
            answerButton3.isHidden = true
            answerButton4.isHidden = true
            answerButton1.setTitle(answers[0], for: .normal)
            answerButton2.setTitle(answers[1], for: .normal)
        } else {
            answerButton3.isHidden = false
            answerButton4.isHidden = false
            answerButton1.setTitle(answers[0], for: .normal)
            answerButton2.setTitle(answers[1], for: .normal)
            answerButton3.setTitle(answers[2], for: .normal)
            answerButton4.setTitle(answers[3], for: .normal)
        }
    }
    
    func getAnswers() {
        let triviaItem = triviaItems[self.currentTriviaItemNumber]
        
        var answers = [triviaItem.correctAnswer]
        for answer in triviaItem.incorrectAnswers {
            answers.append(answer)
        }
        answers.shuffle()
        
        self.answers = answers
    }
    
    func nextQuestion() {
        guard self.currentTriviaItemNumber < 9 else {
            // FIXME: Handle question count greater than 10
            fatalError()
        }
        self.currentTriviaItemNumber += 1
        getAnswers()
        // FIXME: Update UI only when OK button pressed
        updateUI()
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let answerSelected = answers[sender.tag]
        let answerIsCorrect = answerSelected == triviaItems[self.currentTriviaItemNumber].correctAnswer
        
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
            self.nextQuestion()
        })
    }
}

