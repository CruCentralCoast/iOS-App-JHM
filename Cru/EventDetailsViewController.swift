//
//  EventDetailsViewController.swift
//  Cru
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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var event: Event?
    var eventStore: EKEventStore!
    
    //MARK: Actions
    @IBAction func facebookLinkButton(sender: UIButton) {
       UIApplication.sharedApplication().openURL(NSURL(string: (event?.facebookURL)!)!)
    }
    
    @IBAction func saveToCalendar(sender: UIButton) {
        // 1
        eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore)
            sender.setImage(UIImage(named: "addedToCalendar"), forState: UIControlState.Normal)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                granted, error in
                
                if granted {
                    self.insertEvent(self.eventStore)
                } else {
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let event = event {
            
            navigationItem.title = "Details"
            titleLabel.text = event.name
            image.image = event.image
            if(event.street != nil) {
                locationLabel.text = event.street! + ", " + event.suburb! + ", " + event.postcode!
            }
            //timeLabel.text = event.startTime + event.startamORpm + " - " + event.endTime + event.endamORpm
            
            //Set up UITextView description
            //Change color ov textview to show off how the size is fucked up
            descriptionView.backgroundColor = UIColor.grayColor()
            descriptionView.text = event.description
            
           
            eventTimeLabel.text = String(event.startHour!) + ":" + String(event.startMinute!) + " — " + String(event.endHour!) + ":" + String(event.startMinute!)
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            let months = dateFormatter.monthSymbols
            let monthLong = months[event.month!-1]
            timeLabel.text = monthLong + " " + String(event.startDay!)
        }
        
        if event?.facebookURL == "" {
            fbButton.hidden = true
        }
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        for searchCalendar in calendars {
            print(searchCalendar.title)
            if searchCalendar.title == "Cru" {
                print("Calendar was previously created")
            }
        }
        
        //Let's try it on the default calendar
        let start = NSDateComponents()
        start.day = event!.startDay!
        start.month = event!.month!
        start.minute = event!.startMinute!
        start.hour = event!.startHour!
        start.year = event!.year!
        
        let end = NSDateComponents()
        end.day = event!.endDay!
        end.month = event!.month!
        end.minute = event!.endMinute!
        end.hour = event!.endHour!
        end.year = event!.year!
        
        let userCalendar = NSCalendar.currentCalendar()
        
        let startDate = userCalendar.dateFromComponents(start)
        let endDate = userCalendar.dateFromComponents(end)
        
        print("Parsed event info: minute-\(startDate) hour-\(start.hour) day-\(start.day) month-\(start.month)" )
        
        
        // 4
        // Create Event
        let newEvent = EKEvent(eventStore: store)
        newEvent.calendar = store.defaultCalendarForNewEvents
        newEvent.location = event!.street
        newEvent.title = event!.name!
        newEvent.startDate = startDate!
        newEvent.endDate = endDate!
        newEvent.location = event!.location
        
        // 5
        // Save Event in Calendar
        var saveError: NSError?
        
        do {
            try store.saveEvent(newEvent, span: .ThisEvent, commit: true)
        }
        catch let error as NSError{
            saveError = error
            print(saveError)
        }
        catch {
            fatalError()
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
