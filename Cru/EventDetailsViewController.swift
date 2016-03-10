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
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var detailsScroller: UIScrollView!
    
    //passed in prepareForSegue
    var event: Event!
    var eventStore: EKEventStore!
    
    //MARK: Actions
    @IBAction func facebookLinkButton(sender: UIButton) {
       UIApplication.sharedApplication().openURL(NSURL(string: (event.url))!)
    }
    
    @IBAction func saveToCalendar(sender: UIButton) {
        // 1 Make Event Store object
        eventStore = EKEventStore()
        
        // 2 Get Authorization
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore)
            sender.setImage(UIImage(named: "addedToCalendar"), forState: UIControlState.Normal)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3 Insert Event
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
            
            if let location = event.location {
                locationLabel.text = event.getLocationString()
            }
            
            //Set up UITextView description
            descriptionView.text = event.description
            
            print(event)
            
            let dFormat = "h:mma MMMM d, yyyy"
            startTimeLabel.text = GlobalUtils.stringFromDate(event.startNSDate, format: dFormat)
            endTimeLabel.text = GlobalUtils.stringFromDate(event.endNSDate, format: dFormat)
            //eventTimeTextView.text = GlobalUtils.stringCompressionOfDates(event.startNSDate, date2: event.endNSDate)
            
            if event.url == "" {
                fbButton.hidden = true
            }
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
        
        // 4
        // Create Event
        let newEvent = EKEvent(eventStore: store)
        newEvent.calendar = store.defaultCalendarForNewEvents
        //newEvent.location = event.location
        newEvent.title = event.name
        newEvent.startDate = event.startNSDate
        newEvent.endDate = event.endNSDate
        
        // 5
        // Save Event in Calendar
        
        do {
            try store.saveEvent(newEvent, span: .ThisEvent, commit: true)
        }
        catch let error as NSError{
            print(error)
        }
        catch {
            fatalError()
        }
    }

    @IBAction func linkToRideShare(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ridesByEvent") as! FilterByEventViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        //self.presentViewController(vc, animated: true, completion: nil)
        vc.loadEvents({ vc.selectVal(self.event)})
        
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
