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
            
        let url = Config.serverUrl + "api/ride/find"
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
        let url = Config.serverUrl + "api/passenger/" + id
        
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
    
    class func getRidesByGCMToken(token: String, inserter: (NSDictionary) -> (), afterFunc: ()->Void) {
        
        //gets rides you are receiving
        var requestUrl = Config.serverUrl + "api/passenger/find"
        let params = ["gcm_id": token]
        
        do {
            let something = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            let string1 = NSString(data: something, encoding: NSUTF8StringEncoding)
            print(string1)
        } catch {
            print("Error writing json body")
        }

        Alamofire.request(.POST, requestUrl, parameters: params).responseJSON { response in
            let rideRequestUrl = Config.serverUrl + "api/ride/search"

            let passengerList = response.result.value as! NSArray
            var rideIds = [String]()
            
            for passenger in passengerList{
                rideIds.append(passenger["_id"] as! String)
            }
                        
            let cond = ["passengers": ["$in": rideIds]]
            //let body : [String : AnyObject] = ["conditions": cond, "projection": "", "options": [:]]
            
            
            
            do {
                let something = try NSJSONSerialization.dataWithJSONObject(cond, options: NSJSONWritingOptions.PrettyPrinted)
                let string1 = NSString(data: something, encoding: NSUTF8StringEncoding)
                print(string1)
            } catch {
                print("Error writing json body")
            }
            
            if (rideIds.count > 0) {
                ServerUtils.sendHttpPostRequest(rideRequestUrl, body: cond, completionHandler : ServerUtils.insertResources(inserter, afterFunc: afterFunc))
            } else {
                afterFunc()
            }
        }
        
        
        //gets rides you are giving
        requestUrl = Config.serverUrl + "api/ride/find"
        let body : [String : AnyObject] = ["gcm_id": token]
        
        ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerUtils.insertResources(inserter, afterFunc: {() in }))
    }

    
    // TODO:handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int,
        location: NSDictionary, radius: Int, direction: String, handler: (Bool)->(), idhandler: (String)->()) {
            let requestUrl = Config.serverUrl + "api/ride/create";
            let body = ["event":eventId, "driverName":name, "driverNumber":phone, "seats":seats,
                "gcm_id": Config.gcmId(), "location":location, "radius":radius, "direction":direction]
            
            
            Alamofire.request(.POST, requestUrl, parameters: body)
                .responseJSON { response in
                    if let JSON = response.result.value {
                        if let dict = JSON as? NSDictionary {
                            if let postDict = dict["post"] as? NSDictionary{
                                if let rideid = postDict["_id"] as? String {
                                    idhandler(rideid)
                                }
                            }
                        }
                    }
                    handler(response.result.isSuccess)
            }
    }
    
    class func joinRide(name: String, phone: String, direction: String,  rideId: String, handler: (AnyObject)->Void, passIdHandler: (String)->()){
        createPassenger(name, phone: phone, direction: direction, handler: {(response : AnyObject) in
            let jsonStruct = response as! NSDictionary
            
            let post = jsonStruct["post"] as! NSDictionary
            
            let passengerId = post["_id"] as! String
            passIdHandler(passengerId)
            
            addPassengerToRide(rideId, passengerId: passengerId, handler: handler)
        })
    }
    
    
    
    
    private class func createPassenger(name: String, phone: String, direction: String, handler: (AnyObject) -> Void){
        let gcmToken = Config.gcmId()
        
        let requestUrl = Config.serverUrl + "api/passenger/create";
        let body = ["name": name, "phone": phone, "direction":direction, "gcm_id":gcmToken]
        
        ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : handler)
    }
    
    
    
    private class func addPassengerToRide(rideId: String, passengerId: String, handler : (AnyObject)->Void){
        let requestUrl = Config.serverUrl + "api/ride/addPassenger"
        let body = ["ride_id": rideId,"passenger_id": passengerId]
        ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler: handler)
    }
    
    static func leaveRide(passid: String, rideid: String, handler: (Bool)->()){
        let url = Config.serverUrl + "api/ride/dropPassenger"
        let params = ["passenger_id":passid, "ride_id":rideid]
        
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON { response in
                handler(response.result.isSuccess)
        }
    }
    
    
    static func findIdByGCMInRide(gcm: String, ride: Ride, handler: (String, String)->()){
        
        for pass in ride.passengers{
            let url = Config.serverUrl + "api/passenger/" + pass
            Alamofire.request(.GET, url, parameters: nil)
                .responseJSON { response in
                    if let JSON = response.result.value {
                        if let DICT = JSON as? NSDictionary{
                            if let theirGCM = DICT["gcm_id"] as? String{
                                if(gcm ==  theirGCM){
                                    if let passid = DICT["_id"] as? String{
                                        handler(passid, ride.id)
                                    }
                                }
                            }
                            
                        }
                    }
            }
        }
        
    }
    
    static func leaveRideDriver(rideid: String, handler: (Bool)->()){
        let params = ["ride_id":rideid]
        let url = Config.serverUrl + "api/ride/dropRide"
        
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON { response in
                handler(response.result.isSuccess)
        }
    }
    
    static func getPassengersByIds(ids : [String], inserter : (Passenger) -> (), afterFunc: ()->Void){
        
//        let params = ["$in":rideid]
//        let url = Config.serverUrl + "api/passenger/find"
//        
//        Alamofire.request(.POST, url, parameters: params)
//            .responseJSON { response in
//                if(response.result.isSuccess){
//                    handler(true)
//                }
//                else{
//                    handler(false)
//                }
//        }
        
        var count = 1
        for pass in ids{
            if(count == ids.count){
                RideUtils.getPassengerById(pass, inserter: inserter, afterFunc: afterFunc)
            }
            else{
                RideUtils.getPassengerById(pass, inserter: inserter, afterFunc: {() in})
            }
            count += 1
        }
        
    }
    
}