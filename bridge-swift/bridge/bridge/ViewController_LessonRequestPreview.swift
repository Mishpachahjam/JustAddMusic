//
//  ViewController_LessonRequestPreview.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/4/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

class ViewController_LessonRequestPreview: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!

    var lesson_request: NSDictionary = [:]
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestPreview", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestPreview", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestPreview", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_LessonRequestPreview", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_header.backgroundColor = PANTONE_greenery
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if (self.scrollView != nil) {
            self.scrollView.removeFromSuperview()
        }
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(self.scrollView)
        
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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        if (self.app_delegate.me.is_instructor) {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Lesson Request", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: "id: \(self.lesson_request["id"] as! Int)", size: 14))
            
            let is_open = self.lesson_request["is_open"] as! Bool
            self.stackView.addArrangedSubview(self.createLabel(text: "is_open?: \(is_open)", size: 14))
            
            let is_approved = self.lesson_request["is_approved"] as! Bool
            let is_denied = self.lesson_request["is_denied"] as! Bool
            
            self.stackView.addArrangedSubview(self.createLabel(text: "is_approved?: \(is_approved)", size: 14))
            self.stackView.addArrangedSubview(self.createLabel(text: "is_denied?: \(is_denied)", size: 14))
            
            let student_id = self.lesson_request["student_id"] as! Int
            
            self.stackView.addArrangedSubview(self.createLabel(text: "student_id: \(student_id)", size: 14))
            
            let starts_at_string = self.lesson_request["starts_at"] as! String
            let starts_at = Date().dateFromISO8601String(dateString: starts_at_string)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timestamp = dateFormatter.string(from: starts_at)
            
            self.stackView.addArrangedSubview(self.createLabel(text: "starts_at: \(timestamp)", size: 14))
            
            let lesson_description = self.lesson_request["lesson_description"] as! String
            self.stackView.addArrangedSubview(self.createLabel(text: "Request Description: \(lesson_description)", size: 14))
            
            let lesson_bounty = self.lesson_request["lesson_bounty"] as! String
            self.stackView.addArrangedSubview(self.createLabel(text: "Bounty: \(lesson_bounty)", size: 14))
            
            self.addSpacer()
            
            if is_open {
                let button_approve_lesson_request = self.createButton(caption: "Approve")
                button_approve_lesson_request.addTarget(self, action: #selector(self.action_approve_lesson_request), for: UIControlEvents.touchUpInside)
                self.stackView.addArrangedSubview(button_approve_lesson_request)
                
                let button_decline_lesson_request = self.createButton(caption: "Decline")
                button_decline_lesson_request.addTarget(self, action: #selector(self.action_decline_lesson_request), for: UIControlEvents.touchUpInside)
                self.stackView.addArrangedSubview(button_decline_lesson_request)
            }
            
            let button_show_student_profile = self.createButton(caption: "Show Student Profile")
            button_show_student_profile.addTarget(self, action: #selector(self.action_show_student_profile), for: UIControlEvents.touchUpInside)
            self.stackView.addArrangedSubview(button_show_student_profile)
            
        }
        else if (self.app_delegate.me.is_student) {
            self.addSpacer()
            
            let instructor_id = self.lesson_request["instructor_id"] as! Int
            

            self.stackView.addArrangedSubview(self.createLabel(text: "Lesson Request", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: "id: \(self.lesson_request["id"] as! Int)", size: 14))
            self.stackView.addArrangedSubview(self.createLabel(text: "is_open?: \(self.lesson_request["is_open"] as! Bool)", size: 14))
         
            
            let is_approved = self.lesson_request["is_approved"] as! Bool
            let is_denied = self.lesson_request["is_denied"] as! Bool
            
            self.stackView.addArrangedSubview(self.createLabel(text: "is_approved?: \(is_approved)", size: 14))
            self.stackView.addArrangedSubview(self.createLabel(text: "is_denied?: \(is_denied)", size: 14))
            
            let starts_at_string = self.lesson_request["starts_at"] as! String
            let starts_at = Date().dateFromISO8601String(dateString: starts_at_string)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timestamp = dateFormatter.string(from: starts_at)
            
            self.stackView.addArrangedSubview(self.createLabel(text: "starts_at: \(timestamp)", size: 14))

            self.stackView.addArrangedSubview(self.createLabel(text: "instructor_id: \(instructor_id)", size: 14))
            
            self.addSpacer()

            let button_show_instructor_profile = self.createButton(caption: "Show Instructor Profile")
            button_show_instructor_profile.addTarget(self, action: #selector(self.action_show_instructor_profile), for: UIControlEvents.touchUpInside)
            self.stackView.addArrangedSubview(button_show_instructor_profile)
        }

        self.addSpacer()
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
        self.continueHandler =  {
            (data: NSDictionary) -> Void in
            
            print("Continue handler engaged")
        }
    }
    
    /// MARK: Profile methods
    @objc func action_show_student_profile() {
        print("action_show_student_profile")
        
        let student = self.lesson_request["student"] as! NSDictionary
        let student_profile = student["student_profile"] as! NSDictionary
        let student_profile_id = student_profile["id"] as! Int
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(student_profile_id, forKey: "profile_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.retrieve_student_info(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_UserProfile()
                
                let profile = response["profile"] as! NSDictionary
                view_controller.profile_data = profile
                view_controller.facebook_data = profile["facebook_account"] as! NSDictionary
                view_controller.lesson_requests = response["lesson_requests"] as! [Any]
                
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_show_instructor_profile() {
        print("action_show_instructor_profile")
        
//        let instructor_id = self.lesson_request["instructor_id"] as! Int
        let instructor = self.lesson_request["instructor"] as! NSDictionary
        let instructor_profile = instructor["instructor_profile"] as! NSDictionary
        let instructor_profile_id = instructor_profile["id"] as! Int
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(instructor_profile_id, forKey: "profile_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.retrieve_instructor_info(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_UserProfile()

                let profile = response["profile"] as! NSDictionary
                view_controller.profile_data = profile
                view_controller.facebook_data = profile["facebook_account"] as! NSDictionary
                view_controller.lesson_requests = response["lesson_requests"] as! [Any]
                
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    /// MARK: Profile methods
    
    @objc func action_approve_lesson_request() {
        print("action_approve_lesson_request")
        
        let alert = UIAlertController(title: "Approve lesson request", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print("approve")
            self.approve_lesson_request()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    @objc func action_decline_lesson_request() {
        print("action_decline_lesson_request")
        
        let alert = UIAlertController(title: "Decline lesson request", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print("decline")
            self.decline_lesson_request()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    @objc func approve_lesson_request() {
        let parameters = NSMutableDictionary()

        parameters.setValue(self.lesson_request["id"] as! Int, forKey: "lesson_request_id")
        parameters.setValue(self.lesson_request["student_id"] as! Int, forKey: "student_id")
        parameters.setValue(self.lesson_request["instructor_id"] as! Int, forKey: "instructor_id")
//        parameters.setValue(false, forKey: "is_open")

        self.app_delegate.show_activity_view_controller(message: "Loading...")

        RestAPIClient.sharedInstance.approve_lesson_request(parameters: parameters) { response in
            print(response)

            DispatchQueue.main.async(execute: {
                let lesson_request = response
                self.create_lesson(lesson_request: lesson_request)
            })
        }
    }
    @objc func decline_lesson_request() {
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.lesson_request["id"] as! Int, forKey: "lesson_request_id")
        parameters.setValue(self.lesson_request["student_id"] as! Int, forKey: "student_id")
        parameters.setValue(self.lesson_request["instructor_id"] as! Int, forKey: "instructor_id")
//        parameters.setValue(false, forKey: "is_open")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.decline_lesson_request(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.lesson_request = response
                
                self.app_delegate.remove_activity_view_controller()
                self.show_success_alert()
//                self.create_lesson(lesson_request: lesson_request)
            })
        }
    }
    @objc func create_lesson(lesson_request: NSDictionary) {
        print("create_lesson")
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(lesson_request["id"] as! Int, forKey: "lesson_request_id")
        parameters.setValue(lesson_request["student_id"] as! Int, forKey: "student_id")
        parameters.setValue(lesson_request["instructor_id"] as! Int, forKey: "instructor_id")
        
        let datetime_string = lesson_request["starts_at"] as! String
        parameters.setValue(Date().dateFromISO8601String(dateString: datetime_string).toString(format: "MMMM dd yyyy H:mm"), forKey: "starts_at")
        
        RestAPIClient.sharedInstance.create_lesson(parameters: parameters) { response in
            print(response)

            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()

                self.show_success_alert()
            })
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
//    @IBAction func next(sender: AnyObject) {
//        
//        let view_controller = ViewController_ProfileBio()
//        view_controller.profile_type = ProfileType.INSTRUCTOR
//        view_controller.settings = self.custom_settings
//        
//        if let topViewController = UIApplication.topViewController() {
//            topViewController.navigationController?.pushViewController(
//                view_controller,
//                animated: false
//            )
//        }
//        
//        //        let parameters = NSMutableDictionary()
//        //
//        //        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
//        //        parameters.setValue(custom_settings, forKey: "settings")
//        //
//        //        self.app_delegate.show_activity_view_controller(message: "Loading...")
//        //
//        //        RestAPIClient.sharedInstance.create_instructor_profile(parameters: parameters) { response in
//        //
//        //            print(response)
//        //
//        //            DispatchQueue.main.async(execute: {
//        //                self.app_delegate.remove_activity_view_controller()
//        //
//        //                let view_controller = ViewController_UserProfile()
//        //
//        //                if let topViewController = UIApplication.topViewController() {
//        //                    topViewController.navigationController?.pushViewController(
//        //                        view_controller,
//        //                        animated: false
//        //                    )
//        //                }
//        //            })
//        //        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

