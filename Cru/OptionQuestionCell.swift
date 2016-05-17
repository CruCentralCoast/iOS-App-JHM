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
    var presentingVC: SurveyViewController!
    var cgQuestion: CGQuestion!
    
    
    func setQuestion(cgq: CGQuestion) {
        cgQuestion = cgq
        question.text = cgQuestion.question
    }
    
    @IBAction func showOptions(sender: AnyObject) {
        presentingVC.showOptions(cgQuestion.options)
        //presentingVC.performSegueWithIdentifier("showOptions", sender: presentingVC)
    }
}
