//
//  OptionQuestionCell.swift
//  Cru
//
//  Created by Peter Godkin on 5/10/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class OptionQuestionCell: UITableViewCell {
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    var presentingVC: SurveyViewController!
    var cgQuestion: CGQuestion!
    
    
    func setQuestion(cgq: CGQuestion) {
        cgQuestion = cgq
        question.text = cgQuestion.question
    }
    
    func setOptionButtonText(text : String){
        optionButton.setTitle(text, forState: .Normal)
    }
    
    @IBAction func showOptions(sender: AnyObject) {
        presentingVC.showOptions(cgQuestion.options, optionHandler: setOptionButtonText, theCell: self)
        //presentingVC.performSegueWithIdentifier("showOptions", sender: presentingVC)
    }
}
