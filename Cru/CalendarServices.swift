//
//  CalendarServices.swift
//  Cru
//
//  Created by Deniz Tumer on 4/26/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarServices {}

extension CalendarServices {
    var calendarStore: EKEventStore {
        return EKEventStore()
    }
    
    //this function creates an EKEvent that can be stored in the native calendar
    func createCalendarEvent(event: Event) -> EKEvent {
        let calendarEvent: EKEvent = EKEvent(eventStore: self.calendarStore)
        
        calendarEvent.calendar = calendarStore.defaultCalendarForNewEvents
        
        if let _ = event.location {
            calendarEvent.location = event.getLocationString()
        }
        
        calendarEvent.title = event.name
        calendarEvent.startDate = event.startNSDate
        calendarEvent.endDate = event.endNSDate
        
        return calendarEvent
    }
}