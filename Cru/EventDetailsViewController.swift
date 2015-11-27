//
//  EventDetailsViewController.swift
//  Cru
//
//  Created by Erica Solum on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let event = event {
            navigationItem.title = "Details"
            nameLabel.text = event.name
            image.image = event.image
            dateLabel.text = event.month + event.date
            timeLabel.text = event.startTime + event.startamORpm + " - " + event.endTime + event.endamORpm
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

}
