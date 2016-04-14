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
    @IBOutlet private weak var scrollingView: UIView!
    @IBOutlet private weak var descriptionView: UITextView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var fbButton: UIButton!
    @IBOutlet private weak var eventTimeLabel: UILabel!
    
    private let COVER_ALPHA: CGFloat = 0.35
    
    var mission: SummerMission!
    
    //MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check for width of phone
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        if screenSize.width <= 320.0 {
//            //make sure label fonts arent nil
//            if let titleFont = titleLabel.font {
//                titleLabel.font = UIFont(name: titleFont.fontName, size: 25)
//            }
//        }
        
        // Do any additional setup after loading the view.
        if let mission = mission {
            navigationItem.title = "Details"
            
            image.image = mission.image
            
            titleLabel.text = mission.name
            titleLabel.sizeToFit()
            
            datesLabel.text = mission.startDate.formatMonthDayYear() + " - " + mission.startDate.formatMonthDayYear()
            
            locationLabel.text = mission.country //mission.street! + ", " + event.suburb! + ", " + event.postcode!
            
            
            descriptionView.text = mission.description
            descriptionView.sizeToFit()
            //scrollingView.sizeToFit()
            
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
