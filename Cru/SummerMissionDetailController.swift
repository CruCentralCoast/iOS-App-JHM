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
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var topCoverView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datesLabel: UILabel!
    @IBOutlet private weak var descriptionView: UITextView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var fbButton: UIButton!
    @IBOutlet private weak var eventTimeLabel: UILabel!
    
    private let COVER_ALPHA: CGFloat = 0.35
    
    var mission: SummerMission!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let mission = mission {
            navigationItem.title = "Details"
            
            image.image = mission.image
            
            titleLabel.text = mission.name
            
            datesLabel.text = mission.startDate.formatMonthDayYear() + " - " + mission.startDate.formatMonthDayYear()
            
            locationLabel.text = mission.country //mission.street! + ", " + event.suburb! + ", " + event.postcode!
            
            
            descriptionView.text = mission.description
            
            topCoverView.alpha = COVER_ALPHA
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
