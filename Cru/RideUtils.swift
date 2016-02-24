//
//  RideUtils.swift
//  Cru
//
//  Created by Peter Godkin on 2/18/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class RideUtils {
    
    class func getRidesByGCMToken(token: String, inserter: (NSDictionary) -> (), afterFunc: ()->Void) {
        
        //gets rides you are receiving
        var requestUrl = Config.serverUrl + "api/passenger/find"
        var params = ["gcm_id": token]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
                do {
                    if (data != nil) {
                        let rideRequestUrl = Config.serverUrl + "api/ride/find"
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        let passengerList = jsonResponse as! NSArray
                        var rideIds = [String]()
                        
                        for passenger in passengerList{
                            rideIds.append(passenger["_id"] as! String)
                        }
                        
                        //print("\(rideIds)")
                        
                        let inQuery = ["$in": rideIds]
                        let query = ["passengers": inQuery]
                        
                        let body = try NSJSONSerialization.dataWithJSONObject(query, options: NSJSONWritingOptions.PrettyPrinted)
                        
                        //let string1 = NSString(data: body, encoding: NSUTF8StringEncoding)
                        //print(string1)
                        //print("\(body)")
                        
                        ServerUtils.sendHttpPostRequest(rideRequestUrl, body: body, completionHandler : ServerUtils.curryDisplayResources(inserter, afterFunc: afterFunc))
                        
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
            ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerUtils.curryDisplayResources(inserter, afterFunc: {() in }))
        }
        catch {
            print("Error getting ride for GCM token!")
        }
    }

    
    // TODO:handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int,
        location: NSDictionary, radius: Int, direction: String) {
            
            var gcmToken = SubscriptionManager.loadGCMToken()
            
            if gcmToken == "" {
                gcmToken = "emulator-id-hey-whats-up-hello"
            }
            
            let requestUrl = Config.serverUrl + "api/ride/create";
            let params = ["event":eventId, "driverName":name, "driverNumber":phone, "seats":seats,
                "gcm_id": gcmToken, "location":location, "radius":radius, "direction":direction]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerUtils.blankCompletionHandler);
            } catch {
                print("Error sending ride offer!")
            }
    }
    
    class func joinRide(name: String, phone: String, direction: String,  rideId: String, handler: ()->Void){
        createPassenger(name, phone: phone, direction: direction, handler: {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    let jsonStruct = jsonResponse as! NSDictionary
                    
                    let post = jsonStruct["post"] as! NSDictionary
                    
                    let passengerId = post["_id"] as! String
                    
                    addPassengerToRide(rideId, passengerId: passengerId)
                    handler()
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
    
    
    
    
    private class func createPassenger(name: String, phone: String, direction: String, handler: (NSData?, NSURLResponse?, NSError?) -> Void){
        let gcmToken = "kH-biM4oppg:APA91bF1PlmRURQSi1UWB49ZRUIB0G2vfsyHcAqqOxX5WG5RdsZQnezCyPT4GPbJ9yQPYxDFTVMGpHbygnrEf9UrcEZITCfE6MCLQJwAr7p0sRklVp8vwjZAjvVSOdEIkLPydiJ_twtL"//SubscriptionManager.loadGCMToken()
        
        let requestUrl = Config.serverUrl + "api/passenger/create";
        let params = ["name": name, "phone": phone, "direction":direction, "gcm_id":gcmToken]
        
        
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : handler)
        } catch {
            print("Error sending ride offer!")
        }
    }
    
    
    
    private class func addPassengerToRide(rideId: String, passengerId: String){
        let requestUrl = Config.serverUrl + "api/ride/addPassenger";
        let params = ["ride_id": rideId,"passenger_id": passengerId]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            
            //            let sexybody = NSString(data: body, encoding: NSUTF8StringEncoding)
            //            print(sexybody)
            
            ServerUtils.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerUtils.blankCompletionHandler);
        } catch {
            print("Error sending ride offer!")
        }
    }
    
}