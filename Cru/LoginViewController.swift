


import UIKit
import SwiftValidator
import MRProgress

class LoginViewController: UIViewController, ValidationDelegate {
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameError: UILabel!
    
    @IBOutlet weak var passwordError: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        usernameError.text = ""
        passwordError.text = ""
        
        validator.registerField(usernameField, errorLabel: usernameError, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, errorLabel: passwordError, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        let username = usernameField.text
        let password = passwordField.text
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        LoginUtils.login(username!, password: password!, completionHandler : {(response : NSDictionary) in
            
            var title = ""
            if (response["success"] as! Bool) {
                title = "Login Successful"
            } else {
                title = "Login Failed"
            }
            
            let success = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
            success.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true, completion: {
                
                
                self.presentViewController(success, animated: true, completion: nil)
            })
        })
    }
    
    func resetLabel(field: UITextField, error: UILabel){
        field.layer.borderColor = UIColor.clearColor().CGColor
        field.layer.borderWidth = 0.0
        error.text = ""
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        var userValid = true
        var pwdValid = true
        
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
            
            if(field == usernameField){
                userValid = false
            }
            if(field == passwordField){
                pwdValid = false
            }
        }
        
        if(userValid){
            resetLabel(usernameField, error: usernameError)
        }
        if(pwdValid){
            resetLabel(passwordField, error: passwordError)
        }
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        validator.validate(self)
    }
}
