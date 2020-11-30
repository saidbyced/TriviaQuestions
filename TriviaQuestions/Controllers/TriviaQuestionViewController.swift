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
                self.getAnswers()
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
            }
        }
    }
    
    func getAnswers() {
        let triviaItem = triviaItems[self.currentTriviaItemNumber]
        
        var answers = [convertedHMTLString(for: triviaItem.correctAnswer)]
        for rawAnswer in triviaItem.incorrectAnswers {
            answers.append(convertedHMTLString(for: rawAnswer))
        }
        
        self.answers = answers
    }
    
    func updateUI() {
        let triviaItem = triviaItems[self.currentTriviaItemNumber]
        
        questionLabel.text = convertedHMTLString(for: triviaItem.question)
        
        updateButtonUI(for: triviaItem)
    }
    
    func updateButtonUI(for triviaItem: TriviaItem) {
        let questionBooleanStatus = triviaItem.type == TypeEnum.boolean
        
        setButtonVisibility(for: questionBooleanStatus)
        setButtonTitles(for: questionBooleanStatus)
    }
    
    func setButtonVisibility(for questionBooleanStatus: Bool) {
        answerButton3.isHidden = questionBooleanStatus
        answerButton4.isHidden = questionBooleanStatus
    }
    
    func setButtonTitles(for questionBooleanStatus: Bool) {
        var buttonList = [answerButton1, answerButton2]
        if questionBooleanStatus != true  {
            buttonList += [answerButton3, answerButton4]
        }
        
        for (index, button) in buttonList.enumerated() {
            button?.setTitle(answers[index], for: .normal)
        }
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
        
        let alertController = UIAlertController(
            title: answerIsCorrect ? "Yussss" : "Uh oh",
            message: answerIsCorrect ? "You got it right!" : "Not the right answer",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: answerIsCorrect ? "Woop" : "Schucks",
                style: .default,
                handler: nil
            )
        )
        
        present(alertController, animated: true, completion: { self.nextQuestion() })
    }
    
    func convertedHMTLString(for htmlString: String) -> String {
        let data = Data(htmlString.utf8)
        
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString.string
        } catch {
            return ""
        }
    }
    
}

