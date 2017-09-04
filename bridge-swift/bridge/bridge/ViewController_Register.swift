//
//  RunCampaignViewController
//  Three DS SDK
//
//  Created by Konstantin Yurchenko on 7/18/16.
//  Copyright © 2016 Play Entertainment. All rights reserved.
//

import Foundation
import UIKit

import FacebookLogin
import FacebookCore

import FBSDKCoreKit

class ViewController_Register: BaseViewController, UITextFieldDelegate {
    
    //var checkboxButtons: [CheckboxButton] = []

    @IBOutlet weak var view_header: UIView!
        
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
        
    // UI ELEMENTS
    var scrollView: UIScrollView!

    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Register", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Register", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Register", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Register", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(scrollView)
        
        self.stackView = UIStackView()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = UILayoutConstraintAxis.vertical
        self.stackView.distribution = UIStackViewDistribution.equalSpacing
        self.stackView.alignment = UIStackViewAlignment.center
        self.stackView.spacing = 10
        
        self.assembleInterface()
        
        self.scrollView.addSubview(self.stackView)
        self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        self.scrollView.bounces = false
        
        self.view_header.backgroundColor = PANTONE_greenery
    }
    // MARK: FACEBOOK
    
    func get_facebook_user_info() {
        if(FBSDKAccessToken.current() != nil) {
            print(FBSDKAccessToken.current().permissions)
            print("user logged in with facebook")
            self.app_delegate.show_activity_view_controller(message: "Loading...")

            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large), age_range, link, gender, locale, timezone, updated_time, verified"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result!)
                    

                    
                    print("Token: \((FBSDKAccessToken.current().tokenString)!)")
                    print("Token Expiration Date: \((FBSDKAccessToken.current().expirationDate)!)")
                    DispatchQueue.main.async(execute: {
                        self.app_delegate.remove_activity_view_controller()
                        
                        if let data = result as? NSDictionary {
                            self.create_user_account_with_facebook_data(data: data)
                        }
                    })
                }
            })
        } else {
            print("user not logged in with facebook")
        }
    }
    
    func create_user_account_with_facebook_data(data: NSDictionary) {
        let parameters = NSMutableDictionary()
        parameters.setValue(data, forKey: "facebook_data")
        parameters.setValue(FBSDKAccessToken.current().tokenString, forKey: "facebook_access_token")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.create_user(parameters: parameters, onCompletion: { response in
            //            print(response["auth_token"] as! String)
            
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
//                self.show_success_alert()
//                self.close()
                
                if let auth_token = response["auth_token"] as? String {
                    print(auth_token)
                    if let user = response["user"] as? NSDictionary {
                        print(user)
                        self.app_delegate.me.id = user["id"] as! Int
                        self.app_delegate.me.auth_token = auth_token as String
                        
                        let facebook_data = user["facebook_account"] as! NSDictionary
                        
                        self.app_delegate.update_push_token_for_user()
                        self.show_account_type_selection(facebook_data: facebook_data)
                    }
                }
            })
        })
    }
    
    func show_account_type_selection(facebook_data: NSDictionary) {
        self.app_delegate.remove_activity_view_controller()
        
        let view_controller = ViewController_AccountTypeSelection()
        view_controller.facebook_data = facebook_data
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.pushViewController(
                view_controller,
                animated: false
            )
        }
    }
    
    // MARK: FACEBOOK
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    var text_field_email = UITextField()
    var text_field_password = UITextField()
    var text_field_repeat_password = UITextField()

    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        
//        self.addSpacer()
//        self.stackView.addArrangedSubview(self.createLabel(text: "Email", size: 14))
//
//        // TEXT FIELD
//        self.text_field_email = self.createTextField(placeholder: "Email")
//        self.text_field_email.delegate = self
//        self.text_field_email.keyboardType = .emailAddress
//        self.text_field_email.keyboardAppearance = .dark
//        self.text_field_email.inputAccessoryView = keyboardDoneButtonView
//        self.stackView.addArrangedSubview(self.text_field_email)
//        
//        self.stackView.addArrangedSubview(self.createLabel(text: "Password", size: 14))
//        
//        // TEXT FIELD
//        self.text_field_password = self.createTextField(placeholder: "Password")
//        self.text_field_password.delegate = self
//        self.text_field_password.keyboardType = .asciiCapableNumberPad
//        self.text_field_password.keyboardAppearance = .dark
//        self.text_field_password.inputAccessoryView = keyboardDoneButtonView
//        self.text_field_password.isSecureTextEntry = true
//        self.stackView.addArrangedSubview(self.text_field_password)
//        
//        // TEXT FIELD
//        self.stackView.addArrangedSubview(self.createLabel(text: "Repeat Password", size: 14))
//        self.text_field_repeat_password = self.createTextField(placeholder: "Repeat Password")
//        self.text_field_repeat_password.delegate = self
//        self.text_field_repeat_password.keyboardType = .asciiCapableNumberPad
//        self.text_field_repeat_password.keyboardAppearance = .dark
//        self.text_field_repeat_password.inputAccessoryView = keyboardDoneButtonView
//        self.text_field_repeat_password.isSecureTextEntry = true
//        self.stackView.addArrangedSubview(self.text_field_repeat_password)
//        
//        self.addSpacer()
//        
//        let button_register = self.createButton(caption: "Register")
//        button_register.addTarget(self, action: #selector(self.action_register), for: UIControlEvents.touchUpInside)
//        self.stackView.addArrangedSubview(button_register)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Welcome to Bridge!", size: 24))
        
        self.addSpacer()
        let button_facebook_register = self.createButton(caption: "Register with Facebook")
        button_facebook_register.addTarget(self, action: #selector(self.action_facebook_login), for: .touchUpInside)
        self.stackView.addArrangedSubview(button_facebook_register)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Already have an account?", size: 14))
        
        let button_choose_login = self.createButton(caption: "Login")
        button_choose_login.addTarget(self, action: #selector(self.action_choose_login), for: .touchUpInside)
        self.stackView.addArrangedSubview(button_choose_login)
        
//        let button_random_user = self.createButton(caption: "Random User")
//        button_random_user.addTarget(self, action: #selector(self.action_random_user), for: .touchUpInside)
//        self.stackView.addArrangedSubview(button_random_user)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
//        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
        self.continueHandler =  {
            (data: NSDictionary) -> Void in
            
            print("Continue handler engaged")
        }
        
        self.text_field_email.text = "example@mail.com"
        self.text_field_password.text = "123123123"
    }
    
    @IBAction func action_register(sender: AnyObject) {
        print("action_register")
        
        var error = false
        
        if (self.text_field_email.text!.isEmpty) {
            error = true
            let alert = UIAlertController(title: "Input Error", message: "Username field required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else if (self.text_field_password.text!.isEmpty) {
            error = true
            let alert = UIAlertController(title: "Input Error", message: "Password field required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else if (self.text_field_repeat_password.text!.isEmpty) {
            error = true
            let alert = UIAlertController(title: "Input Error", message: "Repeat password field required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else if (self.text_field_password.text! != self.text_field_repeat_password.text!) {
            error = true
        }
        
        if !error {
            let parameters = NSMutableDictionary()
            parameters.setValue(self.text_field_email.text!, forKey: "email") //set all your values..
            parameters.setValue(self.text_field_password.text!, forKey: "password")
            parameters.setValue(false, forKey: "has_facebook_data")
            
            self.app_delegate.show_activity_view_controller(message: "Loading...")
            
            RestAPIClient.sharedInstance.create_user(parameters: parameters, onCompletion: { response in
    //            print(response["auth_token"] as! String)

                print(response)
                
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    self.show_success_alert()
                    self.close()
                })
            })
        }
        
//        RestAPIClient.sharedInstance.authenticate(parameters: parameters) { response in
//            print(response["auth_token"] as! String)
//            
//            DispatchQueue.main.async(execute: {
//                self.app_delegate.remove_activity_view_controller()
//                self.show_success_alert()
//                self.close()
//            })
//            
//            //            if let error_code = response["error_code"] {
//            //                if error_code as! Int == 0 {
//            //                    DispatchQueue.main.async(execute: {
//            ////                        self.app_delegate.remove_activity_view_controller()
//            ////                        self.show_success_alert()
//            ////                        self.close()
//            //                    })
//            //                } else {
//            ////                    print ("error")
//            ////                    self.show_failure_alert(message: "Can't add campaign")
//            //                }
//            //            }
//        }
    }
    @objc func action_facebook_login() {
        let loginManager = LoginManager()
        self.app_delegate.show_activity_view_controller(message: "Loading...")

        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken)
                
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    self.get_facebook_user_info()
                })
            }
        }
    }
    @objc func action_choose_login() {
        print("action_choose_login")
        
        let view_controller = ViewController_Login()
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.pushViewController(
                view_controller,
                animated: false
            )
        }
    }
    @objc func action_random_user() {
        print("action_random_user")
        
        self.update_ui()
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in (0 ..< len){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    func update_ui() {
        print("update_ui")
        
        if (self.app_delegate.is_debug_mode_on) {
            let random_string = randomStringWithLength(len: 5)
            self.text_field_password.text = "aaaaaa"
            self.text_field_repeat_password.text = "aaaaaa"
            self.text_field_email.text = "\(random_string)@gmail.com"
        } else {
            self.text_field_password.text = ""
            self.text_field_repeat_password.text = ""
            self.text_field_email.text = ""
        }
        
        self.app_delegate.is_debug_mode_on = !self.app_delegate.is_debug_mode_on
    }
    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //Error
    internal func flashError(message: String) {
//        self.labelContainingErrorMessage.text = message
    }
}
