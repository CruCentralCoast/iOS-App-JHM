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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    
    @IBOutlet weak var fbButton: UIButton!
    
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
    
    @IBAction func rideShareButton(sender: UIButton) {
        //self.performSegueWithIdentifier("", sender: nil)
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
            nameLabel.text = event.name
            image.image = event.image
            //timeLabel.text = event.startTime + event.startamORpm + " - " + event.endTime + event.endamORpm
            descriptionView.text = event.description
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            let months = dateFormatter.monthSymbols
            let monthLong = months[event.month!-1]
            dateLabel.text = monthLong + " " + String(event.startDay!)
        }
        
        if event?.facebookURL == "" {
            fbButton.hidden = true
        }
        
        
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        var calendars = store.calendarsForEntityType(EKEntityType.Event)
        var cruCalendarCreated = false
        
        for searchCalendar in calendars {
            print(searchCalendar.title)
            if searchCalendar.title == "Cru" {
                cruCalendarCreated = true
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
        
        
        // 4
        // Create Event
        let newEvent = EKEvent(eventStore: store)
        newEvent.calendar = store.defaultCalendarForNewEvents
        
        newEvent.title = event!.name!
        newEvent.startDate = startDate!
        newEvent.endDate = endDate!
        newEvent.location = event!.location
        
        // 5
        // Save Event in Calendar
        var saveError: NSError?
        let result: Bool
        do {
            result = Bool(try store.saveEvent(newEvent, span: .ThisEvent, commit: true))
        } catch let error as NSError{
            saveError = error
        } catch {
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
