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
                self.updateEverything()
            }
        }
    }
    var currentTriviaItemNumber = 0
    var currentTriviaItem: TriviaItem!
    var questionType: TypeEnum!
    var answers: [String]!
    
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
        var answers = [convertedHMTLString(for: currentTriviaItem.correctAnswer)]
        for rawAnswer in currentTriviaItem.incorrectAnswers {
            answers.append(convertedHMTLString(for: rawAnswer))
        }
        
        self.answers = answers
    }
    
    func updateEverything() {
        self.currentTriviaItem = self.triviaItems[self.currentTriviaItemNumber]
        self.getAnswers()
        self.updateUI()
    }
    
    func updateUI() {
        questionLabel.text = convertedHMTLString(for: currentTriviaItem.question)
        
        updateButtonUI()
    }
    
    func updateButtonUI() {
        setButtonVisibility()
        setButtonTitles()
    }
    
    func setButtonVisibility() {
        answerButton3.isHidden = questionType == .boolean
        answerButton4.isHidden = questionType == .boolean
    }
    
    func setButtonTitles() {
        var buttonList = [answerButton1, answerButton2]
        if questionType == .multiple  {
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
        
        // FIXME: Update UI only when OK button pressed
        updateEverything()
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let answerSelected = answers[sender.tag]
        let answerIsCorrect = answerSelected == currentTriviaItem.correctAnswer
        
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

