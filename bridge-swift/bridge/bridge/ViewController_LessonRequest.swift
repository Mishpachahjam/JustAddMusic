//
//  ViewController_LessonRequest.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/3/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

class ViewController_LessonRequest: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    var default_settings: NSDictionary = [:]
    var instructor: NSDictionary = [:]
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_LessonRequest", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_LessonRequest", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_LessonRequest", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_LessonRequest", owner: self, options: nil)
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
    
    var lesson_description_text_field = UITextField()
    var lesson_bounty_text_field = UITextField()
    
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Request A Lesson", size: 16))
        
        self.addSpacer()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let timestamp = dateFormatter.string(from: self.lesson_date)
        
        self.stackView.addArrangedSubview(self.createLabel(text: "\(timestamp)", size: 16))
        
        self.addSpacer()
        let button_select_date = self.createButton(caption: "Change Date")
        button_select_date.addTarget(self, action: #selector(self.action_select_date), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_select_date)
        
        self.addSpacer()
        
        // INPUT FIELDS
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        
        self.stackView.addArrangedSubview(self.createLabel(text: "What do you want to learn?", size: 16))
        
        self.lesson_description_text_field = self.createTextField(placeholder: "Ex. Major scale, voice warmup, song")
//        self.lesson_description_text_field.text = text
        self.lesson_description_text_field.delegate = self
        self.lesson_description_text_field.keyboardAppearance = .dark
        self.lesson_description_text_field.inputAccessoryView = keyboardDoneButtonView
        self.stackView.addArrangedSubview(self.lesson_description_text_field)
        
        self.stackView.addArrangedSubview(self.createLabel(text: "How much will you pay?", size: 16))
        
        self.lesson_bounty_text_field = self.createTextField(placeholder: "Ex. $50/hour or $100/lesson")
        //        self.lesson_description_text_field.text = text
        self.lesson_bounty_text_field.delegate = self
        self.lesson_bounty_text_field.keyboardAppearance = .dark
        self.lesson_bounty_text_field.inputAccessoryView = keyboardDoneButtonView
        self.stackView.addArrangedSubview(self.lesson_bounty_text_field)
        
        self.addSpacer()
        
        let button_lesson_request = self.createButton(caption: "Continue")
        button_lesson_request.addTarget(self, action: #selector(self.action_request_lesson), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_lesson_request)
        
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
    
    @objc func action_request_lesson() {
        print("action_request_lesson")
        let parameters = NSMutableDictionary()
        
        if (self.lesson_bounty_text_field.text!.isEmpty) {
            let alert = UIAlertController(title: "Input Error", message: "Lesson bounty required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else if (self.lesson_description_text_field.text!.isEmpty) {
            let alert = UIAlertController(title: "Input Error", message: "Lesson description required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        } else {
            parameters.setValue(self.app_delegate.me.id, forKey: "student_id")
            parameters.setValue(self.instructor["id"] as! Int, forKey: "instructor_id")
            parameters.setValue(self.lesson_date.toString(format: "MMMM dd yyyy H:mm"), forKey: "starts_at")
            parameters.setValue(self.lesson_bounty_text_field.text, forKey: "lesson_bounty")
            parameters.setValue(self.lesson_description_text_field.text, forKey: "lesson_description")
            
            self.app_delegate.show_activity_view_controller(message: "Loading...")
            
            RestAPIClient.sharedInstance.create_lesson_request(parameters: parameters) { response in
                print(response)
                
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    
                    self.close()
                    self.show_success_alert()
                })
            }
        }
    }
    
    var lesson_date = Date()
    
    @objc func action_select_date() {
        print("action_select_date")

        let view_controller = ViewController_LessonRequestDatePicker()
        
        view_controller.handler = {
            (data: NSDictionary) -> Void in
            print(data)
            
            self.lesson_date = data["date"] as! Date
        }
        
        self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)

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
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

