//
//  EventDetailsViewController.swift
//  
//  This class customizes the view that is shown when an event is inspected in detail. The app switches to 
//  this view when a cell in its parent view EventCollectionViewController.swift is selected.
//
//  Created by Erica Solum on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var detailsScroller: UIScrollView!
    @IBOutlet weak var calendarButton: UIButton!
    
    //passed in prepareForSegue
    var event: Event!
    var eventLocalStorageManager: MapLocalStorageManager!
    var calendarManager: CalendarManager!
    
    //function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup local storage manager for events
        eventLocalStorageManager = MapLocalStorageManager(key: Config.eventStorageKey)
        
        //setup calendar maanger
        calendarManager = CalendarManager()
        
        //initialize the view
        initializeView()
    }
    
    //UI view initializer
    private func initializeView() {
        let dateFormat = "h:mma MMMM d, yyyy"
        
        navigationItem.title = "Event Details"
        
        //Set the UI elements to the event’s corresponding value
        image.image = event.image
        titleLabel.text = event.name
        startTimeLabel.text = GlobalUtils.stringFromDate(event.startNSDate, format: dateFormat)
        endTimeLabel.text = GlobalUtils.stringFromDate(event.endNSDate, format: dateFormat)
        descriptionView.text = event.description
        
        //insert location if there is one defined
        var locationText = "No Location Available"
        if let _ = event.location {
            locationText = event.getLocationString()
        }
        locationLabel.text = locationText
        
        //If there's no URL hide the FB button
        if event.url == "" {
            fbButton.hidden = true
        }
        
        //check if event is in calendar
        if let _ = eventLocalStorageManager.getElement(event.id) {
            self.reconfigureCalendarButton(true)
        }
    }

    
    //MARK: Actions
    
    //This action allows the user to access the event on facebook
    @IBAction func facebookLinkButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: (event.url))!)
    }
    
    //This action is for saving an event to the native calendar
    @IBAction func saveToCalendar(sender: UIButton) {
        calendarManager.addEventToCalendar(event, completionHandler: {
            errors, id in
            
            //if theres an error print it
            if errors != nil {
                print(errors)
            }
            else {
                if let _ = id {
                    self.eventLocalStorageManager.addElement(self.event.id, elem: id!)
                    self.reconfigureCalendarButton(true)
                }
            }
        })
    }
    
    //this action removes events from the calendar
    func removeFromCalendar(sender: UIButton) {
        let eventIdentifier = eventLocalStorageManager.getElement(event.id)
        
        calendarManager.removeEventFromCalendar(eventIdentifier as! String, completionHandler: {
            errors in
            
            if errors != nil {
                print(errors)
            }
            else {
                self.eventLocalStorageManager.removeElement(self.event.id)
                self.reconfigureCalendarButton(false)
            }
        })
    }
    
    //reconfigures the calendar button
    private func reconfigureCalendarButton(isInCalendar: Bool) {
        var action = "saveToCalendar:"
        var buttonImage = UIImage(named: "saveToCalendarIcon")
            
        if isInCalendar {
            action = "removeFromCalendar:"
            buttonImage = UIImage(named: "addedToCalendar")
        }
        
        calendarButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        calendarButton.addTarget(self, action: Selector(action), forControlEvents: .TouchUpInside)
        calendarButton.setImage(buttonImage, forState: .Normal)
    }

    //This function opens the ridesharing section of the application
    //from the events page
    @IBAction func linkToRideShare(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ridesByEvent") as! FilterByEventViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        vc.loadRides(event)
    }
}
