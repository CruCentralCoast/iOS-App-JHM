//
//  File.swift
//  Cru
//
//  Created by Peter Godkin on 4/24/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class CruClients {
    
    static var serverClient: ServerProtocol!
    static var rideUtils: RideUtils!
    static var eventUtils: EventUtils!
    
    static func getServerClient() -> ServerProtocol {
        if (serverClient == nil) {
            serverClient = KeystoneClient()
        }
        return serverClient
    }
    
    static func getRideUtils() -> RideUtils {
        if (rideUtils == nil) {
            rideUtils = RideUtils()
        }
        return rideUtils
    }
    
    static func getEventUtils() -> EventUtils {
        if (eventUtils == nil) {
            eventUtils = EventUtils()
        }
        return eventUtils
    }
}
