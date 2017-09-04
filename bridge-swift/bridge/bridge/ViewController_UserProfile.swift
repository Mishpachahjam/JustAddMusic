//
//  ViewController_UserProfile.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/16/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import FacebookLogin
import FacebookCore

class ViewController_UserProfile: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var button_back: UIButton!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    var default_settings: NSDictionary = [:]
    
    var profile_data: NSDictionary = [:]
    var facebook_data: NSDictionary = [:]
    var lesson_requests: [Any] = []
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_UserProfile", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_UserProfile", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_UserProfile", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_UserProfile", owner: self, options: nil)
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
        
        if (self.app_delegate.me.id == self.profile_data["user_id"] as! Int) {
            self.button_back.isHidden = true
        } else {
            self.button_back.isHidden = false
        }
        
        // SET UP STACK
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(self.scrollView)
        
        self.stackView = UIStackView()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = UILayoutConstraintAxis.vertical
        self.stackView.distribution = UIStackViewDistribution.equalSpacing
        self.stackView.alignment = UIStackViewAlignment.center
        self.stackView.spacing = 10
        // SET UP STACK
        
        
        self.assembleInterface()
        
        self.scrollView.addSubview(self.stackView)
        self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        self.scrollView.bounces = false
        
        //
        self.get_user_data()
        //
        
        print(profile_data)
    }
    
    func update_interface() {
        
//        self.button_show_schedule.setNeedsLayout()
//        self.button_show_history.setNeedsLayout()
        
        if (self.lesson_count > 0) {
            self.button_show_schedule.setTitle("Schedule (\(self.lesson_count))", for: .normal)
            self.button_show_schedule.backgroundColor = PANTONE_greenery
        } else {
            self.button_show_schedule.setTitle("Schedule (\(self.lesson_count))", for: .normal)
        }
        
        if (self.lesson_request_count > 0) {
            self.button_show_history.setTitle("History (\(self.lesson_request_count))", for: .normal)
            self.button_show_history.backgroundColor = PANTONE_greenery
        } else {
            self.button_show_history.setTitle("History (\(self.lesson_request_count))", for: .normal)
        }
    }

    var lesson_count = 0
    var lesson_request_count = 0

    func get_user_data() {
        print("get_user_data")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(self.app_delegate.me.is_student, forKey: "is_student")
        parameters.setValue(self.app_delegate.me.is_instructor, forKey: "is_instructor")
        
        RestAPIClient.sharedInstance.get_user_data(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                print("DONE!")
                
                self.lesson_count = response["lesson_count"] as! Int
                self.lesson_request_count = response["lesson_request_count"] as! Int
                
                self.update_interface()
            })
        }
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
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        
        self.addSpacer()
        
        // TEXT FIELD
        self.stackView.addArrangedSubview(self.createLabel(text: "User Profile", size: 16))

        if (self.app_delegate.me.id == self.profile_data["user_id"] as! Int) {
            self.assemble_private_profile()
        } else {
            self.assemble_public_profile()
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
    
    // MARK: PUBLIC
    func assemble_public_profile() {
        
        if (self.app_delegate.me.is_student) {
            self.assemble_public_instructor_interface()
        }
        else if (self.app_delegate.me.is_instructor) {
            self.assemble_public_student_interface()
        }
    }
    func assemble_public_student_interface() {
        self.stackView.addArrangedSubview(self.createLabel(text: "Student", size: 14))
        
        self.assebmle_public_facebook_interface()

        if let text = profile_data["bio"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Bio:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["main_instrument_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Main Instrument:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["playing_level_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Playing Level:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let toggle = profile_data["is_open_to_jam"] as? Bool {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Open to jam:", size: 16))
            
            if (toggle) {
                self.stackView.addArrangedSubview(self.createLabel(text: "Yes", size: 14))
            } else {
                self.stackView.addArrangedSubview(self.createLabel(text: "No", size: 14))
            }
        }
        
        self.addSpacer()
        
//        let button_offer_lesson = self.createButton(caption: "Offer A Lesson")
//        button_offer_lesson.addTarget(self, action: #selector(self.action_offer_lesson), for: UIControlEvents.touchUpInside)
//        self.stackView.addArrangedSubview(button_offer_lesson)
        
        let button_message = self.createButton(caption: "Message")
        button_message.addTarget(self, action: #selector(self.action_message), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_message)
    }
    func assemble_public_instructor_interface() {
        self.stackView.addArrangedSubview(self.createLabel(text: "Instructor", size: 14))
        
        self.assebmle_public_facebook_interface()
        
        if let text = profile_data["bio"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Bio:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["main_instrument_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Main Instrument:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["instructor_experience_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Instructor Experience:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let toggle = profile_data["is_open_to_jam"] as? Bool {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Open to jam:", size: 16))
            
            if (toggle) {
                self.stackView.addArrangedSubview(self.createLabel(text: "Yes", size: 14))
            } else {
                self.stackView.addArrangedSubview(self.createLabel(text: "No", size: 14))
            }
        }
        
        self.addSpacer()
        
        if (self.lesson_requests.isEmpty) {
            let button_request_lesson = self.createButton(caption: "Request A Lesson")
            button_request_lesson.addTarget(self, action: #selector(self.action_request_lesson), for: UIControlEvents.touchUpInside)
            self.stackView.addArrangedSubview(button_request_lesson)
        } else {
            let button_preview_request_lesson = self.createButton(caption: "Preview Lesson Request")
            button_preview_request_lesson.addTarget(self, action: #selector(self.action_preview_pending_request_lesson), for: UIControlEvents.touchUpInside)
            self.stackView.addArrangedSubview(button_preview_request_lesson)
        }
        
        let button_message = self.createButton(caption: "Message")
        button_message.addTarget(self, action: #selector(self.action_message), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_message)
    }
    func assebmle_public_facebook_interface() {
        if !self.facebook_data.allKeys.isEmpty {
            if let picture_url = self.facebook_data["picture_url"] as? String {
                let picture = self.create_image_view_with_url(url: picture_url, width: self.screenWidth / 2, height: self.screenWidth / 2)
                picture.layer.cornerRadius = picture.frame.size.height / 2
                picture.layer.borderWidth = 4
                picture.layer.borderColor = UIColor.black.cgColor
                picture.clipsToBounds = true
                
                self.stackView.addArrangedSubview(picture)
            }
            
            self.addSpacer()
            
            if let first_name = self.facebook_data["first_name"] as? String {
                self.stackView.addArrangedSubview(self.createLabel(text: "\(first_name)", size: 14))
            }
            if let last_name = self.facebook_data["last_name"] as? String {
                self.stackView.addArrangedSubview(self.createLabel(text: "\(last_name)", size: 14))
            }
        }
    }
    
    // MARK: PUBLIC
    
    
    // MARK: PRIVATE
    
    func assemble_private_profile() {
        
        let button_edit_profile = self.createTextButton(caption: "Update Details", captionHeight: 14, buttonHeight: 24)
        button_edit_profile.addTarget(self, action: #selector(self.action_edit_profile), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_edit_profile)

        if (self.app_delegate.me.is_instructor) {
            self.assemble_private_instructor_interface()
        }
        else if (self.app_delegate.me.is_student) {
            self.assemble_private_student_interface()
        }
        
        let button_logout = self.createButton(caption: "Logout")
        button_logout.addTarget(self, action: #selector(self.action_logout), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_logout)
    }
    func assemble_private_student_interface() {
        self.assemble_private_facebook_interface()
        
        self.addSpacer()

        self.stackView.addArrangedSubview(self.createLabel(text: "You are a student.", size: 14))
        
        if let text = profile_data["bio"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Bio:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["main_instrument_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Main Instrument:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["playing_level_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Playing Level:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let toggle = profile_data["is_open_to_jam"] as? Bool {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Open to jam:", size: 16))
            
            if (toggle) {
                self.stackView.addArrangedSubview(self.createLabel(text: "Yes", size: 14))
            } else {
                self.stackView.addArrangedSubview(self.createLabel(text: "No", size: 14))
            }
        }
        
        self.addSpacer()
        
        let button_login = self.createButton(caption: "Find an Instructor")
        button_login.addTarget(self, action: #selector(self.action_find_instructor), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_login)
        
        let button_show_messages = self.createButton(caption: "Messages")
        button_show_messages.addTarget(self, action: #selector(self.action_show_messages), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_messages)
        
        self.button_show_schedule = self.createButton(caption: "Schedule (\(self.lesson_count))")
        self.button_show_schedule.addTarget(self, action: #selector(self.action_show_schedule), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_schedule)
        
        self.button_show_history = self.createButton(caption: "History (0)")
        self.button_show_history.addTarget(self, action: #selector(self.action_show_student_history), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_history)
    }
    func assemble_private_instructor_interface() {
        self.assemble_private_facebook_interface()
        
        self.addSpacer()

        self.stackView.addArrangedSubview(self.createLabel(text: "You are an instructor.", size: 14))
        
        if let text = profile_data["bio"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Bio:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["main_instrument_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Main Instrument:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let text = profile_data["instructor_experience_friendly"] as? String {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Instructor Experience:", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: text, size: 14))
        }
        
        if let toggle = profile_data["is_open_to_jam"] as? Bool {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Open to jam:", size: 16))
            
            if (toggle) {
                self.stackView.addArrangedSubview(self.createLabel(text: "Yes", size: 14))
            } else {
                self.stackView.addArrangedSubview(self.createLabel(text: "No", size: 14))
            }
        }
        
        self.addSpacer()
        
        let button_login = self.createButton(caption: "Find a Student")
        button_login.addTarget(self, action: #selector(self.action_find_student), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_login)
        
        let button_show_messages = self.createButton(caption: "Messages")
        button_show_messages.addTarget(self, action: #selector(self.action_show_messages), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_messages)
        
        self.button_show_schedule = self.createButton(caption: "Schedule")
        self.button_show_schedule.addTarget(self, action: #selector(self.action_show_schedule), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_schedule)
    
        self.button_show_history = self.createButton(caption: "History")
        self.button_show_history.addTarget(self, action: #selector(self.action_show_instructor_history), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_show_history)
    }
    
    var button_show_history = UIButton()
    var button_show_schedule = UIButton()
    
    func assemble_private_facebook_interface() {
//        if !self.facebook_data.allKeys.isEmpty {
//            self.stackView.addArrangedSubview(self.createLabel(text: "Logged in as:", size: 16))
        
//            if let picture_url = self.facebook_data["picture_url"] as? String {
                let picture = self.create_image_view_with_url(url: self.app_delegate.me.facebook_picture_url, width: self.screenWidth / 2, height: self.screenWidth / 2)
                picture.layer.cornerRadius = picture.frame.size.height / 2
                picture.layer.borderWidth = 4
                picture.layer.borderColor = UIColor.black.cgColor
                picture.clipsToBounds = true
                
                self.stackView.addArrangedSubview(picture)
//            }
        
            self.addSpacer()
            
//            if let first_name = self.facebook_data["first_name"] as? String {
                self.stackView.addArrangedSubview(self.createLabel(text: "\(self.app_delegate.me.facebook_first_name)", size: 14))
//            }
//            if let last_name = self.facebook_data["last_name"] as? String {
                self.stackView.addArrangedSubview(self.createLabel(text: "\(self.app_delegate.me.facebook_last_name)", size: 14))
//            }
//        }
    }
    // MARK: PRIVATE
    
    @objc func action_show_messages() {
        print("show messages")
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_message_roster(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_MessageList()
                view_controller.users = response["users"] as! [Any]
                
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_find_instructor() {
        print("action_find_instructor")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_available_instructors(parameters: parameters) { response in
            
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_InstructorList()
                view_controller.instructors = response["instructor_profiles"] as! [Any]
                
                if let topViewController = UIApplication.topViewController() {
                    topViewController.navigationController?.pushViewController(
                        view_controller,
                        animated: false
                    )
                }
            })
        }
    }
    @objc func action_find_student() {
        print("action_find_student")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_available_students(parameters: parameters) { response in
            
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_StudentList()
                view_controller.students = response["student_profiles"] as! [Any]
                
                if let topViewController = UIApplication.topViewController() {
                    topViewController.navigationController?.pushViewController(
                        view_controller,
                        animated: false
                    )
                }
            })
        }
    }
    @objc func action_message() {
        print("action_message")
        
        let parameters = NSMutableDictionary()

        let user = self.profile_data["user"] as! NSDictionary

        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(user["id"] as! Int, forKey: "sender_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_messages(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_MessageUser()
                view_controller.messages = response["messages"] as! [Any]
                
                let user = self.profile_data["user"] as! NSDictionary
                view_controller.receiver_id = user["id"] as! Int
                    
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_request_lesson() {
        print("action_request_lesson")
        
        DispatchQueue.main.async(execute: {
            
            let view_controller = ViewController_LessonRequest()
            view_controller.instructor = self.profile_data
            
            self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
        })
    }
    @objc func action_preview_pending_request_lesson() {
        print("action_preview_pending_request_lesson")
        
        let lesson_request = lesson_requests[0] as! NSDictionary
        
        let id = lesson_request["id"] as! Int
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(id, forKey: "lesson_request_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_lesson_request(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_LessonRequestPreview()
                view_controller.lesson_request = response["lesson_request"] as! NSDictionary
                
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_offer_lesson() {
        print("action_offer_lesson")
    }
    @objc func action_show_schedule() {
        print("action_schedule")
        
        DispatchQueue.main.async(execute: {
            let view_controller = ViewController_Schedule()
            self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
        })
    }
    @objc func action_show_student_history() {
        print("action_show_student_history")
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_student_history(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_History()
                
                view_controller.lesson_requests = response["lesson_requests"] as! [Any]
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_show_instructor_history() {
        print("action_show_instructor_history")
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_instructor_history(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_History()
                
                view_controller.lesson_requests = response["lesson_requests"] as! [Any]
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_edit_profile() {
        print("action_edit_profile")
        
        if (self.app_delegate.me.is_instructor) {
            
            let parameters = NSMutableDictionary()
            parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
            parameters.setValue(true, forKey: "is_instructor")
            
            self.app_delegate.show_activity_view_controller(message: "Loading...")
            
            RestAPIClient.sharedInstance.get_instructor_profile_settings(parameters: parameters) { response in
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    
                    let view_controller = ViewController_InstructorSettings()
                    view_controller.default_settings = response["settings"] as! NSDictionary
                    
                    let actual_settings: NSDictionary = [
                        "instructor_experience": self.profile_data["instructor_experience"] as! String,
                        "main_instrument": self.profile_data["main_instrument"] as! String,
                        "is_open_to_jam": self.profile_data["is_open_to_jam"] as! Bool,
                        "bio": self.profile_data["bio"] as! String
                    ]
                    view_controller.actual_settings = actual_settings
                    
                    self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
                })
            }
        } else if (self.app_delegate.me.is_student) {
            let parameters = NSMutableDictionary()
            parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
            parameters.setValue(true, forKey: "is_student")
            
            self.app_delegate.show_activity_view_controller(message: "Loading...")
            
            RestAPIClient.sharedInstance.get_student_profile_settings(parameters: parameters) { response in
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    let view_controller = ViewController_StudentSettings()
                    view_controller.default_settings = response["settings"] as! NSDictionary
                    
                    let actual_settings: NSDictionary = [
                        "main_instrument": self.profile_data["main_instrument"] as! String,
                        "playing_level": self.profile_data["playing_level"] as! String,
                        "is_open_to_jam": self.profile_data["is_open_to_jam"] as! Bool,
                        "bio": self.profile_data["bio"] as! String
                    ]
                    view_controller.actual_settings = actual_settings
                    
                    self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
                })
            }
        }
    }
    @objc func action_logout() {
        print("action_logout")
        
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            self.app_delegate.me.destroy()
            LoginManager().logOut()
            
            self.app_delegate.clear_login_data()
            
            self.app_delegate.navigation_controller.popToRootViewController(animated: false)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
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

