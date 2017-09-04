//
//  ViewController_Lesson.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/6/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//


import Foundation
import UIKit

class ViewController_Lesson: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    var lesson: NSDictionary = [:]
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Lesson", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Lesson", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Lesson", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Lesson", owner: self, options: nil)
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
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Lesson", size: 16))
        
        if (self.app_delegate.me.is_instructor) {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "id: \(self.lesson["id"] as! Int)", size: 14))
            
            let starts_at_string = self.lesson["starts_at"] as! String
            let starts_at = Date().dateFromISO8601String(dateString: starts_at_string)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timestamp = dateFormatter.string(from: starts_at)

            self.stackView.addArrangedSubview(self.createLabel(text: "starts_at?: \(timestamp)", size: 14))
            
            self.stackView.addArrangedSubview(self.createLabel(text: "student_id: \(self.lesson["student_id"] as! Int)", size: 14))
            
            self.addSpacer()
            
            let seconds_until = lesson["time_until"] as! Int
            if seconds_until <= 0 {
                self.stackView.addArrangedSubview(self.createLabel(text: "Lesson already happened.", size: 14))
            }
            
            self.addSpacer()
            
            let button_show_student_profile = self.createButton(caption: "Show Student Profile")
            button_show_student_profile.addTarget(self, action: #selector(self.action_show_student_profile), for: UIControlEvents.touchUpInside)
            self.stackView.addArrangedSubview(button_show_student_profile)
        }
        else if (self.app_delegate.me.is_student) {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "id: \(self.lesson["id"] as! Int)", size: 14))
            
            let starts_at_string = self.lesson["starts_at"] as! String
            let starts_at = Date().dateFromISO8601String(dateString: starts_at_string)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timestamp = dateFormatter.string(from: starts_at)
            
            self.stackView.addArrangedSubview(self.createLabel(text: "starts_at?: \(timestamp)", size: 14))
            
            self.stackView.addArrangedSubview(self.createLabel(text: "instructor_id: \(self.lesson["instructor_id"] as! Int)", size: 14))
           
            self.addSpacer()
            
            let seconds_until = lesson["time_until"] as! Int
            if seconds_until <= 0 {
                self.stackView.addArrangedSubview(self.createLabel(text: "Lesson already happened.", size: 14))
            }
            
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
        
        let student = self.lesson["student"] as! NSDictionary
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
        let instructor = self.lesson["instructor"] as! NSDictionary
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
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
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
