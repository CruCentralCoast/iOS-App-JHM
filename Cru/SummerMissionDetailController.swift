//
//  SummerMissionDetailController.swift
//  Cru
//
//  Created by Quan Tran on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import EventKit

class SummerMissionDetailController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    
    var mission: SummerMission?
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let mission = mission {
            
            navigationItem.title = "Details"
            titleLabel.text = mission.name
            image.image = mission.image
            
            locationLabel.text = mission.country //mission.street! + ", " + event.suburb! + ", " + event.postcode!
            
            //timeLabel.text = event.startTime + event.startamORpm + " - " + event.endTime + event.endamORpm
            
            //Set up UITextView description
            descriptionView.text = mission.description
            
            
            //eventTimeLabel.text = String(event.startHour!) + ":" + String(event.startMinute!) + " — " + String(event.endHour!) + ":" + String(event.startMinute!)
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            /*
            let months = dateFormatter.monthSymbols
            let monthLong = months[mission.month!-1]
            timeLabel.text = monthLong + " " + String(event.startDay!)\
            */
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
