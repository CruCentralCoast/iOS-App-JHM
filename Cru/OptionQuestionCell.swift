//
//  OptionQuestionCell.swift
//  Cru
//
//  Created by Peter Godkin on 5/10/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class OptionQuestionCell: UITableViewCell {
    static let selectOption = "SelectOption"
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    var presentingVC: SurveyViewController!
    var cgQuestion: CGQuestion!
    
    func getAnswer() -> CGQuestionAnswer? {
        let answer = optionButton.currentTitle
        if (answer != OptionQuestionCell.selectOption) {
            return CGQuestionAnswer(question: cgQuestion.id, value: answer!)
        } else {
            return nil
        }
    }
    
    func setQuestion(cgq: CGQuestion) {
        cgQuestion = cgq
        error.text = ""
        question.text = cgQuestion.question
        optionButton.setTitle(OptionQuestionCell.selectOption, forState: .Normal)
    }
    
    func setOptionButtonText(text : String){
        optionButton.setTitle(text, forState: .Normal)
    }
    
    @IBAction func showOptions(sender: AnyObject) {
        presentingVC.showOptions(cgQuestion.options, optionHandler: setOptionButtonText, theCell: self)
        //presentingVC.performSegueWithIdentifier("showOptions", sender: presentingVC)
    }
}
