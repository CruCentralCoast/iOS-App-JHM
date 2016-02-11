//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class ServerUtils {
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> (),
        afterFunc : () -> ()) {
        ServerClient.displayListInfo(collectionName, completionHandler: curryDisplayResources(inserter, afterFunc: afterFunc))
    }
    
    class func getRidesByGCMToken(token: String, inserter: (NSDictionary) -> ()) {
        
        //gets rides you are receiving
        var requestUrl = Config.serverUrl + "api/passenger/find"
        var params = ["gcm_id": token]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
                do {
                    if (data != nil) {
                        let rideRequestUrl = Config.serverUrl + "api/ride/find"
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        let passengerList = jsonResponse as! NSArray
                        var rideIds = [String]()
                        
                        for passenger in passengerList{
                            rideIds.append(passenger["_id"] as! String)
                        }
                        
                        print("\(rideIds)")
        
                        let inQuery = ["$in": rideIds]
                        let query = ["passengers": inQuery]
                        
                        let body = try NSJSONSerialization.dataWithJSONObject(query, options: NSJSONWritingOptions.PrettyPrinted)
                        let string1 = NSString(data: body, encoding: NSUTF8StringEncoding)
                        print(string1)
                        
                        
                        //print("\(body)")
                        
                        ServerClient.sendHttpPostRequest(rideRequestUrl, body: body, completionHandler : curryDisplayResources(inserter, afterFunc: {() in }))
                        
                    }
                    else {
                        // TODO: display message for user
                        print("Failed to get stuff from database")
                    }
                }
                catch {
                    print("Something went wrong with http request...")
                }})
        }
        catch {
            print("Error getting ride for GCM token!")
        }
        
        
        
        //gets rides you are giving
        requestUrl = Config.serverUrl + "api/ride/find"
        params = ["gcm_id": token]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : curryDisplayResources(inserter, afterFunc: {() in }))
        }
        catch {
            print("Error getting ride for GCM token!")
        }
    }
    
    
    class func curryDisplayResources(inserter : (NSDictionary) -> (), afterFunc : () -> ()) -> (NSData?, NSURLResponse?, NSError?)-> () {
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    let jsonList = jsonResponse as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        for sm in jsonList {
                            if let dict = sm as? [String: AnyObject]{
                                inserter(dict)
                            }
                        }
                        afterFunc()
                    })
                } else {
                    // TODO: display message for user
                    print("Failed to get stuff from database")
                }
            } catch {
                print("Something went wrong with http request...")
            }
        }
    }
    
    class func dateFromString(dateStr : String) -> NSDateComponents? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(dateStr)
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
    }
    
    // TODO: add real gcm_id, location, time, radius, direction and handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int) {
        
        let gcmToken = SubscriptionManager.loadGCMToken()
        
        let requestUrl = Config.serverUrl + "api/ride/create";
        let params = ["event":eventId, "driverName":name, "driverNumber":phone,
            "seats":seats, "gcm_id": gcmToken]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerClient.blankCompletionHandler);
        } catch {
            print("Error sending ride offer!")
        }
    }
    
    class func joinRide(name: String, phone: String, direction: String,  rideId: String){
        createPassenger(name, phone: phone, direction: direction, handler: {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    let jsonStruct = jsonResponse as! NSDictionary
                    
                    let post = jsonStruct["post"] as! NSDictionary
                    
                    let passengerId = post["_id"] as! String
                
                    addPassengerToRide(rideId, passengerId: passengerId)
                    
                }
                else {
                    // TODO: display message for user
                    print("Failed to get stuff from database")
                }
            }
            catch {
                print("Something went wrong with http request...")
            }
        })
    }
    
    
    
    
    class func createPassenger(name: String, phone: String, direction: String, handler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let gcmToken = SubscriptionManager.loadGCMToken()
        
        let requestUrl = Config.serverUrl + "api/passenger/create";
        let params = ["name": name, "phone": phone, "direction":direction, "gcm_id":gcmToken]
        
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : handler)
        } catch {
            print("Error sending ride offer!")
        }
    }
    
    
    
    class func addPassengerToRide(rideId: String, passengerId: String){
        let requestUrl = Config.serverUrl + "api/ride/addPassenger";
        let params = ["ride_id": rideId,"passenger_id": passengerId]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerClient.blankCompletionHandler);
        } catch {
            print("Error sending ride offer!")
        }
    }
}