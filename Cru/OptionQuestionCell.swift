//
//  OptionQuestionCell.swift
//  Cru
//
//  Created by Peter Godkin on 5/10/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class OptionQuestionCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var question: UILabel!

    @IBOutlet weak var options: UITableView!
    
    var cgQuestion: CGQuestion!
    
    func setQuestion(cgq: CGQuestion) {
        cgQuestion = cgq
        question.text = cgQuestion.question
        
        options.delegate = self
        options.dataSource = self
        options.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("answer-cell")
        cell?.textLabel!.text = cgQuestion.options[indexPath.row]
        print(cgQuestion.options[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cgQuestion.options.count
    }
}
