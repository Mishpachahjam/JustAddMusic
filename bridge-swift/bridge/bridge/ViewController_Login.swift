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

class ViewController_Login: BaseViewController, UITextFieldDelegate {
    
    //var checkboxButtons: [CheckboxButton] = []
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Login", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Login", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Login", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Login", owner: self, options: nil)
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
                            self.authenticate_user_with_facebook_data(data: data)
                        }
                    })
                }
            })
        } else {
            print("user not logged in with facebook")
        }
    }
    func authenticate_user_with_facebook_data(data: NSDictionary) {
        let parameters = NSMutableDictionary()
        parameters.setValue(data, forKey: "facebook_data")
        parameters.setValue(FBSDKAccessToken.current().tokenString, forKey: "facebook_access_token")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.authenticate_with_facebook(parameters: parameters, onCompletion: { response in
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                if let auth_token = response["auth_token"] as? String {
                    print(auth_token)
                    if let user = response["user"] as? NSDictionary {
                        print(user)
                        self.app_delegate.me.id = user["id"] as! Int
                        self.app_delegate.me.auth_token = auth_token as String
                        
                        if let instructor_profile = user["instructor_profile"] as? NSDictionary, let facebook_account = user["facebook_account"] as? NSDictionary {
                            self.app_delegate.me.is_instructor = true
                            self.app_delegate.me.is_student = false
                            self.app_delegate.me.profile_id = instructor_profile["id"] as! Int
                            
                            self.app_delegate.me.facebook_picture_url = facebook_account["picture_url"] as! String
                            self.app_delegate.me.facebook_first_name = facebook_account["first_name"] as! String
                            self.app_delegate.me.facebook_last_name = facebook_account["last_name"] as! String
                            
                            self.app_delegate.save_login_data(data: instructor_profile)
                            
                            self.app_delegate.update_push_token_for_user()
                            
                            print(instructor_profile)
                            
                            let view_controller = ViewController_UserProfile()
                            view_controller.profile_data = instructor_profile
                            view_controller.facebook_data = facebook_account
                            
                            self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
                            
                        } else if let student_profile = user["student_profile"] as? NSDictionary, let facebook_account = user["facebook_account"] as? NSDictionary {
                            self.app_delegate.me.is_instructor = false
                            self.app_delegate.me.is_student = true
                            
                            self.app_delegate.me.profile_id = student_profile["id"] as! Int
                            
                            self.app_delegate.me.facebook_picture_url = facebook_account["picture_url"] as! String
                            self.app_delegate.me.facebook_first_name = facebook_account["first_name"] as! String
                            self.app_delegate.me.facebook_last_name = facebook_account["last_name"] as! String
                            
                            self.app_delegate.save_login_data(data: student_profile)
                            
                            self.app_delegate.update_push_token_for_user()
                            
                            print(student_profile)
                            
                            let view_controller = ViewController_UserProfile()
                            view_controller.profile_data = student_profile
                            view_controller.facebook_data = facebook_account
                            
                            //                            if let topViewController = UIApplication.topViewController() {
                            //                                topViewController.navigationController?.pushViewController(
                            //                                    view_controller,
                            //                                    animated: false
                            //                                )
                            //                            }
                            self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
                            
                            //                            self.navigationController?.pushViewController(view_controller, animated: false)
                            
                        }
                        else {
                            let facebook_data = user["facebook_account"] as! NSDictionary
                            self.show_account_type_selection(facebook_data: facebook_data)
                        }
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
        //        // TEXT FIELD
        //        self.stackView.addArrangedSubview(self.createLabel(text: "Email", size: 14))
        //        self.text_field_email = self.createTextField(placeholder: "Email")
        //        self.text_field_email.delegate = self
        //        self.text_field_email.keyboardType = .emailAddress
        //        self.text_field_email.keyboardAppearance = .dark
        //        self.text_field_email.inputAccessoryView = keyboardDoneButtonView
        //        self.stackView.addArrangedSubview(self.text_field_email)
        //
        //        // TEXT FIELD
        //        self.stackView.addArrangedSubview(self.createLabel(text: "Password", size: 14))
        //        self.text_field_password = self.createTextField(placeholder: "Password")
        //        self.text_field_password.delegate = self
        //        self.text_field_password.keyboardType = .asciiCapableNumberPad
        //        self.text_field_password.keyboardAppearance = .dark
        //        self.text_field_password.inputAccessoryView = keyboardDoneButtonView
        //        self.text_field_password.isSecureTextEntry = true
        //        self.stackView.addArrangedSubview(self.text_field_password)
        //
        //        self.addSpacer()
        //
        //        let button_login = self.createButton(caption: "Login")
        //        button_login.addTarget(self, action: #selector(self.action_login), for: UIControlEvents.touchUpInside)
        //        self.stackView.addArrangedSubview(button_login)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Welcome to Bridge!", size: 24))
        
        self.addSpacer()
        let button_facebook_login = self.createButton(caption: "Login with Facebook")
        button_facebook_login.addTarget(self, action: #selector(self.action_facebook_login), for: .touchUpInside)
        self.stackView.addArrangedSubview(button_facebook_login)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Don't have an account?", size: 14))
        
        let button_choose_register = self.createButton(caption: "Register")
        button_choose_register.addTarget(self, action: #selector(self.action_choose_register), for: .touchUpInside)
        self.stackView.addArrangedSubview(button_choose_register)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
        self.continueHandler =  {
            (data: NSDictionary) -> Void in
            
            print("Continue handler engaged")
        }
        
        self.text_field_email.text = "example@mail.net"
        self.text_field_password.text = "123123123"
    }
    
    @IBAction func action_login(sender: AnyObject) {
        print("action_login")
        
        if (self.text_field_email.text!.isEmpty) {
            let alert = UIAlertController(title: "Input Error", message: "Username field required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else if (self.text_field_password.text!.isEmpty) {
            let alert = UIAlertController(title: "Input Error", message: "Password field required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.text_field_email.text!, forKey: "email") //set all your values..
        parameters.setValue(self.text_field_password.text!, forKey: "password")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.authenticate(parameters: parameters) { response in
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
                        
                        self.app_delegate.show_account_type_selection(facebook_data: [:])
                    }
                }
            })
        }
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
    @objc func action_choose_register() {
        print("action_choose_register")
        
        let view_controller = ViewController_Register()
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.pushViewController(
                view_controller,
                animated: false
            )
        }
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
