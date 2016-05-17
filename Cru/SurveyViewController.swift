//
//  SurveyViewController.swift
//  Cru
//
//  Created by Peter Godkin on 5/5/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import MRProgress
import UIKit

class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let textId = "text-cell"
    let optionId = "option-cell"
    let datetimeId = "datetime-cell"
    
    var questions = [UITableViewCell]()

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        
        CruClients.getServerClient().getData(DBCollection.MinistyQuestion, insert: insertQuestion, completionHandler: finishInserting)
        // Do any additional setup after loading the view.
    }
    
    private func insertQuestion(dict: NSDictionary) {
        let question = CGQuestion(dict: dict)
        
        var cell: UITableViewCell
        switch (question.type) {
            case .TEXT:
                cell = self.table.dequeueReusableCellWithIdentifier(textId)!
                let textCell = cell as! TextQuestionCell
                textCell.setQuestion(question)
                break;

            case .SELECT:
                cell = self.table.dequeueReusableCellWithIdentifier(optionId)!
                let selectCell = cell as! OptionQuestionCell
                selectCell.setQuestion(question)
                break;
            
            case .DATETIME:
                cell = self.table.dequeueReusableCellWithIdentifier(datetimeId)!
                let datetimeCell = cell as! DateTimeQuestionCell
                datetimeCell.setQuestion(question)
                break;
        }
        questions.append(cell)
        table.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        
    }
    
    private func finishInserting(success: Bool) {
        table.reloadData()
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = questions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell = questions[indexPath.row]
        switch (cell.reuseIdentifier!) {
        case textId:
            return 150
            
        case optionId:
            let selectCell = cell as? OptionQuestionCell
            return 150.0 + CGFloat(selectCell!.cgQuestion.options.count) * 44.0
            
        case datetimeId:
            return 150
            
        default:
            return 100
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
