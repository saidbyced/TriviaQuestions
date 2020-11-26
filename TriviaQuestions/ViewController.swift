//
//  ViewController.swift
//  TriviaQuestions
//
//  Created by Chris Eadie on 26/11/2020.
//

import UIKit

class ViewController: UIViewController {
    
    let triviaAPIRequest = TriviaRequest()
    var triviaItems = [TriviaItem]() {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        triviaAPIRequest.getTrivia { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let triviaItems):
                self?.triviaItems = triviaItems
            }
        }
    }
    
    func updateUI() {
        // Set state of UI
    }

}

