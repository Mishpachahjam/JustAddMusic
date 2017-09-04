//
//  ViewController_AccountTypeSelection.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/8/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

import FacebookLogin
import FacebookCore

import FBSDKCoreKit

class ViewController_AccountTypeSelection: BaseViewController {
    
    //var checkboxButtons: [CheckboxButton] = []
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    var facebook_data: NSDictionary = [:]
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_AccountTypeSelection", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_AccountTypeSelection", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_AccountTypeSelection", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_AccountTypeSelection", owner: self, options: nil)
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
        
    }
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
    
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        
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
                self.stackView.addArrangedSubview(self.createLabel(text: "Hey, \(first_name)!", size: 16))
            }
            self.stackView.addArrangedSubview(self.createLabel(text: "Are you?", size: 14))
        } else {
            self.addSpacer()
            self.stackView.addArrangedSubview(self.createLabel(text: "Hey, there!", size: 16))
            self.stackView.addArrangedSubview(self.createLabel(text: "Are you?", size: 14))
        }

        self.addSpacer()
        let button_become_student = self.createButton(caption: "A Student")
        button_become_student.addTarget(self, action: #selector(self.action_become_student), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_become_student)
        
        let button_become_instructor = self.createButton(caption: "An Instructor")
        button_become_instructor.addTarget(self, action: #selector(self.action_become_instructor), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_become_instructor)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "Choose what best describe you")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
    }
    @objc func action_become_instructor(sender: AnyObject) {
        print("action_become_instuctor")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
        parameters.setValue(true, forKey: "is_instructor")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_instructor_profile_settings(parameters: parameters) { response in
            
            print(response)

            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_InstructorSettings()
                view_controller.default_settings = response["settings"] as! NSDictionary
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_become_student(sender: AnyObject) {
        print("action_become_student")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
        parameters.setValue(true, forKey: "is_student")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_student_profile_settings(parameters: parameters) { response in
            
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                let view_controller = ViewController_StudentSettings()
                view_controller.default_settings = response["settings"] as! NSDictionary
                
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
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
