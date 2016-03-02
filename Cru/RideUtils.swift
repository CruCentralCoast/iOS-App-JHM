//
//  RideUtils.swift
//  Cru
//
//  Created by Peter Godkin on 2/18/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation
import Alamofire

class RideUtils {
    
    static func getPassengerById(id: String, inserter: (Passenger)->()){
        let url = Config.serverUrl + "api/passenger/" + id
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let DICT = JSON as? NSDictionary{
                        inserter(Passenger(dict:DICT))
                    }
                }
        }
    }
    
    class func getRidesByGCMToken(token: String, inserter: (NSDictionary) -> (), afterFunc: ()->Void) {
        
        //gets rides you are receiving
        var requestUrl = Config.serverUrl + "api/passenger/find"
        let params = ["gcm_id": token]

        Alamofire.request(.POST, requestUrl, parameters: params).responseJSON { response in
            let rideRequestUrl = Config.serverUrl + "api/ride/search"

            let passengerList = response.result.value as! NSArray
            var rideIds = [String]()
            
            for passenger in passengerList{
                rideIds.append(passenger["_id"] as! String)
            }
            
            //print("\(rideIds)")
            
            let cond = ["passengers": ["$in": rideIds]]
            let body = ["conditions": cond, "projection": "", "options": [:]]
            
            ServerUtils.sendHttpPostRequest(rideRequestUrl, body: body, completionHandler : ServerUtils.insertResources(inserter, afterFunc: afterFunc))
        }
        
        
        //gets rides you are giving
        requestUrl = Config.serverUrl + "api/ride/find"
        let body = ["gcm_id": token]
        
        ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerUtils.insertResources(inserter, afterFunc: {() in }))
    }

    
    // TODO:handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int,
        location: NSDictionary, radius: Int, direction: String) {
            
            var gcmToken = SubscriptionManager.loadGCMToken()
            
            if gcmToken == "" {
                gcmToken = Config.emulatorGcmId
            }
            
            let requestUrl = Config.serverUrl + "api/ride/create";
            let body = ["event":eventId, "driverName":name, "driverNumber":phone, "seats":seats,
                "gcm_id": gcmToken, "location":location, "radius":radius, "direction":direction]

            ServerUtils.sendHttpPostRequest(requestUrl, body: body);
    }
    
    class func joinRide(name: String, phone: String, direction: String,  rideId: String, handler: ()->Void){
        createPassenger(name, phone: phone, direction: direction, handler: {(response : AnyObject) in
            let jsonStruct = response as! NSDictionary
            
            let post = jsonStruct["post"] as! NSDictionary
            
            let passengerId = post["_id"] as! String
            
            addPassengerToRide(rideId, passengerId: passengerId)
            handler()
        })
    }
    
    
    
    
    private class func createPassenger(name: String, phone: String, direction: String, handler: (AnyObject) -> Void){
        let gcmToken = Config.emulatorGcmId
        
        let requestUrl = Config.serverUrl + "api/passenger/create";
        let body = ["name": name, "phone": phone, "direction":direction, "gcm_id":gcmToken]
        
        ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : handler)
    }
    
    
    
    private class func addPassengerToRide(rideId: String, passengerId: String){
        let requestUrl = Config.serverUrl + "api/ride/addPassenger";
        let body = ["ride_id": rideId,"passenger_id": passengerId]
        ServerUtils.sendHttpPostRequest(requestUrl, body: body);
    }
    
}