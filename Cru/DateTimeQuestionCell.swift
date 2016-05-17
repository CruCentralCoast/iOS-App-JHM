//
//  DateTimeQuestionCell.swift
//  Cru
//
//  Created by Peter Godkin on 5/10/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class DateTimeQuestionCell: UITableViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UIDatePicker!
    
    
    var cgQuestion: CGQuestion!
    
    func setQuestion(cgq: CGQuestion) {
        cgQuestion = cgq
        question.text = cgQuestion.question
    }
}
