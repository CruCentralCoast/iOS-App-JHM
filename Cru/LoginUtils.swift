

import Foundation
import Alamofire

class LoginUtils {
    class func login(username: String, password :String, completionHandler : (response : NSDictionary) -> Void) {
        let params = ["username":username, "password":password]
        let url = Config.serverUrl + "api/signin"
        Alamofire.request(.POST, url, parameters: params)
            .responseJSON { response in
                completionHandler(response: response.result.value as! NSDictionary)
            }
    }

    class func logout() {
        let url = Config.serverUrl + "api/signout"
        Alamofire.request(.POST, url, parameters: nil)
            .responseJSON { response in }
    }
}
