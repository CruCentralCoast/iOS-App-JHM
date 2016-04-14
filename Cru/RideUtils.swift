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
    
    static func getRidesNotDriving(gcmid: String, inserter : (NSDictionary) -> (),
        afterFunc : () -> ()){
            
        let url = Config.serverUrl + "api/" + DBCollection.Ride.name() + "/find"
        let gcmArray: [String] = [gcmid]
        let params: [String: AnyObject] =  ["gcm_id": ["$nin" : gcmArray]]
            
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON { response in

                if let JSON = response.result.value {
                    if let RIDES = JSON as? NSArray{
                        for ride in RIDES{
                            if let rideDict = ride as? NSDictionary{
                                inserter(rideDict)
                                afterFunc()
                            }
                        }
                    }
                }
        }
        
    }
    
    
    static func getPassengerById(id: String, inserter: (Passenger)->(), afterFunc: ()->Void){
        let url = Config.serverUrl + "api/" + DBCollection.Passenger.name() + "/" + id
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let DICT = JSON as? NSDictionary{
                        inserter(Passenger(dict:DICT))
                        afterFunc()
                    }
                }
        }
    }
    
    class func getMyRides(inserter: (NSDictionary) -> (), afterFunc: ()->Void) {
        
        //gets rides you are receiving
        let rideIds = getMyRideIds()
        if (rideIds.count > 0) {
            let requestUrl = Config.serverUrl + "api/" + DBCollection.Ride.name() + "/find"
            let params = ["_id": ["$in": rideIds]]
            
            GlobalUtils.printRequest(params)
            
            ServerUtils.sendHttpPostRequest(requestUrl, body: params, completionHandler : ServerUtils.insertResources(inserter, afterFunc: afterFunc))
        }
    }
    
    private class func getMyRideIds() -> [String] {
        let alsm = ArrayLocalStorageManager(key: Config.ridesOffering)
        var rideIds = alsm.getArray()
        
        let mlsm = MapLocalStorageManager(key: Config.ridesReceiving)
        rideIds += mlsm.getKeys()
        
        return rideIds
    }

    
    // TODO:handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int,
        location: NSDictionary, radius: Int, direction: String, handler: (Bool)->()) {
            let requestUrl = Config.serverUrl + "api/" + DBCollection.Ride.name();
            let body = ["event":eventId, "driverName":name, "driverNumber":phone, "seats":seats,
                "gcm_id": Config.gcmId(), "location":location, "radius":radius, "direction":direction]
            
            
            Alamofire.request(.POST, requestUrl, parameters: body)
                .responseJSON { response in
                    if let JSON = response.result.value {
                        if let dict = JSON as? NSDictionary {
                            if let rideId = dict["_id"] as? String {
                                saveRideOffering(rideId)
                                handler(true)
                            } else {
                                handler(false)
                            }
                        } else {
                            handler(false)
                        }
                    } else {
                        handler(false)
                    }
            }
    }
    
    private class func saveRideOffering(rideId: String) {
        let alsm = ArrayLocalStorageManager(key: Config.ridesOffering)
        alsm.addElement(rideId)
    }
    
    class func joinRide(name: String, phone: String, direction: String,  rideId: String, handler: (Bool)->Void){
        let gcmToken = Config.gcmId()
        
        let requestUrl = Config.serverUrl + "api/" + DBCollection.Passenger.name();
        let body = ["name": name, "phone": phone, "direction":direction, "gcm_id":gcmToken]
        
        Alamofire.request(.POST, requestUrl, parameters: body)
            .responseJSON { response in
                if let val = response.result.value {
                    if let jsonStruct = val as? NSDictionary {
                        GlobalUtils.printRequest(jsonStruct)
                        
                        let passengerId = jsonStruct["_id"] as! String
                        
                        addPassengerToRide(rideId, passengerId: passengerId, handler: handler)
                    } else {
                        handler(false)
                    }
                } else {
                    handler(false)
                }
        }
        
    }
    
    private class func addPassengerToRide(rideId: String, passengerId: String, handler : (Bool)->Void){
        let requestUrl = Config.serverUrl + "api/" + DBCollection.Ride.name()
            + "/" + rideId + "/" + DBCollection.Passenger.name()
        let body = ["passenger_id": passengerId]
        Alamofire.request(.POST, requestUrl, parameters: body)
            .responseJSON { response in
                if (response.result.isSuccess && response.result.value != nil) {
                    handler(true)
                    saveRideReceiving(rideId, passengerId: passengerId)
                } else {
                    handler(false)
                }
        }
    }
    
    private class func saveRideReceiving(rideId: String, passengerId: String) {
        let mlsm = MapLocalStorageManager(key: Config.ridesReceiving)
        mlsm.addElement(rideId, elem: passengerId)
    }
    
    static func leaveRidePassenger(ride: Ride, handler: (Bool)->()){
        
        
        let mlsm = MapLocalStorageManager(key: Config.ridesReceiving)
        let rideId = ride.id
        let passId = mlsm.getElement(rideId) as! String
        mlsm.removeElement(rideId)
        let passengerStr =  "/" + DBCollection.Passenger.name() + "/" + passId
        let url = Config.serverUrl + "api/" + DBCollection.Ride.name() + "/" + rideId + passengerStr
        Alamofire.request(.DELETE, url)
            .responseJSON { response in
                handler(response.result.isSuccess)
        }
    }
    
    static func leaveRideDriver(rideid: String, handler: (Bool)->()){
        let url = Config.serverUrl + "api/" + DBCollection.Ride.name() + "/" + rideid
        
        Alamofire.request(.DELETE, url)
            .responseJSON { response in
                if (response.result.isSuccess) {
                    let alsm = ArrayLocalStorageManager(key: Config.ridesOffering)
                    alsm.removeElement(rideid)
                }
                handler(response.result.isSuccess)
        }
    }
    
    static func getPassengersByIds(ids : [String], inserter : (Passenger) -> (), afterFunc: ()->Void){
        
        if (ids.count > 0) {
            let params = ["_id":["$in":ids]]
            let url = Config.serverUrl + "api/" + DBCollection.Passenger.name() + "/find"
            print(params)
            Alamofire.request(.POST, url, parameters: params)
                .responseJSON { response in
                    if let json = response.result.value {
                        if let passengers = json as? [NSDictionary] {
                            for pass in passengers {
                                inserter(Passenger(dict: pass))
                            }
                            afterFunc()
                        }
                    }
            }
        }
        
    }
    
}